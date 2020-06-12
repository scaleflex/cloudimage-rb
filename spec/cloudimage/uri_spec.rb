# frozen_string_literal: true

describe Cloudimage::URI do
  before do
    @token = 'token'
    @client = Cloudimage::Client.new(token: @token)
    @base = "https://#{@token}.cloudimg.io/v7"
  end

  it 'does not catch missing methods' do
    expect { @client.path('/assets/image.jpg').random.to_url }
      .to raise_error NoMethodError
  end

  context 'no params' do
    it 'returns image URL' do
      expected = @base + '/assets/image.jpg'
      expect(@client.path('/assets/image.jpg').to_url).to eq expected
    end
  end

  context 'path without leading forward slash' do
    it 'returns image URL' do
      expected = @base + '/assets/image.jpg'
      expect(@client.path('assets/image.jpg').to_url).to eq expected
    end
  end

  context 'to_url with extra params' do
    it 'returns image URL with extra params merged' do
      expected = @base + '/assets/image.jpg?gravity=south&h=100&w=200'
      uri = @client.path('/assets/image.jpg').w(200).h(100)
      expect(uri.to_url(gravity: 'south')).to eq expected

      # Operation is idempotent
      expect(uri.to_url).to eq @base + '/assets/image.jpg?h=100&w=200'
    end

    it 'works by itself' do
      expected = @base + '/assets/image.jpg?gravity=south&w=200'
      uri = @client.path('/assets/image.jpg')
      expect(uri.to_url(gravity: 'south', w: 200)).to eq expected
    end
  end

  context 'standard operations' do
    it 'handles multiple params' do
      expected = @base + '/assets/image.jpg?gravity=south&h=100&w=200'
      uri = @client.path('/assets/image.jpg').w(200).h(100).gravity('south')
      expect(uri.to_url).to eq expected
    end
  end

  context 'flag params' do
    it 'works with no arguments' do
      expected = @base + '/assets/image.jpg?org_if_sml=1'
      expect(@client.path('/assets/image.jpg').prevent_enlargement.to_url)
        .to eq expected
    end

    it 'works just fine as a standard operation' do
      expected = @base + '/assets/image.jpg?sharp=1'
      expect(@client.path('/assets/image.jpg').sharper_resizing.to_url)
        .to eq expected
      expect(@client.path('/assets/image.jpg').sharp(1).to_url).to eq expected
    end

    it 'understands debug' do
      expected = @base + '/assets/image.jpg?ci_info=1'
      expect(@client.path('/assets/image.jpg').debug.to_url).to eq expected
    end
  end

  context 'resize mode' do
    it 'returns image URL' do
      expected = @base + '/assets/image.jpg?func=face'
      expect(@client.path('/assets/image.jpg').resize_mode('face').to_url)
        .to eq expected
      expect(@client.path('/assets/image.jpg').func('face').to_url)
        .to eq expected
    end
  end

  describe 'signature' do
    context 'no params' do
      it 'returns signed image URL' do
        client = Cloudimage::Client.new(token: 'token', salt: 'salt')
        expected = @base + '/assets/image.jpg?ci_sign=8e71efd440164f3cc8'
        expect(client.path('/assets/image.jpg').to_url).to eq expected
      end
    end

    context 'salt given' do
      it 'returns signed image URL' do
        client = Cloudimage::Client.new(token: @token, salt: 'salt')
        expected = @base + '/assets/image.jpg?w=200&ci_sign=84c81ef20852013046'
        expect(client.path('/assets/image.jpg').w(200).to_url).to eq expected
      end

      it 'returns trimmed signature if specified' do
        client = Cloudimage::Client.new(
          token: @token,
          salt: 'salt',
          signature_length: 8,
        )
        expected = @base + '/assets/image.jpg?w=200&ci_sign=84c81ef2'
        expect(client.path('/assets/image.jpg').w(200).to_url).to eq expected
      end

      it 'handles a mix of helpers and to_url params' do
        client = Cloudimage::Client.new(token: @token, salt: 'salt')
        expected = @base +
          '/assets/image.jpg?ci_info=1&h=100&w=200&ci_sign=40bd5a1d99455fe5cf'
        expect(client.path('/assets/image.jpg').debug.to_url(w: 200, h: 100))
          .to eq expected
      end
    end
  end

  context 'custom helpers' do
    describe 'positionable_crop' do
      it 'returns image URL with params encoded' do
        expected = @base + '/assets/image.jpg?br_px=420%2C530&tl_px=20%2C30'
        uri = @client.path('/assets/image.jpg')
          .positionable_crop(
            origin_x: 20,
            origin_y: 30,
            width: 400,
            height: 500,
          )
        expect(uri.to_url).to eq expected
      end
    end
  end
end

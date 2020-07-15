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

    it 'handles filter concatenation with param encoding' do
      expected = @base +
        '/assets/image.jpg?f=bright%3A15%2Ccontrast%3A30%2Cgrey'
      uri = @client.path('/assets/image.jpg')
        .f('bright:15', 'contrast:30', 'grey')
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

  describe 'aliases' do
    it 'handles perfix' do
      prefix = 'https://hello.s3.aws.com/'
      path = '/assets/image.jpg'
      url = prefix + path.delete_prefix('/')
      client = Cloudimage::Client.new(token: @token, aliases: { prefix => '' })
      expected = @base + path
      expect(client.path(url).to_url).to eq expected
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

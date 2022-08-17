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
      expected = "#{@base}/assets/image.jpg"
      expect(@client.path('/assets/image.jpg').to_url).to eq expected
    end
  end

  context 'path without leading forward slash' do
    it 'returns image URL' do
      expected = "#{@base}/assets/image.jpg"
      expect(@client.path('assets/image.jpg').to_url).to eq expected
    end
  end

  context 'to_url with extra params' do
    it 'returns image URL with extra params merged' do
      expected = "#{@base}/assets/image.jpg?gravity=south&h=100&w=200"
      uri = @client.path('/assets/image.jpg').w(200).h(100)
      expect(uri.to_url(gravity: 'south')).to eq expected

      # Operation is idempotent
      expect(uri.to_url).to eq "#{@base}/assets/image.jpg?h=100&w=200"
    end

    it 'works by itself' do
      expected = "#{@base}/assets/image.jpg?gravity=south&w=200"
      uri = @client.path('/assets/image.jpg')
      expect(uri.to_url(gravity: 'south', w: 200)).to eq expected
    end
  end

  context 'standard operations' do
    it 'handles multiple params' do
      expected = "#{@base}/assets/image.jpg?gravity=south&h=100&w=200"
      uri = @client.path('/assets/image.jpg').w(200).h(100).gravity('south')
      expect(uri.to_url).to eq expected
    end

    it 'handles filter concatenation with param encoding' do
      expected = "#{@base}/assets/image.jpg?" \
                 'f=bright%3A15%2Ccontrast%3A30%2Cgrey'
      uri = @client.path('/assets/image.jpg')
        .f('bright:15', 'contrast:30', 'grey')
      expect(uri.to_url).to eq expected
    end
  end

  context 'flag params' do
    it 'works with no arguments' do
      expected = "#{@base}/assets/image.jpg?org_if_sml=1"
      expect(@client.path('/assets/image.jpg').prevent_enlargement.to_url)
        .to eq expected
    end

    it 'works just fine as a standard operation' do
      expected = "#{@base}/assets/image.jpg?sharp=1"
      expect(@client.path('/assets/image.jpg').sharper_resizing.to_url)
        .to eq expected
      expect(@client.path('/assets/image.jpg').sharp(1).to_url).to eq expected
    end

    it 'understands debug' do
      expected = "#{@base}/assets/image.jpg?ci_info=1"
      expect(@client.path('/assets/image.jpg').debug.to_url).to eq expected
    end
  end

  context 'resize mode' do
    it 'returns image URL' do
      expected = "#{@base}/assets/image.jpg?func=face"
      expect(@client.path('/assets/image.jpg').resize_mode('face').to_url)
        .to eq expected
      expect(@client.path('/assets/image.jpg').func('face').to_url)
        .to eq expected
    end
  end

  describe 'aliases' do
    before { @url = 'https://hello.s3.aws.com/assets/image.jpg' }

    it 'handles prefix' do
      replace = 'https://hello.s3.aws.com/'
      client = Cloudimage::Client.new(token: @token, aliases: { replace => '' })
      expected = "#{@base}/assets/image.jpg"
      expect(client.path(@url).to_url).to eq expected
    end

    it 'supports multiple aliases' do
      hello = 'https://hello.s3.aws.com'
      uploads = 'https://store.s3-us-west-2.amazonaws.com/uploads'
      client = Cloudimage::Client.new(
        token: @token,
        aliases: { hello => '_hello_', uploads => '_uploads_' },
      )

      expected = "#{@base}/_hello_/assets/image.jpg"
      expect(client.path(@url).to_url).to eq expected

      url = "#{uploads}/assets/image.jpg"
      expected = "#{@base}/_uploads_/assets/image.jpg"
      expect(client.path(url).to_url).to eq expected
    end

    it 'supports automatic alias' do
      path = '/assets/image.jpg'
      url = "#{@base}#{path}"
      expect(@client.path(url).to_url).to eq url
    end

    it 'supports automatic alias when API version is toggled off' do
      client = Cloudimage::Client.new(cname: 'img.klimo.io',
                                      include_api_version: false)
      base = 'https://img.klimo.io'
      path = '/assets/image.jpg'
      expect(client.path(base + path).to_url).to eq base + path
    end

    it 'handles frozen hashes' do
      aliases = { 'https://hello.s3.aws.com/' => '' }.freeze
      client = Cloudimage::Client.new(token: @token, aliases: aliases)
      expected = "#{@base}/assets/image.jpg"
      expect(client.path(@url).to_url).to eq expected
    end
  end

  it 'handles custom CNAMEs' do
    client = Cloudimage::Client.new(cname: 'img.klimo.io')
    base = 'https://img.klimo.io/v7'
    path = '/assets/image.jpg'
    expect(client.path(path).to_url).to eq base + path
  end

  it 'allows for optional API version inclusion' do
    client = Cloudimage::Client.new(cname: 'img.klimo.io',
                                    include_api_version: false)
    base = 'https://img.klimo.io'
    path = '/assets/image.jpg'
    expect(client.path(path).to_url).to eq base + path
  end

  context 'custom helpers' do
    describe 'positionable_crop' do
      it 'returns image URL with params encoded' do
        expected = "#{@base}/assets/image.jpg?br_px=420%2C530&tl_px=20%2C30"
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

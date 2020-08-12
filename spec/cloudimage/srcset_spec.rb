# frozen_string_literal: true

describe Cloudimage::Srcset do
  before do
    @token = 'token'
    @client = Cloudimage::Client.new(token: @token)
    @base = "https://#{@token}.cloudimg.io/v7"
    @path = '/assets/image.jpg'
  end

  it 'returns simple srcset' do
    result = @client.path(@path).to_srcset
    urls = result.split(', ')

    expect(urls.size).to eq 9

    urls.each do |url|
      width = url.scan(/\d{3,4}+/)[0]
      expect(url).to eq "#{@base}#{@path}?w=#{width} #{width}w"
    end
  end

  it 'returns srcset with security' do
    client = Cloudimage::Client.new(token: @token, salt: 'salt')

    result = client.path(@path).to_srcset
    urls = result.split(', ')

    # By reconstructing each URL from path and width we make sure the
    # computed signatures in srcset match those generated individually.
    urls.each do |url|
      # This extracts integer from a string in format like "100 100w".
      width = Addressable::URI.parse(url).query_values['w'].to_i
      src = client.path(@path).w(width).to_url
      expect(url).to eq "#{src} #{width}w"
    end
  end

  it 'accepts arguments' do
    result = @client.path(@path).to_srcset(gray: 1)
    urls = result.split(', ')
    expect(urls).to all(include 'gray=1')
  end

  it 'ensures that passing in width does not override srcset widths' do
    width = 123
    result = @client.path(@path).to_srcset(w: width)
    expect(result).not_to include width.to_s
  end
end

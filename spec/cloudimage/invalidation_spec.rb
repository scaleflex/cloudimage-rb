# frozen_string_literal: true

describe Cloudimage::Invalidation do
  before do
    @api_key = 'secret'
    headers = {
      'X-Client-Key': @api_key,
      'Content-Type': 'application/json',
    }
    stub_request(:post, described_class::ENDPOINT)
      .with(headers: headers)
      .to_return(status: 201, body: fixture('invalidation_created.json'))
  end

  it 'raises an error when API key is not given' do
    client = Cloudimage::Client.new(token: 'token')
    expect do
      client.invalidate_original('/v7/image.jpg')
    end.to raise_error Cloudimage::InvalidConfig, /API key is required/
  end

  context 'with API key' do
    before do
      @client = Cloudimage::Client.new(token: 'token', api_key: @api_key)
    end

    describe '#invalidate_original' do
      it 'sends invalidation request' do
        paths = ['/v7/image.jpg', '/v7/image.png']
        @client.invalidate_original(*paths)
        expect(a_request(:post, described_class::ENDPOINT)
          .with(body: body_for('original', *paths)))
          .to have_been_made.once
      end
    end

    describe '#invalidate_urls' do
      it 'sends invalidation request' do
        path = '/v7/image.jpg'
        @client.invalidate_urls(path)
        expect(a_request(:post, described_class::ENDPOINT)
          .with(body: body_for('urls', path)))
          .to have_been_made.once
      end
    end

    describe '#invalidate_all' do
      it 'sends invalidation request' do
        @client.invalidate_all
        expect(a_request(:post, described_class::ENDPOINT)
          .with(body: { scope: 'all' }.to_json))
          .to have_been_made.once
      end
    end
  end
end

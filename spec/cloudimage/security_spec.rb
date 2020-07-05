# frozen_string_literal: true

describe Cloudimage::Security do
  before do
    @token = 'token'
    @client = Cloudimage::Client.new(token: @token, salt: 'salt')
    @base = "https://#{@token}.cloudimg.io/v7"
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
        expected = @base + '/assets/image.jpg?ci_sign=84c81ef20852013046&w=200'
        expect(client.path('/assets/image.jpg').w(200).to_url).to eq expected
      end

      it 'returns trimmed signature if specified' do
        client = Cloudimage::Client.new(
          token: @token,
          salt: 'salt',
          signature_length: 8,
        )
        expected = @base + '/assets/image.jpg?ci_sign=84c81ef2&w=200'
        expect(client.path('/assets/image.jpg').w(200).to_url).to eq expected
      end

      it 'handles a mix of helpers and to_url params' do
        client = Cloudimage::Client.new(token: @token, salt: 'salt')
        expected = @base +
          '/assets/image.jpg?ci_info=1&ci_sign=40bd5a1d99455fe5cf&h=100&w=200'
        expect(client.path('/assets/image.jpg').debug.to_url(w: 200, h: 100))
          .to eq expected
      end
    end
  end

  describe 'URL sealing' do
    before do
      @client = Cloudimage::Client.new(token: @token, salt: 'salt',
                                       sign_urls: false)
    end

    context 'no params' do
      it 'returns sealed image path' do
        expected = @base + '/assets/image.jpg?ci_seal=57e9278520bd99de50'
        expect(@client.path('/assets/image.jpg').to_url).to eq expected
      end

      it 'returns trimmed seal if specified' do
        client = Cloudimage::Client.new(
          token: @token,
          salt: 'salt',
          sign_urls: false,
          signature_length: 8,
        )
        expected = @base + '/assets/image.jpg?ci_seal=57e92785'
        expect(client.path('/assets/image.jpg').to_url).to eq expected
      end
    end

    context 'no sealed params' do
      it 'returns sealed image path with params appended' do
        expected = @base + '/assets/image.jpg?ci_seal=57e9278520bd99de50&w=200'
        expect(@client.path('/assets/image.jpg').w(200).to_url).to eq expected
      end
    end

    context 'sealed params' do
      it 'returns sealed image URL' do
        expected = @base + '/assets/image.jpg?' \
          'ci_eqs=Ymx1cj0yMCZoPTMwMCZ3PTMwMA&ci_seal=b7b7a8fde707bed4b4'

        # Using basic encode64 for these params would add padding, so here
        # we're testing no padding is added to the eqs value.
        result = @client.path('/assets/image.jpg')
          .blur(20)
          .w(300)
          .h(300)
          .seal_params(:w, :h, :blur)
          .to_url
        expect(result).to eq expected
      end

      it 'understands partial seal' do
        expected = @base + '/assets/image.jpg?' \
          'ci_eqs=Ymx1cj0yMCZoPTMwMA&ci_seal=a49adc8f592ef99188&w=100'

        result = @client.path('/assets/image.jpg')
          .w(100)
          .h(300)
          .blur(20)
          .seal_params('blur', :h) # Both strings and symbols are accepted.
          .to_url
        expect(result).to eq expected
      end

      it 'works with params passed into to_url' do
        expected = @base + '/assets/image.jpg?' \
          'ci_eqs=Ymx1cj0yMCZoPTMwMCZ3PTMwMA&ci_seal=b7b7a8fde707bed4b4'
        result = @client.path('/assets/image.jpg').to_url(
          blur: 20, w: 300, h: 300, seal_params: %i[w h blur],
        )
        expect(result).to eq expected
      end

      it 'works when params are passed in steps' do
        expected = @base + '/assets/image.jpg?' \
          'ci_eqs=Ymx1cj0yMCZoPTMwMA&ci_seal=a49adc8f592ef99188&w=100'

        uri = @client.path('/assets/image.jpg')
        uri.w(100).h(300).seal_params(:h)
        result = uri.to_url(blur: 20, seal_params: %w[blur])
        expect(result).to eq expected
      end
    end
  end
end

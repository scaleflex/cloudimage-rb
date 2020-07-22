# frozen_string_literal: true

describe Cloudimage::Client do
  describe 'initialization' do
    it 'raises an error without a token or a CNAME' do
      expect { described_class.new }
        .to raise_error Cloudimage::InvalidConfig, /specify your customer token/
    end

    it 'accepts CNAME config' do
      expect { described_class.new(cname: 'img.example.com') }
        .not_to raise_error
    end

    context 'URL signatures' do
      it 'has a default signature length' do
        client = described_class.new(token: 'mytoken')
        expect((6..40)).to cover client.config[:signature_length]
      end

      it 'raises an error when given an invalid signature length' do
        expect do
          described_class.new(token: 'token', salt: 'slt', signature_length: 5)
        end.to raise_error Cloudimage::InvalidConfig, /Signature length must be/
      end
    end
  end
end

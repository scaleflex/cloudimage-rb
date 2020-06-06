# frozen_string_literal: true

describe Cloudimage::Client do
  describe 'initialization' do
    it 'raises an error without a token' do
      expect { described_class.new }
        .to raise_error Cloudimage::InvalidConfig, /Cloudimage customer token/
    end
  end
end

# frozen_string_literal: true

module SpecHelpers
  module FileHelpers
    def fixture(filename)
      File.open('spec/fixtures/' + filename)
    end
  end
end

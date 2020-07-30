# frozen_string_literal: true

module SpecHelpers
  module InvalidationHelpers
    def body_for(type, *paths)
      {
        scope: type,
        urls: paths,
      }.to_json
    end
  end
end

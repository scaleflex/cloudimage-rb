# frozen_string_literal: true

module Cloudimage
  module CustomHelpers
    def positionable_crop(origin_x:, origin_y:, width:, height:)
      tl_px(origin_x, origin_y).br_px(origin_x + width, origin_y + height)
    end

    def seal_params(*query_params)
      # URI#query_values returns hash where keys are strings.
      sealed_params.merge(query_params.map(&:to_s))
      self
    end
  end
end

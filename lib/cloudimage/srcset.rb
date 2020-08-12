# frozen_string_literal: true

module Cloudimage
  module Srcset
    # 5760 is 3x 1920 (the largest common screen width):
    # https://gs.statcounter.com/screen-resolution-stats
    SRCSET_RANGE = (100..5_760).freeze
    SRCSET_GROWTH_FACTOR = 1.67

    def to_srcset(**extra_params)
      srcset_widths
        .map { |width| "#{to_url(**extra_params, w: width)} #{width}w" }
        .join(', ')
    end

    private

    def srcset_widths
      current = SRCSET_RANGE.begin

      [].tap do |widths|
        loop do
          widths << current
          current = (current * SRCSET_GROWTH_FACTOR).round(-1)

          break if current >= SRCSET_RANGE.end && widths << SRCSET_RANGE.end
        end
      end
    end
  end
end

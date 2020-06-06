# frozen_string_literal: true

module Cloudimage
  module Params
    ALIASES = {
      debug: :ci_info,
      prevent_enlargement: :org_if_sml,
      rotate: :r,
      sharper_resizing: :sharp,
      resize_mode: :func,
    }.freeze

    PARAMS = %i[
      bg_blur
      bg_color
      bg_colorize
      bg_colour
      bg_colourise
      bg_img_fit
      bg_opacity
      br_px
      ci_info
      func
      gravity
      h
      height
      org_if_sml
      r
      sharp
      tl_px
      trim
      w
      width
    ].freeze
  end
end

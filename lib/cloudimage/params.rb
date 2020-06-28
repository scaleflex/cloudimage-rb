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
      blur
      blur_faces
      br_px
      bright
      ci_info
      contrast
      doc_page
      f
      force_format
      func
      gravity
      gray
      grey
      h
      height
      optipress
      org_if_sml
      p
      pixelate
      pixellate
      process
      q
      r
      radius
      sharp
      tl_px
      trim
      w
      wat
      wat_color
      wat_colour
      wat_url
      wat_font
      wat_fontsize
      wat_gravity
      wat_opacity
      wat_pad
      wat_scale
      wat_text
      width
    ].freeze
  end
end

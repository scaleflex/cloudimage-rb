# frozen_string_literal: true

module Cloudimage
  module Refinements
    unless {}.respond_to?(:slice)
      refine Hash do
        def slice(*keys)
          keys.each_with_object({}) do |k, acc|
            acc[k] = self[k] if key?(k)
          end
        end
      end
    end

    unless ''.respond_to?(:delete_prefix)
      refine String do
        def delete_prefix(prefix)
          sub(/\A#{prefix}/, '')
        end
      end
    end
  end
end

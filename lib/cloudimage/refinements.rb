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

    unless Kernel.respond_to?(:yield_self)
      refine Kernel do
        def yield_self
          unless block_given?
            return ::Enumerator.new(1) do |yielder|
              yielder.yield(self)
            end
          end

          yield(self)
        end
      end
    end

    unless Kernel.respond_to?(:then)
      refine Kernel do
        def then
          return yield_self unless block_given?

          yield_self(&::Proc.new)
        end
      end
    end
  end
end

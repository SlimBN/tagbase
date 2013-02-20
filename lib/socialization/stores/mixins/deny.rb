module Socialization
  module Stores
    module Mixins
      module Deny

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :denier, :deniable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_deny(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_undeny(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(denier, deniable)
          self.send(@after_create_hook, denier, deniable) if @after_create_hook
          touch_dependents(denier, deniable)
        end

        def call_after_destroy_hooks(denier, deniable)
          self.send(@after_destroy_hook, denier, deniable) if @after_destroy_hook
          touch_dependents(denier, deniable)
        end

      end
    end
  end
end
module Socialization
  module Stores
    module Mixins
      module Confirm

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :confirmer, :confirmable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_confirm(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_unconfirm(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(confirmer, confirmable)
          self.send(@after_create_hook, confirmer, confirmable) if @after_create_hook
          touch_dependents(confirmer, confirmable)
        end

        def call_after_destroy_hooks(confirmer, confirmable)
          self.send(@after_destroy_hook, confirmer, confirmable) if @after_destroy_hook
          touch_dependents(confirmer, confirmable)
        end

      end
    end
  end
end
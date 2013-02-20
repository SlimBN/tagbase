module ActiveRecord
  class Base
    def is_confirmable?
      false
    end
    alias confirmable? is_confirmable?
  end
end

module Socialization
  module Confirmable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.confirm_model.remove_confirmers(self) }

      # Specifies if self can be confirmed.
      #
      # @return [Boolean]
      def is_confirmable?
        true
      end
      alias confirmable? is_confirmable?

      # Specifies if self is confirmed by a {Confirmer} object.
      #
      # @return [Boolean]
      def confirmed_by?(confirmer)
        raise Socialization::ArgumentError, "#{confirmer} is not confirmer!"  unless confirmer.respond_to?(:is_confirmer?) && confirmer.is_confirmer?
        Socialization.confirm_model.confirms?(confirmer, self)
      end

      # Returns an array of {Confirmer}s confirming self.
      #
      # @param [Class] klass the {Confirmer} class to be included. e.g. `User`
      # @return [Array<Confirmer, Numeric>] An array of Confirmer objects or IDs
      def confirmers(klass, opts = {})
        Socialization.confirm_model.confirmers(self, klass, opts)
      end

      # Returns a scope of the {Confirmer}s confirming self.
      #
      # @param [Class] klass the {Confirmer} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def confirmers_relation(klass, opts = {})
        Socialization.confirm_model.confirmers_relation(self, klass, opts)
      end

    end
  end
end
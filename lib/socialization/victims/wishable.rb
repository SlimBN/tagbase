module ActiveRecord
  class Base
    def is_wishable?
      false
    end
    alias wishable? is_wishable?
  end
end

module Socialization
  module Wishable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.wish_model.remove_wishers(self) }

      # Specifies if self can be wishd.
      #
      # @return [Boolean]
      def is_wishable?
        true
      end
      alias wishable? is_wishable?

      # Specifies if self is wishd by a {Wisher} object.
      #
      # @return [Boolean]
      def wishd_by?(wisher)
        raise Socialization::ArgumentError, "#{wisher} is not wisher!"  unless wisher.respond_to?(:is_wisher?) && wisher.is_wisher?
        Socialization.wish_model.wishes?(wisher, self)
      end

      # Returns an array of {Wisher}s wishing self.
      #
      # @param [Class] klass the {Wisher} class to be included. e.g. `User`
      # @return [Array<Wisher, Numeric>] An array of Wisher objects or IDs
      def wishers(klass, opts = {})
        Socialization.wish_model.wishers(self, klass, opts)
      end

      # Returns a scope of the {Wisher}s wishing self.
      #
      # @param [Class] klass the {Wisher} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def wishers_relation(klass, opts = {})
        Socialization.wish_model.wishers_relation(self, klass, opts)
      end

    end
  end
end
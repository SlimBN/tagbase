module ActiveRecord
  class Base
    def is_deniable?
      false
    end
    alias deniable? is_deniable?
  end
end

module Socialization
  module Deniable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.deny_model.remove_deniers(self) }

      # Specifies if self can be denyd.
      #
      # @return [Boolean]
      def is_deniable?
        true
      end
      alias deniable? is_deniable?

      # Specifies if self is denyd by a {Denier} object.
      #
      # @return [Boolean]
      def denyd_by?(denier)
        raise Socialization::ArgumentError, "#{denier} is not denier!"  unless denier.respond_to?(:is_denier?) && denier.is_denier?
        Socialization.deny_model.denies?(denier, self)
      end

      # Returns an array of {Denier}s denying self.
      #
      # @param [Class] klass the {Denier} class to be included. e.g. `User`
      # @return [Array<Denier, Numeric>] An array of Denier objects or IDs
      def deniers(klass, opts = {})
        Socialization.deny_model.deniers(self, klass, opts)
      end

      # Returns a scope of the {Denier}s denying self.
      #
      # @param [Class] klass the {Denier} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def deniers_relation(klass, opts = {})
        Socialization.deny_model.deniers_relation(self, klass, opts)
      end

    end
  end
end
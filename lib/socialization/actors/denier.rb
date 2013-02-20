module ActiveRecord
  class Base
    def is_denier?
      false
    end
    alias denier? is_denier?
  end
end

module Socialization
  module Denier
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.deny_model.remove_deniables(self) }

      # Specifies if self can deny {deniable} objects.
      #
      # @return [Boolean]
      def is_denier?
        true
      end
      alias denier? is_denier?

      # Create a new {deny deny} relationship.
      #
      # @param [deniable] deniable the object to be denyd.
      # @return [Boolean]
      def deny!(deniable)
        raise Socialization::ArgumentError, "#{deniable} is not deniable!"  unless deniable.respond_to?(:is_deniable?) && deniable.is_deniable?
        Socialization.deny_model.deny!(self, deniable)
      end

      # Delete a {deny deny} relationship.
      #
      # @param [deniable] deniable the object to undeny.
      # @return [Boolean]
      def undeny!(deniable)
        raise Socialization::ArgumentError, "#{deniable} is not deniable!" unless deniable.respond_to?(:is_deniable?) && deniable.is_deniable?
        Socialization.deny_model.undeny!(self, deniable)
      end

      # Toggles a {deny deny} relationship.
      #
      # @param [deniable] deniable the object to deny/undeny.
      # @return [Boolean]
      def toggle_deny!(deniable)
        raise Socialization::ArgumentError, "#{deniable} is not deniable!" unless deniable.respond_to?(:is_deniable?) && deniable.is_deniable?
        if denies?(deniable)
          undeny!(deniable)
          false
        else
          deny!(deniable)
          true
        end
      end

      # Specifies if self denies a {deniable} object.
      #
      # @param [deniable] deniable the {deniable} object to test against.
      # @return [Boolean]
      def denies?(deniable)
        raise Socialization::ArgumentError, "#{deniable} is not deniable!" unless deniable.respond_to?(:is_deniable?) && deniable.is_deniable?
        Socialization.deny_model.denies?(self, deniable)
      end

      # Returns all the deniables of a certain type that are denyd by self
      #
      # @params [deniable] klass the type of {deniable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<deniable, Numeric>] An array of deniable objects or IDs
      def deniables(klass, opts = {})
        Socialization.deny_model.deniables(self, klass, opts)
      end
      alias :deniees :deniables

      # Returns a relation for all the deniables of a certain type that are liked by self
      #
      # @params [deniable] klass the type of {deniable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def deniables_relation(klass, opts = {})
        Socialization.deny_model.deniables_relation(self, klass, opts)
      end
      alias :deniees_relation :deniables_relation
    end
  end
end
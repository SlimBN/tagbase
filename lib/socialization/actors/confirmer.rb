module ActiveRecord
  class Base
    def is_confirmer?
      false
    end
    alias confirmer? is_confirmer?
  end
end

module Socialization
  module Confirmer
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.confirm_model.remove_confirmables(self) }

      # Specifies if self can confirm {confirmable} objects.
      #
      # @return [Boolean]
      def is_confirmer?
        true
      end
      alias confirmer? is_confirmer?

      # Create a new {confirm confirm} relationship.
      #
      # @param [confirmable] confirmable the object to be confirmd.
      # @return [Boolean]
      def confirm!(confirmable)
        raise Socialization::ArgumentError, "#{confirmable} is not confirmable!"  unless confirmable.respond_to?(:is_confirmable?) && confirmable.is_confirmable?
        Socialization.confirm_model.confirm!(self, confirmable)
      end

      # Delete a {confirm confirm} relationship.
      #
      # @param [confirmable] confirmable the object to unconfirm.
      # @return [Boolean]
      def unconfirm!(confirmable)
        raise Socialization::ArgumentError, "#{confirmable} is not confirmable!" unless confirmable.respond_to?(:is_confirmable?) && confirmable.is_confirmable?
        Socialization.confirm_model.unconfirm!(self, confirmable)
      end

      # Toggles a {confirm confirm} relationship.
      #
      # @param [confirmable] confirmable the object to confirm/unconfirm.
      # @return [Boolean]
      def toggle_confirm!(confirmable)
        raise Socialization::ArgumentError, "#{confirmable} is not confirmable!" unless confirmable.respond_to?(:is_confirmable?) && confirmable.is_confirmable?
        if confirms?(confirmable)
          unconfirm!(confirmable)
          false
        else
          confirm!(confirmable)
          true
        end
      end

      # Specifies if self confirms a {confirmable} object.
      #
      # @param [confirmable] confirmable the {confirmable} object to test against.
      # @return [Boolean]
      def confirms?(confirmable)
        raise Socialization::ArgumentError, "#{confirmable} is not confirmable!" unless confirmable.respond_to?(:is_confirmable?) && confirmable.is_confirmable?
        Socialization.confirm_model.confirms?(self, confirmable)
      end

      # Returns all the confirmables of a certain type that are confirmd by self
      #
      # @params [confirmable] klass the type of {confirmable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<confirmable, Numeric>] An array of confirmable objects or IDs
      def confirmables(klass, opts = {})
        Socialization.confirm_model.confirmables(self, klass, opts)
      end
      alias :confirmes :confirmables

      # Returns a relation for all the confirmables of a certain type that are confirmd by self
      #
      # @params [confirmable] klass the type of {confirmable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def confirmables_relation(klass, opts = {})
        Socialization.confirm_model.confirmables_relation(self, klass, opts)
      end
      alias :confirmes_relation :confirmables_relation
    end
  end
end
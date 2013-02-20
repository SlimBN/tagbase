module Socialization
  module ActiveRecordStores
    class Confirm < ActiveRecord::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Confirm
      extend Socialization::ActiveRecordStores::Mixins::Base

      belongs_to :confirmer,    :polymorphic => true
      belongs_to :confirmable, :polymorphic => true

      scope :confirmed_by, lambda { |confirmer| where(
        :confirmer_type    => confirmer.class.table_name.classify,
        :confirmer_id      => confirmer.id)
      }

      scope :confirming,   lambda { |confirmable| where(
        :confirmable_type => confirmable.class.table_name.classify,
        :confirmable_id   => confirmable.id)
      }

      class << self
        def confirm!(confirmer, confirmable)
          unless confirms?(confirmer, confirmable)
            self.create! do |confirm|
              confirm.confirmer = confirmer
              confirm.confirmable = confirmable
            end
            call_after_create_hooks(confirmer, confirmable)
            true
          else
            false
          end
        end

        def unconfirm!(confirmer, confirmable)
          if confirms?(confirmer, confirmable)
            confirm_for(confirmer, confirmable).destroy_all
            call_after_destroy_hooks(confirmer, confirmable)
            true
          else
            false
          end
        end

        def confirms?(confirmer, confirmable)
          !confirm_for(confirmer, confirmable).empty?
        end

        # Returns an ActiveRecord::Relation of all the confirmers of a certain type that are confirming  confirmable
        def confirmers_relation(confirmable, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:confirmer_id).
              where(:confirmer_type => klass.table_name.classify).
              where(:confirmable_type => confirmable.class.to_s).
              where(:confirmable_id => confirmable.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the confirmers of a certain type that are confirming  confirmable
        def confirmers(confirmable, klass, opts = {})
          rel = confirmers_relation(confirmable, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Returns an ActiveRecord::Relation of all the confirmables of a certain type that are confirmed by confirmer
        def confirmables_relation(confirmer, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:confirmable_id).
              where(:confirmable_type => klass.table_name.classify).
              where(:confirmer_type => confirmer.class.to_s).
              where(:confirmer_id => confirmer.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the confirmables of a certain type that are confirmed by confirmer
        def confirmables(confirmer, klass, opts = {})
          rel = confirmables_relation(confirmer, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Remove all the confirmers for confirmable
        def remove_confirmers(confirmable)
          self.where(:confirmable_type => confirmable.class.name.classify).
               where(:confirmable_id => confirmable.id).destroy_all
        end

        # Remove all the confirmables for confirmer
        def remove_confirmables(confirmer)
          self.where(:confirmer_type => confirmer.class.name.classify).
               where(:confirmer_id => confirmer.id).destroy_all
        end

      private
        def confirm_for(confirmer, confirmable)
          confirmed_by(confirmer).confirming( confirmable)
        end
      end # class << self

    end
  end
end

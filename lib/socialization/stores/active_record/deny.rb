module Socialization
  module ActiveRecordStores
    class Deny < ActiveRecord::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Deny
      extend Socialization::ActiveRecordStores::Mixins::Base

      belongs_to :denier,    :polymorphic => true
      belongs_to :deniable, :polymorphic => true

      scope :denied_by, lambda { |denier| where(
        :denier_type    => denier.class.table_name.classify,
        :denier_id      => denier.id)
      }

      scope :denying,   lambda { |deniable| where(
        :deniable_type => deniable.class.table_name.classify,
        :deniable_id   => deniable.id)
      }

      class << self
        def deny!(denier, deniable)
          unless denies?(denier, deniable)
            self.create! do |deny|
              deny.denier = denier
              deny.deniable = deniable
            end
            call_after_create_hooks(denier, deniable)
            true
          else
            false
          end
        end

        def undeny!(denier, deniable)
          if denies?(denier, deniable)
            deny_for(denier, deniable).destroy_all
            call_after_destroy_hooks(denier, deniable)
            true
          else
            false
          end
        end

        def denies?(denier, deniable)
          !deny_for(denier, deniable).empty?
        end

        # Returns an ActiveRecord::Relation of all the deniers of a certain type that are denying  deniable
        def deniers_relation(deniable, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:denier_id).
              where(:denier_type => klass.table_name.classify).
              where(:deniable_type => deniable.class.to_s).
              where(:deniable_id => deniable.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the deniers of a certain type that are denying  deniable
        def deniers(deniable, klass, opts = {})
          rel = deniers_relation(deniable, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Returns an ActiveRecord::Relation of all the deniables of a certain type that are denied by denier
        def deniables_relation(denier, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:deniable_id).
              where(:deniable_type => klass.table_name.classify).
              where(:denier_type => denier.class.to_s).
              where(:denier_id => denier.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the deniables of a certain type that are denied by denier
        def deniables(denier, klass, opts = {})
          rel = deniables_relation(denier, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Remove all the deniers for deniable
        def remove_deniers(deniable)
          self.where(:deniable_type => deniable.class.name.classify).
               where(:deniable_id => deniable.id).destroy_all
        end

        # Remove all the deniables for denier
        def remove_deniables(denier)
          self.where(:denier_type => denier.class.name.classify).
               where(:denier_id => denier.id).destroy_all
        end

      private
        def deny_for(denier, deniable)
          denied_by(denier).denying( deniable)
        end
      end # class << self

    end
  end
end

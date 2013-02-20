module Socialization
  module RedisStores
    class Deny < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Deny
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :deny!, :relation!;                          public :deny!
        alias_method :undeny!, :unrelation!;                      public :undeny!
        alias_method :denies?, :relation?;                         public :denies?
        alias_method :deniers_relation, :actors_relation;          public :deniers_relation
        alias_method :deniers, :actors;                            public :deniers
        alias_method :deniables_relation, :victims_relation;      public :deniables_relation
        alias_method :deniables, :victims;                        public :deniables
        alias_method :remove_deniers, :remove_actor_relations;     public :remove_deniers
        alias_method :remove_deniables, :remove_victim_relations; public :remove_deniables
      end

    end
  end
end

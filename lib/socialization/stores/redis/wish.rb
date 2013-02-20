module Socialization
  module RedisStores
    class Wish < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Wish
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :wish!, :relation!;                          public :wish!
        alias_method :unwish!, :unrelation!;                      public :unwish!
        alias_method :wishes?, :relation?;                         public :wishes?
        alias_method :wishers_relation, :actors_relation;          public :wishers_relation
        alias_method :wishers, :actors;                            public :wishers
        alias_method :wishables_relation, :victims_relation;      public :wishables_relation
        alias_method :wishables, :victims;                        public :wishables
        alias_method :remove_wishers, :remove_actor_relations;     public :remove_wishers
        alias_method :remove_wishables, :remove_victim_relations; public :remove_wishables
      end

    end
  end
end

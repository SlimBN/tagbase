module Socialization
  module RedisStores
    class Confirm < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Confirm
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :confirm!, :relation!;                          public :confirm!
        alias_method :unconfirm!, :unrelation!;                      public :unconfirm!
        alias_method :confirms?, :relation?;                         public :confirms?
        alias_method :confirmers_relation, :actors_relation;          public :confirmers_relation
        alias_method :confirmers, :actors;                            public :confirmers
        alias_method :confirmables_relation, :victims_relation;      public :confirmables_relation
        alias_method :confirmables, :victims;                        public :confirmables
        alias_method :remove_confirmers, :remove_actor_relations;     public :remove_confirmers
        alias_method :remove_confirmables, :remove_victim_relations; public :remove_confirmables
      end

    end
  end
end

require 'active_support/concern'

module Socialization
  module ActsAsHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      # Make the current class a {Socialization::Follower}
      def acts_as_follower(opts = {})
        include Socialization::Follower
      end

      # Make the current class a {Socialization::Followable}
      def acts_as_followable(opts = {})
        include Socialization::Followable
      end

      # Make the current class a {Socialization::Liker}
      def acts_as_liker(opts = {})
        include Socialization::Liker
      end

      # Make the current class a {Socialization::Likeable}
      def acts_as_likeable(opts = {})
        include Socialization::Likeable
      end

      # Make the current class a {Socialization::confirmer}
      def acts_as_confirmer(opts = {})
        include Socialization::Confirmer
      end

      # Make the current class a {Socialization::confirmable}
      def acts_as_confirmable(opts = {})
        include Socialization::Confirmable
      end


      # Make the current class a {Socialization::denier}
      def acts_as_denier(opts = {})
        include Socialization::Denier
      end

      # Make the current class a {Socialization::deniable}
      def acts_as_deniable(opts = {})
        include Socialization::Deniable
      end


      # Make the current class a {Socialization::wisher}
      def acts_as_wisher(opts = {})
        include Socialization::Wisher
      end

      # Make the current class a {Socialization::wishable}
      def acts_as_wishable(opts = {})
        include Socialization::Wishable
      end

      # Make the current class a {Socialization::Favoriter}
      def acts_as_favoriter(opts = {})
        include Socialization::Favoriter
      end

      # Make the current class a {Socialization::Favoritable}
      def acts_as_favoritable(opts = {})
        include Socialization::Favoritable
      end

      # Make the current class a {Socialization::Mentioner}
      def acts_as_mentioner(opts = {})
        include Socialization::Mentioner
      end

      # Make the current class a {Socialization::Mentionable}
      def acts_as_mentionable(opts = {})
        include Socialization::Mentionable
      end
    end
  end
end

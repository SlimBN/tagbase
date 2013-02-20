module Socialization
  class << self
    def follow_model
      if @follow_model
        @follow_model
      else
        ::Follow
      end
    end

    def follow_model=(klass)
      @follow_model = klass
    end

    def like_model
      if @like_model
        @like_model
      else
        ::Like
      end
    end

    def favorite_model=(klass)
      @favorite_model = klass
    end

    def favorite_model
      if @favorite_model
        @favorite_model
      else
        ::Favorite
      end
    end

    def like_model=(klass)
      @like_model = klass
    end

    def mention_model
      if @mention_model
        @mention_model
      else
        ::Mention
      end
    end

    def mention_model=(klass)
      @mention_model = klass
    end


    def confirm_model=(klass)
      @confirm_model = klass
    end

    def confirm_model
      if @confirm_model
        @confirm_model
      else
        ::Confirm
      end
    end


    def deny_model=(klass)
      @deny_model = klass
    end

    def deny_model
      if @deny_model
        @deny_model
      else
        ::Deny
      end
    end


    def wish_model=(klass)
      @wish_model = klass
    end

    def wish_model
      if @wish_model
        @wish_model
      else
        ::Wish
      end
    end


  end
end
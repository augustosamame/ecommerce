module Ecommerce

  class Ability
    include CanCan::Ability

    def initialize(user)
      # Define abilities for the passed in user here. For example:
      #
      user ||= User.new # guest user (not logged in)
      if user.admin?
        can :manage, :all
      elsif user.standard?
        can :read, Brand
        can :read, Property
        can :read, Category
        can :read, Product
        can :read, Testimonial
        can [:favorites, :stock_alert, :search], Product
        can :read, ProductSku
        can :read, ProductSkuProperty
        can :read, ProductProperty
        can :manage, User, {id: user.id}
        can :manage, Order, {user_id: user.id}
        can :manage, OrderItem, :order => { :user_id => user.id }
        can :manage, Address, {user_id: user.id}
        can :manage, Cart, {user_id: user.id}
        can :manage, CartItem, :cart => {user_id: user.id}
        can :manage, Wishlist, {user_id: user.id}
        can :manage, WishlistItem, :wishlist => {user_id: user.id}
        can :manage, Payment, {user_id: user.id}
        can :read, PaymentMethod
        can :manage, Card, {user_id: user.id}
        can :manage, StockAlert, {user_id: user.id}
      else
        #can :read, :all
      end
      #   user ||= User.new # guest user (not logged in)
      #   if user.admin?
      #     can :manage, :all
      #   else
      #     can :read, :all
      #   end
      #
      # The first argument to `can` is the action you are giving the user
      # permission to do.
      # If you pass :manage it will apply to every action. Other common actions
      # here are :read, :create, :update and :destroy.
      #
      # The second argument is the resource the user can perform the action on.
      # If you pass :all it will apply to every resource. Otherwise pass a Ruby
      # class of the resource.
      #
      # The third argument is an optional hash of conditions to further filter the
      # objects.
      # For example, here the user can only update published articles.
      #
      #   can :update, Article, :published => true
      #
      # See the wiki for details:
      # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    end
  end
end

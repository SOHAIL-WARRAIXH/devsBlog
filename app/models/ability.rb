# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      # Abilities for authenticated users
      can :read, Post
      can [:create, :update, :destroy], Post, user_id: user.id
      
      can :read, Comment
      can [:create, :destroy], Comment, user_id: user.id

      can [:read, :update], User, id: user.id
      can :read, User # Allow reading other user profiles

      can [:read, :show, :create], Conversation do |conversation|
         conversation.participants.include?(user)
      end
      
      can [:read, :create], Message do |message|
        message.conversation.participants.include?(user)
      end

      can [:like, :unlike], Post # Allow authenticated users to like/unlike any post

    else
      # Abilities for guest users
      can :read, Post
      can :read, User # Allow reading user profiles
    end

    if user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:moderator)
      can :manage, [Post, Comment, Like]
      can :read, User
    end
  end
end

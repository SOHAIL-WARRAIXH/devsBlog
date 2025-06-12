# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create roles
admin_role = Role.create!(name: 'admin')
moderator_role = Role.create!(name: 'moderator')
user_role = Role.create!(name: 'user')

# Create admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  username: 'admin',
  name: 'Admin User'
)
admin.add_role :admin

# Create moderator user
moderator = User.create!(
  email: 'moderator@example.com',
  password: 'password',
  password_confirmation: 'password',
  username: 'moderator',
  name: 'Moderator User'
)
moderator.add_role :moderator

# Create regular user
user = User.create!(
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password',
  username: 'user',
  name: 'Regular User'
)
user.add_role :user

# Create sample posts
5.times do |i|
  post = Post.create!(
    title: "Sample Post #{i + 1}",
    content: "This is a sample post #{i + 1} with some content.",
    user: user
  )

  # Add some comments
  3.times do |j|
    Comment.create!(
      content: "This is comment #{j + 1} on post #{i + 1}",
      user: [admin, moderator, user].sample,
      post: post
    )
  end

  # Add some likes
  [admin, moderator, user].sample(2).each do |liker|
    Like.create!(
      user: liker,
      post: post
    )
  end
end

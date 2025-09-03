user = User.first

Entry.create!(
  user:,
  name: "Google",
  url: "https://google.com",
  username: "google_user@gmail.com",
  password: "google_password"
)

Entry.create!(
  user:,
  name: "Facebook",
  url: "https://facebook.com",
  username: "facebook_user",
  password: "facebook_password"
)

Entry.create!(
  user:,
  name: "Twitter",
  url: "https://twitter.com",
  username: "twitter_user",
  password: "twitter_password"
)

Entry.create!(
  user:,
  name: "Amazon",
  url: "https://amazon.com",
  username: "amazon_user",
  password: "amazon_password"
)

Entry.create!(
  user:,
  name: "Apple",
  url: "https://apple.com",
  username: "apple_user",
  password: "apple_password"
)

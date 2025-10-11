user = User.find_by(email: "test@test.com")
user = User.create!(email: "test@test.com", password: "asdasd", password_confirmation: "asdasd") if user.nil?

entries = [
  {
    name: "Google",
    url: "https://google.com",
    username: "google_user@gmail.com",
    password: "google_password"
  },
  {
    name: "Facebook",
    url: "https://facebook.com",
    username: "facebook_user",
    password: "facebook_password"
  },
  {
    name: "Twitter",
    url: "https://twitter.com",
    username: "twitter_user",
    password: "twitter_password"
  },
  {
    name: "Amazon",
    url: "https://amazon.com",
    username: "amazon_user",
    password: "amazon_password"
  },
  {
    name: "Apple",
    url: "https://apple.com",
    username: "apple_user",
    password: "apple_password"
  },

  {
    name: "Microsoft",
    url: "https://microsoft.com",
    username: "microsoft_user",
    password: "microsoft_password"
  },
  {
    name: "GitHub",
    url: "https://github.com",
    username: "github_user",
    password: "github_password"
  },
  {
    name: "LinkedIn",
    url: "https://linkedin.com",
    username: "linkedin_user",
    password: "linkedin_password"
  },
  {
    name: "Instagram",
    url: "https://instagram.com",
    username: "instagram_user",
    password: "instagram_password"
  },
  {
    name: "YouTube",
    url: "https://youtube.com",
    username: "youtube_user",
    password: "youtube_password"
  },
  {
    name: "Netflix",
    url: "https://netflix.com",
    username: "netflix_user",
    password: "netflix_password"
  },

  {
    name: "Spotify",
    url: "https://spotify.com",
    username: "spotify_user",
    password: "spotify_password"
  },
  {
    name: "TikTok",
    url: "https://tiktok.com",
    username: "tiktok_user",
    password: "tiktok_password"
  },
  {
    name: "Twitch",
    url: "https://twitch.com",
    username: "twitch_user",
    password: "twitch_password"
  },
  {
    name: "Reddit",
    url: "https://reddit.com",
    username: "reddit_user",
    password: "reddit_password"
  },
  {
    name: "Discord",
    url: "https://discord.com",
    username: "discord_user",
    password: "discord_password"
  },
  {
    name: "Steam",
    url: "https://steam.com",
    username: "steam_user",
    password: "steam_password"
  },
  {
    name: "Epic Games",
    url: "https://epicgames.com",
    username: "epic_games_user",
    password: "epic_games_password"
  }
]

puts "Creating entries..."
entries.each do |entry|
  Entry.create!(
    user:,
    **entry
  )
end
puts "Entries created successfully"

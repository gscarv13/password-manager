user = User.find_by(email: "test@test.com")
user = User.create!(email: "test@test.com", password: "asdasd", password_confirmation: "asdasd") if user.nil?

entries = [
  {
    name: "Google",
    url: "https://google.com",
    username: "sarah.chen.dev@gmail.com",
    password: "google_password"
  },
  {
    name: "Facebook",
    url: "https://facebook.com",
    username: "alex.rivera.92@gmail.com",
    password: "facebook_password"
  },
  {
    name: "Twitter",
    url: "https://twitter.com",
    username: "@coffee_and_code",
    password: "twitter_password"
  },
  {
    name: "Amazon",
    url: "https://amazon.com",
    username: "jamie.bookworm@yahoo.com",
    password: "amazon_password"
  },
  {
    name: "Apple",
    url: "https://apple.com",
    username: "m.thompson.design@icloud.com",
    password: "apple_password"
  },

  {
    name: "Microsoft",
    url: "https://microsoft.com",
    username: "david.kim.consultant@outlook.com",
    password: "microsoft_password"
  },
  {
    name: "GitHub",
    url: "https://github.com",
    username: "pixel_pusher_dev",
    password: "github_password"
  },
  {
    name: "LinkedIn",
    url: "https://linkedin.com",
    username: "elena.martinez.pm@gmail.com",
    password: "linkedin_password"
  },
  {
    name: "Instagram",
    url: "https://instagram.com",
    username: "wanderlust_maya",
    password: "instagram_password"
  },
  {
    name: "YouTube",
    url: "https://youtube.com",
    username: "ryan.techreviews@gmail.com",
    password: "youtube_password"
  },
  {
    name: "Netflix",
    url: "https://netflix.com",
    username: "movienight.crew@hotmail.com",
    password: "netflix_password"
  },

  {
    name: "Spotify",
    url: "https://spotify.com",
    username: "indie.vibes.music@gmail.com",
    password: "spotify_password"
  },
  {
    name: "TikTok",
    url: "https://tiktok.com",
    username: "creative_zoe_art",
    password: "tiktok_password"
  },
  {
    name: "Twitch",
    url: "https://twitch.com",
    username: "GamerGuru_Phoenix",
    password: "twitch_password"
  },
  {
    name: "Reddit",
    url: "https://reddit.com",
    username: "curious_mind_42",
    password: "reddit_password"
  },
  {
    name: "Discord",
    url: "https://discord.com",
    username: "NightOwl#7834",
    password: "discord_password"
  },
  {
    name: "Steam",
    url: "https://store.steampowered.com/",
    username: "retro_gamer_ace",
    password: "steam_password"
  },
  {
    name: "Epic Games",
    url: "https://epicgames.com",
    username: "storm_chaser_91",
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

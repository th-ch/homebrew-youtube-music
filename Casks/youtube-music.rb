require 'json'
require 'net/http'

cask "youtube-music" do
  desc "YouTube Music Desktop App"
  homepage "https://github.com/th-ch/youtube-music"

  # Fetch the latest release version from GitHub
  release_url = "https://github.com/th-ch/youtube-music/releases"
  latest_url = "#{release_url}/latest"
  response = Net::HTTP.get_response(URI.parse(latest_url))
  latest_url = response['location']
  odie "Cannot find the latest version" if (latest_url.nil?)
  latest_release = latest_url.delete_prefix("#{release_url}/tag/")

  version :latest

  base_url = "#{release_url}/download/#{latest_release}/YouTube-Music-#{latest_release.delete_prefix('v')}"
  file_extension = Hardware::CPU.arm? ? "-arm64.dmg" : ".dmg"

  url "#{base_url}#{file_extension}"

  # TODO checksum
  sha256 :no_check

  app "YouTube Music.app"

  postflight do
    print("Removing quarantine attribute from YouTube Music.app.\n")
    system "xattr -cr '/Applications/YouTube Music.app'"
  end

  auto_updates true
end

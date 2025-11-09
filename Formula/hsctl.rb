class Hsctl < Formula
  desc "A CLI tool for managing HubSpot contacts"
  homepage "https://github.com/obay/hsctl"
  url "https://github.com/obay/hsctl/archive/v0.1.0.tar.gz"
  sha256 ""
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_short_head} -X main.date=#{Time.now.utc.iso8601}", "-o", bin/"hsctl", "."
  end

  test do
    system "#{bin}/hsctl", "--version"
  end
end


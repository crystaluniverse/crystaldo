require "kemal"
require "json"
# require "./models/"
# require "./email"
# require "openssl"
# require "openssl/hmac"

# CURR_PATH = Dir.current + "/public/threefold/info"

# WEBSITES = Websites.new


post "/webhooks" do |env|

  body = env.params.json#.to_json
  pp body

  # signature = "sha1=" + OpenSSL::HMAC.hexdigest(:sha1, ENV["WEBHOOK_SECRET"], body)
  # githubsig= env.request.headers["X-Hub-Signature"]
  # if signature == githubsig
  #   command = "cd " + Dir.current + "/public/threefold" + "&& git pull"
  #   io = IO::Memory.new
  #   Process.run("sh", {"-c", command}, output: io)
  #   puts "Done updating content"
  #   puts io.to_s
  # end
end


Kemal.run do |config|
  server = config.server.not_nil!
  server.bind_tcp "0.0.0.0", 3002, reuse_port: true
end

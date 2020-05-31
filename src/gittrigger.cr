require "kemal"
require "json"

# CURR_PATH = Dir.current + "/public/threefold/info"

get "/" do
  "github trigger, nothing here to do!"
end

post "/github" do |env|
  body = env.params.json
  b = body["repository"].as(Hash)
  pp b["full_name"]

  "DONE"
end

Kemal.config.port = 3003
Kemal.run

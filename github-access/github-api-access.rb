require 'uri'
require 'json'
require 'net/http'

puts "Enter your GitHub username:"
user = gets
user.chomp!
github_api_uri = URI::HTTPS.build(host: "api.github.com", path: "/users/" + user)
json_result = Net::HTTP.get(github_api_uri)
result = JSON.parse(json_result)
if result.has_key?("message")
  puts result["message"]
else
  puts result["name"]
end

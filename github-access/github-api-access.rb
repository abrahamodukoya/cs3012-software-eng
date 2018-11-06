require 'uri'
require 'json'
require 'net/http'
require "io/console"

puts "Enter your GitHub username:"
user = gets
user.chomp!
puts "Enter your GitHub password:"
password = STDIN.noecho(&:gets).chomp
github_api_uri = URI.parse("https://api.github.com/user")
request = Net::HTTP::Get.new(github_api_uri)
request.basic_auth(user, password)
req_options = {
  use_ssl: github_api_uri.scheme == "https",
}
response = Net::HTTP.start(github_api_uri.hostname, github_api_uri.port, req_options) do |http|
  http.request(request)
end
json_result = response.body
result = JSON.parse(json_result)
puts json_result

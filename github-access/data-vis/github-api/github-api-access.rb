require 'uri'
require 'json'
require 'net/http'
require "io/console"

def send_request(user, password, uri)
  request = Net::HTTP::Get.new(uri)
  request.basic_auth(user, password)
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  return JSON.parse(response.body)
end

def user_has_repo?(user, password, repo)
  github_repo_uri = URI.parse("https://api.github.com/repos/" + user + "/" + repo)
  result = send_request user, password, github_repo_uri
  return result.has_key? "name"
end

def get_contributors(user, password, repo)
  uri = URI.parse("https://api.github.com/repos/" + user + "/" + repo + "/contributors")
  return send_request user, password, uri
end

#TODO: deal with bad credentials or the user entering a repo that they don't
#have access to
# puts "Enter your GitHub username:"
# user = gets
# user.chomp!
# puts "Enter your GitHub password:"
# password = STDIN.noecho(&:gets).chomp
# puts "Enter one of your repositories to view:"
# repo = gets.chomp!
# if user_has_repo? user, password, repo
#   puts ":)"
# else
#   puts ":("
# end

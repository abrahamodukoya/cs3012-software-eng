require 'uri'
require 'json'
require 'net/http'
require "io/console"



def user_has_repo?(user, password, repo)
  github_repo_uri = URI.parse("https://api.github.com/repos/" + user + "/" + repo)
  request = Net::HTTP::Get.new(github_repo_uri)
  request.basic_auth(user, password)
  req_options = {
    use_ssl: github_repo_uri.scheme == "https",
  }
  response = Net::HTTP.start(github_repo_uri.hostname, github_repo_uri.port, req_options) do |http|
    http.request(request)
  end
  json_result = response.body
  result = JSON.parse(json_result)
  return result.has_key? "name"
end

def get_contributors_and_commits(user, password, repo)

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

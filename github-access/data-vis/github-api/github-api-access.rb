require 'uri'
require 'json'
require 'net/http'
require 'io/console'

#removed authentication; don't need it for public repositories
def send_request(uri, params)
  request = Net::HTTP::Get.new(uri)
  #request.basic_auth(user, password)
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  params.each_pair do |key, val|
    request[key] = val
  end
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  return JSON.parse(response.body)
end

def user_has_repo?(owner, repo)
  github_repo_uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo)
  result = send_request github_repo_uri, {}
  return result.has_key? "name"
end

def get_contributors(owner, repo)
  uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo + "/contributors")
  return send_request owner, password, uri, {}
end

#FIXME: not every commit is returned for some reason
#try to figure out why
def get_commits(owner, contributor, repo)
  uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo + "/commits")
  params = {"author" => contributor}
  return send_request uri, params
end

def get_contributors_and_commit_num(owner, repo)
  uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo + "/stats/contributors")
  return send_request uri, {}
end

def get_closed_issues(owner, contributor, repo)
  uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo + "/issues")
  params = {"assignee" => contributor, "state" => "closed"}
  return send_request uri, params
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

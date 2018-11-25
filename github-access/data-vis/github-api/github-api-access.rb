require 'uri'
require 'json'
require 'net/http'
require 'io/console'

#removed authentication; don't need it for public repositories
def send_request(uri, params, user, password)
  request = Net::HTTP::Get.new(uri)
  request.basic_auth(user, password)
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

def user_has_repo?(owner, repo, user, password)
  github_repo_uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo)
  result = send_request github_repo_uri, {}, user, password
  return result.has_key? "name"
end

def get_contributors_and_commit_num(owner, repo, user, password)
  uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo + "/stats/contributors")
  return send_request uri, {}, user, password
end

def get_closed_issues(owner, repo, user, password)
  uri = URI.parse("https://api.github.com/repos/" + owner + "/" + repo + "/issues?state=closed")
  params = {}#{"state" => "closed"}
  return send_request uri, params, user, password
end

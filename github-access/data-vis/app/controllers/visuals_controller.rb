require './github-api/github-api-access'

class VisualsController < ApplicationController
def create
  #TODO: make a call to Github API here to see if the entered repo
  #exists; if it does save it, else display error
  username = params[:repo]["username"]
  password = params[:repo]["password"]
  repo = params[:repo]["name"]
  if user_has_repo? username, password, repo
    @repo = Repo.new(repos_params)
    @repo.save
    contributors = get_contributors username, password, repo
    puts contributors
     contributors.each do |user|
       @user = User.new
       @user.username = user["login"]
       @user.save
     end
    redirect_to action: "index"
  else
    render 'new'
  end
end

def index
  @repos = Repo.all
  @users = User.all
end

def show
end

def new
end

private
  def repos_params
    params.require(:repo).permit(:name)
  end

  private

end

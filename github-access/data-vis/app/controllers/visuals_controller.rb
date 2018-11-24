require './github-api/github-api-access'

class VisualsController < ApplicationController
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find(params[:id])
    @contributions = Contribution.where(repo_id: @repo.id)
    @user_vals = []
    #user_ids = []
    @contributions.to_ary.each do |contrib|
      #user_ids << contrib.user_id
      @user_vals << {username:User.find(contrib.user_id).username, commits:contrib.commits, issues:contrib.issues_closed}
    end
    #@users = User.find(user_ids)
  end

  def new
  end

  def edit
  end

  def create
    #TODO: make a call to Github API here to see if the entered repo
    #exists; if it does save it, else display error
    # username = params[:repo]["username"]
    # password = params[:repo]["password"]
    repo = params[:repo]["name"]
    owner = params[:repo]["owner"]
    if user_has_repo? owner, repo
      @repo = Repo.new(repos_params)
      @repo.save
      # contributors = get_contributors owner, password, repo
      #  contributors.each do |user|
      #    @user = User.new
      #    @user.username = user["login"]
      #    @user.save
      #    @contribution = Contribution.new
      #    @contribution.repo_id = @repo.id
      #    @contribution.user_id = @user.id
      #    @contribution.commits = get_commits(owner, password, @user.username, repo).length
      #    @contribution.issues_closed = get_closed_issues(owner, password, @user.username, repo).length
      #    @contribution.save
      #    puts "Commits: " + @contribution.commits.to_s
      #    puts "Issues: " + @contribution.issues_closed.to_s
      #  end
      contributors = {}
      until contributors != {}
        contributors = get_contributors_and_commit_num owner, repo
        #GitHub return HTTP 202 if it hasn't cached the stats results so we wait then try again
        sleep 0.1
      end


      contributors.each do |user|
        @user = User.new
        @user.username = user["author"]["login"]
        @user.save
        @contribution = Contribution.new
        @contribution.repo_id = @repo.id
        @contribution.user_id = @user.id
        @contribution.commits = user["total"].to_i
        #FIXME need some way of getting every issue, and not having the result be capped at 30
        @contribution.issues_closed = get_closed_issues(owner, @user.username, repo).length
        @contribution.save
      end
      redirect_to action: "index"
    else
      render 'new'
    end
  end

  def destroy
    @repo = Repo.find(params[:id])
    Contribution.where(repo_id: @repo.id).find_each do |contrib|
      User.find(contrib.user_id).destroy
      contrib.destroy
    end
    @repo.destroy
    redirect_to visuals_path
  end

  private
  def repos_params
    params.require(:repo).permit(:name)
  end

end

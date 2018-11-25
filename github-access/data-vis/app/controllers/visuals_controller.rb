require './github-api/github-api-access'

class VisualsController < ApplicationController
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find(params[:id])
    @contributions = Contribution.where(repo_id: @repo.id)
    @user_vals = []
    @contributions.to_ary.each do |contrib|
      @user_vals << {username:User.find(contrib.user_id).username, commits:contrib.commits, issues:contrib.issues_closed}
    end
  end

  def new
  end

  def edit
  end

  def create
    #make a call to Github API here to see if the entered repo
    #exists; if it does save it, else display error
    repo = params[:repo]["name"]
    owner = params[:repo]["owner"]
    curr_user = params[:repo]["curr_user"]
    password = params[:repo]["password"]
    if user_has_repo? owner, repo, curr_user, password
      @invalid_repo = false
      @repo = Repo.new(repos_params)
      @repo.save
      contributors = {}
      until contributors != {}
        contributors = get_contributors_and_commit_num owner, repo, curr_user, password
        #GitHub return HTTP 202 if it hasn't cached the stats results so we wait then try again
        sleep 0.1
      end

      issues = get_closed_issues(owner, repo, curr_user, password)
      contributors.each do |user|
        @user = User.new
        @user.username = user["author"]["login"]
        @user.save
        @contribution = Contribution.new
        @contribution.repo_id = @repo.id
        @contribution.user_id = @user.id
        @contribution.commits = user["total"].to_i
        num_issues = 0
        issues.each do |issue|
          if issue["assignee"] != nil && issue["assignee"]["login"] == @user.username
            num_issues = num_issues + 1
          else
            issue["assignees"].each do |assig|
              if assig["login"] == @user.username
                num_issues = num_issues + 1
              end
            end
          end
        end
        @contribution.issues_closed = num_issues
        @contribution.save
      end
      redirect_to action: "show", id: @repo.id
    else
      @invalid_repo = true
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

class TopicsController < ApplicationController
  before_action :get_project
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def new
    @topic = @project.topics.build
  end

  def index
    @topics = @project.topics
  end

  def show
  end

  def edit
    redirect_to @project unless @project.is_admin
  end

  def create
    @topic = @project.topics.build(topic_params)
    @topic.author = current_user.name
    respond_to do |format|
      if @topic.save
        format.html { redirect_to project_path(@project, :anchor =>"topics")}
      else
        format.html { redirect_to project_path(@project), alert: @topic.errors.full_messages[0]  }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to project_path(@project)}
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.json { head :no_content }
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def get_project
      @project = Project.find(params[:project_id])
      @project.is_admin = Project.get_role(current_user, @project)
    end

    def topic_params
      params.require(:topic).permit(:title)
    end
end

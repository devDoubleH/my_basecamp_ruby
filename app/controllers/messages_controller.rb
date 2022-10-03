class MessagesController < ApplicationController
  before_action :get_project
  before_action :get_topic
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def new
    @message = @topic.messages.build
  end

  def index
    @messages = Message.list(@topic, current_user.id)
  end

  def show
  end

  def edit
    redirect_to @project unless @project.is_admin || @message.editable
  end

  def create
    @message = @topic.messages.build(message_params)
    @message.author = current_user.name
    @message.user_id = current_user.id
    topic_id = "topic-" + @topic.id.to_s
    respond_to do |format|
      if @message.save
        format.html { redirect_to project_path(@project, :anchor => topic_id)}
      else
        format.html { redirect_to project_path(@project), alert: @message.errors.full_messages[0]  }
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to project_path(@project)}
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      if params[:path] == 'edit_message'
        format.html { redirect_to project_path(@project) }
      else
        format.html { redirect_to edit_project_topic_path(@project, @topic) }
      end
    end
  end

  private
    def set_message
      @message = Message.find(params[:id])
      @message.editable = (@message.user_id == current_user.id)
    end

    def get_project
      @project = Project.find(params[:project_id])
      @project.is_admin = Project.get_role(current_user, @project)
    end

    def get_topic
      @topic = Topic.find(params[:topic_id])
    end

    def message_params
      params.require(:message).permit(:text)
    end
end

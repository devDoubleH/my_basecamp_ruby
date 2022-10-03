class SubtasksController < ApplicationController
  before_action :get_project
  before_action :get_task
  before_action :set_subtask, only: [:edit, :update, :destroy]

  def new
    @subtask = @task.subtasks.build
  end

  def index
    @subtasks = @task.subtasks
  end

  def create
    @subtask = @task.subtasks.build(subtask_params)
    @subtask.completed = false
    respond_to do |format|
      if @subtask.save
        format.html { redirect_to project_path(@project, :anchor =>"tasks")}
      else
        format.html { redirect_to project_path(@project), alert: @subtask.errors.full_messages[0]  }
      end
    end
  end

  def edit
    redirect_to @project unless @project.permissions[:can_write] || @project.permissions[:can_update]
  end

  def update
    respond_to do |format|
      if params[:completed]
        if @subtask.update(:completed => !@subtask.completed)
          format.html { redirect_to project_path(@project, :anchor =>"tasks")}
          format.json { render :show, status: :ok, location: @subtask }
        else
          format.html { render :edit }
          format.json { render json: @subtask.errors, status: :unprocessable_entity }
        end
      else
        if @subtask.update(:title => params[:subtask][:title])
          format.html { redirect_to project_path(@project, :anchor =>"tasks")}
          format.json { render :show, status: :ok, location: @subtask }
        end
      end
    end
  end

  def destroy
    @subtask.destroy
    respond_to do |format|
        format.html { redirect_to project_path(@project, :anchor =>"tasks") }
    end
  end


  private

    def set_subtask
      @subtask = Subtask.find(params[:id])
    end

    def get_project
      @project = Project.find(params[:project_id])
      @project.permissions = Project.get_permissions(current_user, @project)
    end

    def get_task
      @task = Task.find(params[:task_id])
    end

    def subtask_params
      params.require(:subtask).permit(:title, :completed)
    end
end

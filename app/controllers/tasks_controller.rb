class TasksController < ApplicationController
  before_action :get_project
  before_action :set_task, only: [:edit, :update, :destroy]

  def new
    @task = @project.tasks.build
  end

  def index
    @tasks = @project.tasks
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.completed = false
    @task.last_edit = current_user.id
    respond_to do |format|
      if @task.save
        format.html { redirect_to project_path(@project, :anchor =>"tasks")}
      else
        format.html { redirect_to project_path(@project), alert: @task.errors.full_messages[0]  }
      end
    end
  end

  def edit
    redirect_to @project unless @project.permissions[:can_write] || @project.permissions[:can_update]
  end

  def update
    respond_to do |format|
      if params[:completed]
        if @task.update(:completed => !@task.completed)
          format.html { redirect_to project_path(@project, :anchor => "tasks")}
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { render :edit }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      else
        if @task.update(:title => params[:task][:title], :last_edit => current_user.id)
          format.html { redirect_to project_path(@project, :anchor => "tasks")}
          format.json { render :show, status: :ok, location: @task }
        end
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project, :anchor => "tasks") }
      format.json { head :no_content }
    end
  end

  private
    def get_project
      @project = Project.find(params[:project_id])
      @project.is_admin = Project.get_role(current_user, @project)
      @project.permissions = Project.get_permissions(current_user, @project)
    end

    def set_task
      @task = @project.tasks.find(params[:id])
      user = User.find(@task.last_edit)
      @task.last_edit_name = user.name
      @task.last_edit_email = user.email
    end

    def task_params
      params.require(:task).permit(:title, :completed)
    end
end

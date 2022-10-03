class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json

  def concatProjects(array1, array2)
    projectsAll = array1.concat(array2)
    return projectsAll
  end

  def index
    if user_signed_in?
      @projectsByOwner = Project.find_by_owner(current_user)
      @projectsByMember = Member.find_by_email(current_user)
      @projects = concatProjects(@projectsByOwner.to_a, @projectsByMember.to_a)
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project.member = Project.membership(current_user, @project)
    @project.is_owner = Project.owner(current_user, @project)
    p @project.tasks
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
  end

  # GET /projects/1/edit
  def edit
    redirect_to @project unless @project.is_admin
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.build(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to root_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_attachment
    @project_attachment = ActiveStorage::Attachment.find(params[:id])
    @project_attachment.purge_later
    # Q: how come @project = nil here ??
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
      @project.owner = @project.user.name
      @project.is_admin = Project.get_role(current_user, @project)
      @project.permissions = Project.get_permissions(current_user, @project)
    end

    # Only allow a list of trusted parameters through.
    def project_params
      # use fetch instead of require for empty attachment field
      params.fetch(:project, {}).permit(
        :name,
        :description,
        :member_id,
        attachments: [],
        attachments_attachment_attributes: [:id])
    end
end

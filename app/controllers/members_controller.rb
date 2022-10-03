class MembersController < ApplicationController
  before_action :get_project
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members  -> projects/members
  # GET /members.json
  def index
    @members = @project.members
  end

  # GET /members/1  -> projects/project_id/members/id
  # GET /members/1.json
  def show
  end

  # GET /members/new -> projects/members/new
  def new
    @member = @project.members.build
  end

  # GET /members/1/edit -> projects/project_id/members/1/edit
  def edit
  end

  # POST /members -> projects/members
  # POST /members.json
  def create
    @member = @project.members.build(member_params)
    respond_to do |format|
      if @member.email == current_user.email
        format.html { redirect_to edit_project_path(@project), alert: "You are already a member of this project"}
      elsif @member.save
        if @member.is_admin == true
          Member.change_permissions_to_true(@member.email)
        end
        format.html { redirect_to edit_project_path(@project)}
      else
        format.html { redirect_to edit_project_path(@project), alert: @member.errors.full_messages[0]  }
      end
    end
  end

  # PATCH/PUT /members/1  -> projects/project_id/members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if params[:is_admin]
        if @member.update(:is_admin => !@member.is_admin)
          if @member.is_admin == true
            Member.change_permissions_to_true(@member.email)
          else
            Member.change_permissions_to_false(@member.email)
          end
          format.html { redirect_to edit_project_path(@project)}
          format.json { render :show, status: :ok, location: @member }
        else
          format.html { render :edit }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      else
        if @member.update(member_params)
          format.html { redirect_to edit_project_path(@project)}
          format.json { render :show, status: :ok, location: @member }
        else
          format.html { render :edit }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def unsubscribe
    member = Member.find(params[:member_id])
    member.destroy
    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'You successfully unsubscribed from the project.' }
      format.json { head :no_content }
    end
  end


  # DELETE /members/1 -> projects/project_id/members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to edit_project_path(@project) }
      format.json { head :no_content }
    end
  end

  private
    def get_project
      @project = Project.find(params[:project_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = @project.members.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(
        :email,
        :is_admin,
        :can_read,
        :can_update,
        :can_write,
        :can_delete
      )
    end
end

class Account::WorkspacesController < Account::AccountController
  def index
    @workspaces = collection.order_desc
  end

  def show
    @workspace = resource
    @members = @workspace.members
  end

  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      redirect_to account_workspaces_path, notice: 'Workspace was created!'
    else
      render :new
    end
  end

  def edit
    @workspace = resource
  end

  def update
    @workspace = resource
    if @workspace.update(workspace_params)
      redirect_to account_workspace_path(@workspace), notice: 'Workspace was updated!'
    else
      render :edit
    end
  end

  def destroy
    resource.destroy
    redirect_to account_workspaces_path
  end

  def new_invitation
    @workspace = resource


    respond_to :js
  end

  def create_invitation
    ap invitation_params
    @workspace = resource
    @invitation = @workspace.shared_workspaces.build(user_id: invitation_params[:user])
    @invitation.save
    ap @invitation.errors.messages

    respond_to :js
  end

  def delete_invitation
    @workspace = resource
    @task = resource
    @result = @task.update(assignee_id: nil)

    respond_to :js
  end


  private

  def collection
    current_user.workspaces
  end

  def resource
    collection.find(params[:id])
  end

  def workspace_params
    params.require(:workspace).permit(:name).merge(user_id: current_user.id)
  end

  def invitation_params
    params.require(:workspace).permit(:user)
  end
end

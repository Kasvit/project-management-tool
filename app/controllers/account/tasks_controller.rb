class Account::TasksController < Account::AccountController
  def show
    @project = parent
    @task = @project.tasks.find(params[:id])
  end

  def new
    @project = parent
    @task = @project.tasks.build(section_params)
  end

  def create
    @task = parent.tasks.build(tasks_params)

    if @task.save
      redirect_to account_workspace_project_path(parent.workspace_id, parent)
    else
      render :new
    end
  end

  def edit
    @project = parent
    @task = @project.tasks.find(params[:id])
  end

  def update
    @task = resource

    if @task.update(tasks_params)
      redirect_to account_project_task_path(parent.id, @task)
    else
      render "edit"
    end
  end

  def destroy
    resource.destroy
    redirect_to account_workspace_project_path(parent.workspace_id, parent)
  end

  def move
    resource.update(task_movement_params)
    redirect_to account_workspace_project_path(parent.workspace_id, parent)
  end

  def watch
    @project = parent
    @task = parent.tasks.find(params[:id])

    if @task.users.include? current_user
      resource.watches.find_by(user_id: current_user).destroy
    else
      resource.update(users: [current_user])
    end

    respond_to(:js)
  end

  private

  def parent
    current_user.projects.find(params[:project_id])
  end

  def collection
    parent.tasks
  end

  def resource
    parent.tasks.find(params[:id])
  end

  def tasks_params
    params.require(:task).permit(:title, :description, :section)
  end

  def task_movement_params
    params.require(:task).permit(:row_order_position)
  end

  def section_params
    params.permit(:section)
  end
end

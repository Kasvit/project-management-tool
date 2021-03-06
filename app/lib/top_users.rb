class TopUsers

  def initialize(user, id = nil)
    @user = user
    @workspaces = @user.available_workspaces
    if id == nil
      if @workspaces.any?
        @collection = @workspaces.first.all_members
        @workspace = @workspaces.first
      end
    else
      @collection = @workspaces.find(id).all_members
      @workspace = @workspaces.find(id)
    end
  end

  def report
    top_users = []
    if @workspaces.any?
      @collection.each do |member|
        name = member.full_name
        completed = @workspace.tasks.complete_by(member).count
        top_users.push( name: name, completed: completed)
      end
      top_users = top_users.sort_by{ |k| -k[:completed]}
      top_five_users = top_users.first(5)
    end  
  end
end

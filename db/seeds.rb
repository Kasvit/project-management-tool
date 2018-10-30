FactoryBot.create_list(:user, 3)

User.all.each do |user|
  FactoryBot.create_list(:workspace, 3, user: user)
end

Workspace.all.each do |workspace|
  FactoryBot.create_list(:project, 2, workspace: workspace)
end

Project.all.each do |project|
  FactoryBot.create_list(:task, 3, project: project)
end

User.all.each do |user|
  user.workspaces.each do |workspace|
    workspace.projects.each do |project|
      project.update(users: [user])
    end
  end

  user.projects.each do |project|
    project.tasks.each do |task|
      task.update(users: [user]) if Faker::Boolean.boolean(rand(0.0..1.0))
    end
  end
end

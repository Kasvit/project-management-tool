require 'rails_helper'

RSpec.describe Api::DashboardController, type: :controller do
  render_views

  let!(:user) { create(:user) }
  let!(:workspace) { create(:workspace, user: user) }
  let!(:project) { create(:project, workspace: workspace) }
  let!(:task1) { create(:task, project: project, assignee_id: user.id) }

  before do
    sign_in user
  end

  describe 'GET /api/my-tasks' do
    it "should show user's tasks page" do
      get :my_tasks, as: :json, params: { project_id: project.id, id: task1.id }
      expect(response.body).to include(task1.description)
      expect(response).to have_http_status(200)
    end
  end
end

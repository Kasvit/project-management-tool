# == Schema Information
#
# Table name: projects
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  workspace_id :bigint(8)
#
# Indexes
#
#  index_projects_on_workspace_id  (workspace_id)
#
# Foreign Keys
#
#  fk_rails_...  (workspace_id => workspaces.id)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'scope testing' do
    let!(:user) { create(:user) }
    let!(:workspace) { create(:workspace, user_id: user.id) }
    let!(:project1) { create(:project, workspace_id: workspace.id) }
    let!(:project2) { create(:project, workspace_id: workspace.id) }
    let!(:project3) { create(:project, workspace_id: workspace.id) }

    it 'should sort data by desc' do
      expect(workspace.projects.order_desc).to eq [project3, project2, project1]
    end
  end
end
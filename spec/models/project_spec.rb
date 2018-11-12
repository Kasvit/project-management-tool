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
  context 'factory tests' do
    subject { build(:project) }
    it { is_expected.to be_valid }
  end

  context 'validation tests' do
    it { should validate_presence_of(:name) }
    it { should belong_to(:workspace) }
    it { should have_many(:tasks) }
    it { should validate_length_of(:name).is_at_most(250) }
  end

  context 'scope testing' do
    let!(:user) { create(:user) }
    let!(:workspace) { create(:workspace, user_id: user.id) }
    let!(:project1) { create(:project, name: 'Test 1', workspace_id: workspace.id) }
    let!(:project2) { create(:project, name: 'Test 2', workspace_id: workspace.id) }
    let!(:project3) { create(:project, name: 'Text', workspace_id: workspace.id) }

    it 'should sort data by desc' do
      expect(workspace.projects.order_desc).to eq [project3, project2, project1]
    end

    it 'should find all projects with entered text' do
      expect(workspace.projects.search_projects('Test').count).to eq 2
      expect(workspace.projects.search_projects('text').count).to eq 1
      expect(workspace.projects.search_projects('hhfj').count).to eq 0
    end
  end
end

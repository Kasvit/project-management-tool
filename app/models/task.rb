# == Schema Information
#
# Table name: tasks
#
#  id           :bigint(8)        not null, primary key
#  completed_at :datetime
#  deleted_at   :datetime
#  description  :text
#  due_date     :datetime
#  row_order    :integer
#  section      :boolean          default(FALSE)
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  assignee_id  :bigint(8)
#  project_id   :bigint(8)
#
# Indexes
#
#  index_tasks_on_assignee_id  (assignee_id)
#  index_tasks_on_deleted_at   (deleted_at)
#  index_tasks_on_project_id   (project_id)
#  index_tasks_on_row_order    (row_order)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => users.id)
#  fk_rails_...  (project_id => projects.id)
#

class Task < ApplicationRecord
  include RankedModel
  include Commentable

  acts_as_paranoid

  ranks :row_order, with_same: :project_id

  has_many_attached :files, dependent: :destroy
  belongs_to :project, required: true
  has_many :task_watches, dependent: :destroy
  has_many :watchers, through: :task_watches, source: :user
  belongs_to :assignee, class_name: "User", required: false

  scope :incomplete, -> { where(completed_at: nil) }
  scope :complete, -> { where.not(completed_at: nil) }
  scope :row_order_asc, -> { order(row_order: :asc) }
  scope :search_tasks, -> (user_id, search) { select('tasks.id, tasks.title, tasks.project_id').joins('
                                 INNER JOIN projects ON projects.id = tasks.project_id
                                 INNER JOIN user_projects as up ON projects.id = up.project_id
                                 INNER JOIN users ON users.id = up.user_id')
                                   .where('users.id = ? AND tasks.title ~* ?', user_id, "\\m#{search}")
                                   .limit(10) }
  scope :this_week, -> { where('created_at > ?', Date.today.beginning_of_week) }
  scope :current_workspace, -> (workspace) { where(project_id: workspace.projects.ids)}

  validates :title, length: { maximum: 250 }, presence: true
  validates :description, length: { maximum: 250 }

  alias_attribute :start_time, :due_date

  def pending?
    !completed_at?
  end

  def expired?
    self.due_date && self.due_date < Time.now && pending?
  end

  def add_watcher(user)
    self.task_watches.find_or_create_by(user_id: user.id)
  end

  def remove_watcher(user)
    self.task_watches.where(user_id: user.id).delete_all
  end

  def assignee?(user)
    self.assignee == user
  end

end

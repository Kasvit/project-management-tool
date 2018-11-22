class Account::DashboardController < Account::AccountController
  after_action :change_messages_read, only: :inbox

  def index
  end

  def calendar
    @user_tasks = current_user.followed_tasks
  end

  def inbox
    @new_messages = current_user.messages.not_readed.newest
    @old_messages = current_user.messages.readed.newest
  end

  def change_messages_read
    current_user.messages.not_readed.update_all(is_read: true)
  end
end

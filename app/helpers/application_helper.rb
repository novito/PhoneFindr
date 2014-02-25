module ApplicationHelper
  def is_signed_admin?
    current_user && current_user.admin?
  end
end

module DeviseHelper
  def is_admins?
    current_user.role == "admin" || current_user.role == "super_admin"
  end
end

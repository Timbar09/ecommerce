module DeviseHelper
  def is_admins?
    current_user.role == "admin" || current_user.role == "super_admin"
  end

  def is_super_admin?
    current_user.role == "super_admin"
  end
end

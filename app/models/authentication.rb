class Authentication < ActiveRecord::Base
  belongs_to :user
  before_destroy :stop_destroy_if_last_oauth_and_password_nil
  
  private
  
    def stop_destroy_if_last_oauth_and_password_nil
      user = User.find(self.user_id)
      if user.crypted_password.nil? && user.authentications.count == 1
        return false
      end
    end
end

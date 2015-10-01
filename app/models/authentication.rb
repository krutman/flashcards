class Authentication < ActiveRecord::Base
  belongs_to :user
  before_destroy :stop_if_last_oauth_and_password_nil
  
  private
  
    def stop_if_last_oauth_and_password_nil
      return !(user.crypted_password.nil? && user.authentications.count == 1)
    end
end

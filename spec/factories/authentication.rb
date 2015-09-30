FactoryGirl.define do
  
  factory :authentication do
    provider "facebook"
    uid "1234567"
    user
  end
end

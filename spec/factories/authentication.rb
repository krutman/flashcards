FactoryGirl.define do
  
  factory :authentication do
    provider "facebook"
    uid "123456"
    user
  end
end

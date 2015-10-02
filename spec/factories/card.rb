FactoryGirl.define do
  
  factory :card do
    cover { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test.jpg'), 'image/jpg') }
    original_text "кот"
    translated_text "cat"
    review_date Date.today + 3.days
    user
  end
end

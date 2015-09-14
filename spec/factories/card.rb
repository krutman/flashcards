FactoryGirl.define do
  
  factory :card do
    original_text "кот"
    translated_text "cat"
    review_date Date.today + 3.days
  end
end

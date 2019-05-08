FactoryBot.define do
  factory :task do
    transient do
      tags_count { 3 }
    end

    sequence :title do |n|
      "Name #{n}"
    end

    trait :with_tags do
      tags { |evaluator| create_list(:tag, evaluator.tags_count) }
    end
  end
end

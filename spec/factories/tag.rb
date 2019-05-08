FactoryBot.define do
  factory :tag do
    sequence :title do |n|
      "Name #{n}"
    end
  end
end

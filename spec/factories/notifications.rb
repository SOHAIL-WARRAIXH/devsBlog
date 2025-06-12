FactoryBot.define do
  factory :notification do
    recipient { nil }
    actor { nil }
    notifiable { nil }
    action { "MyString" }
    read_at { "2025-06-10 19:45:19" }
  end
end

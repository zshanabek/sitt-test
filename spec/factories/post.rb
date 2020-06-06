FactoryBot.define do
    factory :post do
        title { Faker::Lorem.word }
        content { Faker::Lorem.paragraph(sentence_count: 2) }
    end
end
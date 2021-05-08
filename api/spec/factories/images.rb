FactoryBot.define do
  factory :image do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    price { 1 }
    state { "private" }
    canvas_string { "tbd" }
    attached_image { Rack::Test::UploadedFile.new("assets/1.png", "1.png") }
  end
end

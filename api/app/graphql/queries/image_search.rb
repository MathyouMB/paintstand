module Queries
  # A Query that returns the information of a given image based on the given id
  class ImageSearch < Queries::BaseQuery
    description "Text based image search query."
    argument :search_input, String, required: true
    argument :page, Integer, required: true
    argument :limit, Integer, required: true
    type Types::ImageType.collection_type, null: false

    def resolve(search_input: nil, page: nil, limit: nil)
      images = ::Image.listed_images.order(id: :desc)
      results = []
      upper_bound = (page * limit + limit > images.length ? images.length : (page * limit + limit)) - 1

      ((page * limit)..upper_bound).each do |i|
        results << images[i] if images[i].search_string.downcase.include?(search_input.downcase)
      end

      results
    end
  end
end

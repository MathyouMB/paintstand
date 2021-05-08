module Queries
  # A Query that returns the information of a given image based on the given id
  class ImagesListed < Queries::BaseQuery
    description "Get Images available for sale"
    argument :page, Integer, required: true
    argument :limit, Integer, required: true
    type Types::ImageType.collection_type, null: false

    def resolve(page: nil, limit: nil)
      ::Image.where(state: "listed").order(id: :desc).page(page).per(limit)
    end
  end
end

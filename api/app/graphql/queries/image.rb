module Queries
  # A Query that returns the information of a given image based on the given id
  class Image < Queries::BaseQuery
    description "Get Image by id"
    argument :id, ID, required: true
    type Types::ImageType, null: false

    def resolve(id:)
      image = ::Image.fetch(id)
      return GraphQL::ExecutionError.new("ERROR: Image of given ID is nil") if image.nil? || image.state == "private"

      image
    rescue ActiveRecord::RecordNotFound
      GraphQL::ExecutionError.new("ERROR: Image of given ID is nil")
    end
  end
end

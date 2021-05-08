module Queries
  # A Query that returns the information of a given user based on the given id
  class User < Queries::BaseQuery
    description "Get User by id"
    argument :id, ID, required: true
    type Types::UserType, null: false

    def resolve(id:)
      ::User.fetch(id)
    rescue ActiveRecord::RecordNotFound
      GraphQL::ExecutionError.new("ERROR: User of given ID is nil")
    end
  end
end

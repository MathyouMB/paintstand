module Queries
  # A Query that returns the information of the currently logged in User
  class Profile < Queries::BaseQuery
    description "Get the info of the currently logged in User"
    type Types::UserType, null: false

    def resolve
      user = context[:current_user]
      return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

      user
    end
  end
end

module Queries
  # A Query that returns all users
  class Users < Queries::BaseQuery
    description "Get Users"
    type [Types::UserType], null: false

    def resolve
      ::User.all
    end
  end
end

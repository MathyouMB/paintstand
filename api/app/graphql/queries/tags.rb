module Queries
  # A Query that returns all Tags
  class Tags < Queries::BaseQuery
    description "Get Tags"
    type [Types::TagType], null: false

    def resolve
      ::Tag.all
    end
  end
end

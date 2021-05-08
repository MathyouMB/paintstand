
module Queries
  # A Query that returns the information of a given Purchase based on the given id
  class Purchase < Queries::BaseQuery
    description "Get Purchase by id"
    argument :id, ID, required: true
    type Types::PurchaseType, null: false

    def resolve(id:)
      user = context[:current_user]
      return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

      purchase = ::Purchase.fetch(id)
      return GraphQL::ExecutionError.new("ERROR: Purchase of given ID is nil") if purchase.merchant != user || purchase.customer != user

      purchase
    rescue ActiveRecord::RecordNotFound
      GraphQL::ExecutionError.new("ERROR: Purchase of given ID is nil")
    end
  end
end

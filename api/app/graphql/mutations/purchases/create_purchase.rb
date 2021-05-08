module Mutations
  module Purchases
    # Mutation that creates an Purchase entity with the provided Image
    class CreatePurchase < BaseMutation
      argument :image_id, ID, required: true

      type String

      def resolve(image_id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        image = Image.find(image_id)
        return GraphQL::ExecutionError.new("ERROR: Requested Image does not exist") if image.nil? || image.state == "private"
        return GraphQL::ExecutionError.new("ERROR: User cannot purchase their own Image") if user == image.owner
        return GraphQL::ExecutionError.new("ERROR: User cannot afford this purchase") if user.balance < image.price

        ActiveRecord::Base.transaction do
          ::Purchase.create!(
            cost: image.price,
            customer_id: user.id,
            merchant_id: image.owner.id,
            image_id: image.id
          )

          user.update!(balance: user.balance - image.price)
          image.owner.update!(balance: image.owner.balance + image.price)
          image.update!(owner_id: user.id)
        end

        "Succesfully purchased image."

      rescue ActiveRecord::RecordInvalid
        GraphQL::ExecutionError.new("ERROR: Invalid operation. Transaction was not successfully completed")
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Image of given ID is nil")
      end
    end
  end
end

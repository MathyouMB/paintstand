module Mutations
  module Images
    # Mutation deletes the image of the provided id
    class DeleteImage < BaseMutation
      argument :id, Int, required: true

      type Types::ImageType

      def resolve(id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        image = ::Image.find(id)

        if image.owner == user
          image.destroy!
          raise GraphQL::ExecutionError, image.errors.full_messages.join(", ") unless image.errors.empty?

          image
        else
          raise GraphQL::ExecutionError, "ERROR: Current User is not the owner of this Image"
        end

      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Image of given ID is nil")
      end
    end
  end
end

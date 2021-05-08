module Mutations
  module Images
    # Mutation updates the image of the provided id
    class UpdateImage < BaseMutation
      argument :id, Int, required: true
      argument :title, String, required: false
      argument :description, String, required: false
      argument :state, String, required: false
      argument :image, Types::File, required: false

      type Types::ImageType

      def resolve(id:, title: nil, description: nil, state: nil, image: nil)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        image_search = ::Image.find(id)

        if image_search.owner_id == user.id

          image_search.title = title if title.present?
          image_search.description = description if description.present?
          image_search.state = state if state.present?
          image_search.attached_image = image if image.present?
          image_search.save!

          raise GraphQL::ExecutionError, image_search.errors.full_messages.join(", ") unless image_search.errors.empty?

          image_search
        else
          raise GraphQL::ExecutionError, "ERROR: Current User is not the owner of this Image"
        end

      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Image of given ID is nil")
      end
    end
  end
end

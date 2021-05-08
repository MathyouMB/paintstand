module Mutations
  module Images
    # Mutation adds a tag to a given Image
    class AddImageTag < BaseMutation
      argument :image_id, Int, required: true
      argument :tag, String, required: true

      type String

      def resolve(image_id: nil, tag: nil)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?
        return GraphQL::ExecutionError.new("ERROR: User is not owner of this Image") unless ::Image.find(image_id).owner_id == user.id

        tag_search = Tag.find_by(name: tag)

        if tag_search.nil?
          tag_search = Tag.create(
            name: tag
          )
        end

        image_tag_search = ImageTag.find_by(image_id: image_id, tag_id: tag_search.id)

        if image_tag_search.nil?
          ImageTag.create(
            image_id: image_id,
            tag_id: tag_search.id
          )
        else
          return GraphQL::ExecutionError.new("ERROR: Image already has this tag")
        end

        "Succesfully added tag to image."
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Image of given ID is nil")
      end
    end
  end
end

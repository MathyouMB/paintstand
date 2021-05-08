module Mutations
  module Images
    # Mutation that creates an Image entity with the provided information
    class UploadCanvas < BaseMutation
      argument :title, String, required: true
      argument :description, String, required: true
      argument :price, Integer, required: true
      argument :data_uri, String, required: true

      type Types::ImageType

      def resolve(title:, description:, price:, data_uri:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        image = ::Image.create!(
          title: title,
          description: description,
          price: price,
          state: "listed",
          creator_id: user.id,
          owner_id: user.id,
        )

        png = Base64.decode64(data_uri["data:image/png;base64,".length..-1])
        File.open("assets/#{image.id}.png", "wb") { |f| f.write(png) }

        image.attached_image.attach(io: File.open("assets/#{image.id}.png"), filename: "#{image.id}.png")

        image
      end
    end
  end
end

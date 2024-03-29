
module Types
  # MutationType is generated by GraphQL-Ruby
  class MutationType < Types::BaseObject
    # User
    field :login, mutation: Mutations::Users::Login, description: "Logs in a User and returns a JWT Token"
    field :sign_up, mutation: Mutations::Users::SignUp, description: "Creates a new User using the provided info"
    field :update_user, mutation: Mutations::Users::UpdateUser, description: "Updates the current user using the provided info"

    # Image
    field :create_image, mutation: Mutations::Images::CreateImage, description: "Creates an Image Entity using the provided information"
    field :upload_canvas, mutation: Mutations::Images::UploadCanvas, description: "Creates an Image Entity using the provided canvas information"
    field :update_image, mutation: Mutations::Images::UpdateImage, description: "Updates the Image of the provided id"
    field :delete_image, mutation: Mutations::Images::DeleteImage, description: "Deletes the Image of the provided id"
    field :add_image_tag, mutation: Mutations::Images::AddImageTag, description: "Adds a Tag to a given Image using the provided tag name"

    # Purchases
    field :create_purchase, mutation: Mutations::Purchases::CreatePurchase, description: "Creates a Purchase for the current user of the provided Image"
  end
end

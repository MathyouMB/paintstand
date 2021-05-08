# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Delete Image") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Images::DeleteImage do
    it "if conditions are valid, image is succesfully deleted" do
      prepare_context({
        current_user: @user,
      })

      image = create(:image, state: "private", creator_id: @user.id, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation deleteImage($id: Int!) {
          deleteImage(id: $id){
              id
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: image.id
      )

      result = graphql!

      expect(result["data"]["deleteImage"]["id"].to_i).to(eq(image.id))
      expect(Image.all.size).to(eq(0))
    end

    it "if image id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation deleteImage($id: Int!) {
          deleteImage(id: $id){
              id
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: 100
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Image of given ID is nil"))
    end

    it "if image id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      user2 = create(:user, email: "user2@email.com", username: "something2", password: "1234")
      image = create(:image, state: "private", creator_id: user2.id, owner_id: user2.id)

      query = <<~GRAPHQL
        mutation deleteImage($id: Int!) {
          deleteImage(id: $id){
              id
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: image.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Current User is not the owner of this Image"))
    end

    it "if not logged in, error is returned" do
      image = create(:image, state: "private", creator_id: @user.id, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation deleteImage($id: Int!) {
          deleteImage(id: $id){
              id
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: image.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

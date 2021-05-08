# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Add Image Tag") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Images::AddImageTag do
    it "if conditions are valid, tag is succesfully added" do
      prepare_context({
        current_user: @user,
      })

      image = create(:image, state: "private", creator_id: @user.id, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation addImageTag($imageId: Int!, $tag: String!) {
          addImageTag(imageId: $imageId, tag: $tag)
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image.id,
        tag: "test"
      )

      result = graphql!

      expect(result["data"]["addImageTag"]).to(eq("Succesfully added tag to image."))
      expect(Image.first.tags.length).to(eq(1))
      expect(Image.first.tags.first.name).to(eq("test"))
    end

    it "if image already has the desired tag, return an error" do
      prepare_context({
        current_user: @user,
      })

      image = create(:image, state: "private", creator_id: @user.id, owner_id: @user.id)
      tag = create(:tag, name: "test")
      image.tags << tag

      query = <<~GRAPHQL
        mutation addImageTag($imageId: Int!, $tag: String!) {
          addImageTag(imageId: $imageId, tag: $tag)
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image.id,
        tag: "test"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Image already has this tag"))
    end

    it "if user is not logged in, return an error" do
      image = create(:image, state: "private", creator_id: @user.id, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation addImageTag($imageId: Int!, $tag: String!) {
          addImageTag(imageId: $imageId, tag: $tag)
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image.id,
        tag: "test"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end

    it "if image id is not valid, return an error" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation addImageTag($imageId: Int!, $tag: String!) {
          addImageTag(imageId: $imageId, tag: $tag)
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: 100,
        tag: "test"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Image of given ID is nil"))
    end
  end
end

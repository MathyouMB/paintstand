# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Create Purchase") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    @user2 = create(:user, email: "user2@email.com", username: "something2", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Purchases::CreatePurchase do
    it "if using valid records, purchase is succesful" do
      prepare_context({
        current_user: @user,
      })

      image_test = create(:image, title: "test", state: "listed", creator_id: @user2.id, owner_id: @user2.id)

      query = <<~GRAPHQL
        mutation createPurchase($imageId: ID!) {
            createPurchase(imageId: $imageId)
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image_test.id,
      )

      result = graphql!
      expect(result["data"]["createPurchase"]).to(eq("Succesfully purchased image."))
    end

    it "if image id is invalid, return error" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createPurchase($imageId: ID!) {
            createPurchase(imageId: $imageId)
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: 100,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Image of given ID is nil"))
    end

    it "if not logged in, return error" do
      image_test = create(:image, title: "test", state: "listed", creator_id: @user2.id, owner_id: @user2.id)

      query = <<~GRAPHQL
        mutation createPurchase($imageId: ID!) {
            createPurchase(imageId: $imageId)
        }
            GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end

    it "if not logged in, return error" do
      image_test = create(:image, title: "test", state: "listed", creator_id: @user2.id, owner_id: @user2.id, price: 10000)

      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createPurchase($imageId: ID!) {
            createPurchase(imageId: $imageId)
        }
            GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: User cannot afford this purchase"))
    end

    it "if user purchases an image they own, return error" do
      image_test = create(:image, title: "test", state: "listed", creator_id: @user.id, owner_id: @user.id)

      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createPurchase($imageId: ID!) {
            createPurchase(imageId: $imageId)
        }
            GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        imageId: image_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: User cannot purchase their own Image"))
    end
  end
end

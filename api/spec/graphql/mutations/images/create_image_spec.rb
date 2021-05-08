# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Create Image") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Images::CreateImage do
    it "if conditions are valid, image is succesfully created" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createImage($title: String!, $description: String!, $price: Int!, $image: File!) {
          createImage(title: $title, description: $description, price: $price, image: $image){
              id
          }
        }
        GRAPHQL

      prepare_query(query)

      file = Tempfile.open("#{Rails.root}/assets/1.png")
      upload = ActionDispatch::Http::UploadedFile.new(
        filename: "1.png",
        type: "image/png",
        tempfile: file
      )

      prepare_query_variables(
        title: "Test Image",
        description: "...",
        price: 100,
        image: upload
      )
      result = graphql!
      expect(result["data"]["createImage"]["id"].to_i).to(eq(Image.last.id))
    end

    it "if not logged in, return error" do
      query = <<~GRAPHQL
        mutation createImage($title: String!, $description: String!, $price: Int!, $image: File!) {
          createImage(title: $title, description: $description, price: $price, image: $image){
              id
          }
        }
        GRAPHQL

      prepare_query(query)

      file = Tempfile.open("#{Rails.root}/assets/1.png")
      upload = ActionDispatch::Http::UploadedFile.new(
        filename: "1.png",
        type: "image/png",
        tempfile: file
      )

      prepare_query_variables(
        title: "Test Image",
        description: "...",
        price: 100,
        image: upload
      )
      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

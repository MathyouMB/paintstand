require "rails_helper"

RSpec.describe("Image Queries") do
  before do
    prepare_query_variables({})
    prepare_context({})

    3.times do
      u = create(:user)
      create(:image, title: "test", state: "listed", creator_id: u.id, owner_id: u.id)
    end

    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    create(:image, title: "somethingelse", state: "private", creator_id: @user.id, owner_id: @user.id)
  end

  describe Queries::Image do
    context "when passed the id of the first image" do
      it "returns a image with the id of the first image" do
        first_image_id = Image.first.id

        prepare_query('query image($id: ID!){
                      image(id: $id) {
                          id
                          attachedImageUrl
                          tags{
                            id
                          }
                          creator{
                            id
                          }
                          owner{
                            id
                          }
                      }
                      }')

        prepare_query_variables(
          id: first_image_id
        )

        image_id = graphql!["data"]["image"]["id"].to_i
        expect(image_id).to(eq(first_image_id))
      end
    end
  end

  describe Queries::Image do
    context "when passed the id of a private image" do
      it "does not allow user to view the image" do
        last_image_id = Image.last.id

        prepare_query('query image($id: ID!){
                      image(id: $id) {
                          id
                      }
                      }')

        prepare_query_variables(
          id: last_image_id
        )

        response = graphql!["errors"][0]["message"]
        expect(response).to(eq("ERROR: Image of given ID is nil"))
      end
    end

    context "when passed invalid image id" do
      it "returns error" do
        prepare_query('query image($id: ID!){
                      image(id: $id) {
                          id
                      }
                      }')

        prepare_query_variables(
          id: 100
        )

        response = graphql!["errors"][0]["message"]
        expect(response).to(eq("ERROR: Image of given ID is nil"))
      end
    end
  end

  describe Queries::ImageSearch do
    context "when there are 4 images in the database with same name, but one is private" do
      it "returns a search result with a length of 3 because one is private" do
        prepare_query('query{
                      imageSearch(searchInput: "test", page:0, limit:24){
                        collection{
                          id
                        }
                      }
                    }')

        images = graphql!["data"]["imageSearch"]["collection"]
        expect(images.length).to(eq(3))
      end
    end
  end

  describe Queries::ImagesListed do
    context "when there are 4 images in the database with same name, but one is private" do
      it "returns a search result with a length of 3 because one is private" do
        prepare_query('query{
                    imageListed(page:1, limit:24){
                        collection{
                          id
                        }
                      }
                    }')

        images = graphql!["data"]["imageListed"]["collection"]
        expect(images.length).to(eq(3))
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Login") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Users::Login do
    it "if using valid credentials, login is succesful" do
      prepare_context({})

      query = <<~GRAPHQL
        mutation login($email: String!, $password: String!) {
          login(email: $email, password: $password){
              user{
                id
                ownedImages{
                    id
                }
                createdImages{
                    id
                }
                purchases{
                    id
                }
                sales{
                    id
                }
              }
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        email: @user.email,
        password: "1234"
      )

      result = graphql!
      expect(result["data"]["login"]["user"]["id"].to_i).to(eq(@user.id))
    end

    it "if using invalid password, login is not succesful" do
      prepare_context({})

      query = <<~GRAPHQL
        mutation login($email: String!, $password: String!) {
          login(email: $email, password: $password){
              user{
                id
              }
          }
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        email: @user.email,
        password: "123"
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Incorrect Password"))
    end

    it "if using invalid email, login is not succesful" do
      prepare_context({})

      query = <<~GRAPHQL
        mutation login($email: String!, $password: String!) {
          login(email: $email, password: $password){
              user{
                id
              }
          }
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        email: "ok",
        password: "1234"
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: no user with that email"))
    end
  end
end

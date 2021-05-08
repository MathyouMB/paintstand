# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Update User") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Users::UpdateUser do
    it "if conditions are valid, user is succesfully updates" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation updateUser($username: String!) {
          updateUser(username: $username){
              id
              username
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        username: "test2"
      )

      result = graphql!

      expect(result["data"]["updateUser"]["id"].to_i).to(eq(@user.id))
      expect(result["data"]["updateUser"]["username"]).to(eq(User.last.username))
    end

    it "if username is taken, error is returned" do
      prepare_context({
        current_user: @user,
      })

      create(:user, email: "user2@email.com", username: "something2", password: "1234")

      query = <<~GRAPHQL
        mutation updateUser($username: String!) {
          updateUser(username: $username){
              id
              username
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        username: "something2"
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Username or email is taken"))
    end

    it "if not logged in, error is returned" do
      query = <<~GRAPHQL
        mutation updateUser($username: String!) {
          updateUser(username: $username){
              id
              username
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        username: "test2"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

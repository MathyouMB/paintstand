# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Sign up") do
  before do
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Users::SignUp do
    it "if using valid information, signup is succesful" do
      prepare_context({})

      query = <<~GRAPHQL
        mutation signUp($email: String!, $password: String!, $passwordConfirmation: String!, $username: String!) {
            signUp(email: $email, password: $password, passwordConfirmation: $passwordConfirmation, username: $username){
            id
          }
        }
        GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        email: "test@email.com",
        password: "1234",
        passwordConfirmation: "1234",
        username: "username"
      )

      result = graphql!
      expect(result["data"]["signUp"]["id"].to_i).to(eq(User.last.id))
    end

    it "if using existing email, signup is not succesful" do
      prepare_context({})

      @user = create(:user, email: "test@email.com", username: "something", password: "1234")

      query = <<~GRAPHQL
        mutation signUp($email: String!, $password: String!, $passwordConfirmation: String!, $username: String!) {
            signUp(email: $email, password: $password, passwordConfirmation: $passwordConfirmation, username: $username){
            id
          }
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        email: "test@email.com",
        password: "1234",
        passwordConfirmation: "1234",
        username: "username"
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: email already used by other user"))
    end

    it "if using existing username, signup is not succesful" do
      prepare_context({})

      @user = create(:user, email: "test2@email.com", username: "username", password: "1234")

      query = <<~GRAPHQL
        mutation signUp($email: String!, $password: String!, $passwordConfirmation: String!, $username: String!) {
            signUp(email: $email, password: $password, passwordConfirmation: $passwordConfirmation, username: $username){
            id
          }
        }
          GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        email: "test@email.com",
        password: "1234",
        passwordConfirmation: "1234",
        username: "username"
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: username already used by other user"))
    end
  end
end

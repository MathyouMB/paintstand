require "rails_helper"

RSpec.describe("User Queries") do
  before do
    prepare_query_variables({})
    prepare_context({})

    create_list(:user, 2)

    @user = create(:user, email: "user@email.com", password: "1234")
  end

  describe Queries::Users do
    context "when there are 3 users in the database" do
      it "returns a result with a length of 3" do
        prepare_query('{
                users{
                    id
                }
            }')

        users = graphql!["data"]["users"]
        expect(users.length).to(eq(3))
      end
    end
  end

  describe Queries::User do
    context "when passed a valid user id" do
      it "returns a user with the correct id" do
        first_user_id = User.first.id

        prepare_query('query user($id: ID!){
                user(id: $id) {
                    id
                }
                }')

        prepare_query_variables(
          id: first_user_id
        )

        user_id = graphql!["data"]["user"]["id"].to_i
        expect(user_id).to(eq(first_user_id))
      end
    end

    context "when passed an invalid user id" do
      it "returns a user with the correct id" do
        invalid_id = 100

        prepare_query('query user($id: ID!){
                  user(id: $id) {
                      id
                  }
                  }')

        prepare_query_variables(
          id: invalid_id
        )

        graphql_result = graphql!
        expect(graphql_result["errors"][0]["message"]).to(eq("ERROR: User of given ID is nil"))
      end
    end
  end

  describe Queries::Profile do
    context "when not logged in" do
      it "returns jwt required error" do
        query = 'query profile{
            profile {
                id
            }
            }'

        prepare_query(query)
        error = graphql!["errors"][0]["message"]
        expect(error).to(eq("ERROR: Not logged in or missing token"))
      end
    end
  end

  context Queries::Profile do
    describe GraphqlController, type: :controller do
      context "when logged in" do
        it "succesfully returns user profile" do
          query = 'query profile{
            profile {
                id
            }
            }'

          # send request with the token of the user we pretended to login
          user_id = { id: @user.id }
          token = JWT.encode(user_id, Rails.application.secrets.secret_key_base.byteslice(0..31))
          headers = { Authentication: token }
          request.headers.merge!(headers)
          post :execute, params: { query: query }

          # receive response
          response_body = JSON.parse(response.body)
          desire_user = User.find_by(email: "user@email.com")
          expect(response_body["data"]["profile"]["id"].to_i).to(eq(desire_user.id))
        end
      end
    end
  end
end

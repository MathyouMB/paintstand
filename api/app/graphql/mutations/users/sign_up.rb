module Mutations
  module Users
    # Mutation for creating a new User
    class SignUp < Mutations::BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true
      argument :passwordConfirmation, String, required: true
      argument :username, String, required: true

      type Types::UserType

      # add password validation error handling
      def resolve(email:, password:, password_confirmation:, username:)
        return GraphQL::ExecutionError.new("ERROR: password and password confirmation are not the same") unless password == password_confirmation
        return GraphQL::ExecutionError.new("ERROR: email already used by other user") unless User.where(email: email).empty?
        return GraphQL::ExecutionError.new("ERROR: username already used by other user") unless User.where(username: username).empty?

        user = User.create!(
          username: username,
          email: email,
          password: password,
          balance: 10000,
          role: "public"
        )

        raise GraphQL::ExecutionError, user.errors.full_messages.join(", ") unless user.errors.empty?

        user
      end
    end
  end
end

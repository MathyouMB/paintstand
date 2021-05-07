# The GraphQL Controller
class GraphqlController < ApplicationController
  def execute
    context = {
      current_user: current_user,
    }

    result = if params[:_json]
      queries = params[:_json].map do |param|
        {
          query: param[:query],
          operation_name: param[:operationName],
          variables: ensure_hash(param[:variables]),
          context: context,
        }
      end
      ServerSchema.multiplex(queries)
    else
      ServerSchema.execute(
        params[:query],
        operation_name: params[:operationName],
        variables: ensure_hash(params[:variables]),
        context: context
      )
    end

    render(json: result)
  end

  private

  def current_user
    header = request.headers[:Authentication]
    decrypted = JWT.decode(header, Rails.application.secrets.secret_key_base.byteslice(0..31))[0] # decrypt token using secret key
    user = User.fetch(decrypted["id"]) # find the user given the decrypted id
    user
  rescue JWT::DecodeError
    nil
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))

    render(json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: :internal_server_error)
  end
end

# frozen_string_literal: true

module SwaggerHelpers

  # Add response examples to Swagger documentation
  # Usage:
  #   response 200, 'success' do
  #     after do |example|
  #       example_data = {a: 1, b: 2}
  #       add_response_example(example, example_data)
  #     end
  #   end
  def add_response_example(example, example_data)
    metadata = example.metadata
    content = metadata.dig(:metadata, :response, :content) || {}

    json_mime = Mime[:json].to_s

    example_spec = {
      json_mime => {
        example: example_data
      }
    }

    metadata[:response][:content] = content.deep_merge(example_spec)
  end

end

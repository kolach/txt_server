require 'sinatra/base'

module TxtServer

  class Base < Sinatra::Base

    register ::Sinatra::ErrorHandling

    configure do
      # serve static recipe files
      set :public_folder, Proc.new { File.join(root, "data") }
      # use our custom error handlers
      set :show_exceptions, false
    end

    # Run the following before every API request
    # JSON all the time
    before do
      content_type :json
    end

    helpers do

      # encode json
      def json(json)
        MultiJson.dump(json, pretty: true)
      end

      # decode json
      def parsed_request_body
        if request.content_type.include?("multipart/form-data;")
          parsed = params
        else
          parsed = MultiJson.load(request.body, symbolize_keys: true)
        end
        bad_request("The request body you provide must be a JSON hash") unless parsed.is_a?(Hash)
        return parsed
      end

    end

  end

end

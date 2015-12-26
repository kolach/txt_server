require "sinatra/base"

module Sinatra
  
  module ErrorHandling

    module Helpers

      def bad_request(message = nil)
        message ||= 'Bad request'
        halt 400, json({message: message})
      end

      def nothing_found(message = nil) 
        message ||= 'Nothing found'
        halt 404, json({message: message})
      end

    end

    def self.registered(app)

      app.helpers ErrorHandling::Helpers

      app.error MultiJson::DecodeError do
        bad_request("Problems parsing JSON")
      end

      app.error TxtSearch::ParseError do |e|
        bad_request(e)
      end

    end

  end

  register ErrorHandling
end

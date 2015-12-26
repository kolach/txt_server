module TxtServer

  class App < Base

    post '/_search'  do
      params = parsed_request_body
      tester = TxtSearch::Search.new(params)
      result = Search.find_docs(settings.public_folder, tester)
      nothing_found() if result[:hit] == 0
      json(result)
    end

  end

end

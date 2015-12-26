module ApiHelpers

  def json(data)
    MultiJson.dump(data, {pretty: true})
  end

  def decode_json(data)
    MultiJson.load(data, symbolize_keys: true)
  end

  def response_body
    decode_json(last_response.body)
  end

  def post_query(data)
    json_data = json(data) unless data.is_a?(String)
    post('/_search', json_data, { "content_type" => "application/json" })
  end

end

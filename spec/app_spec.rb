require File.expand_path '../spec_helper.rb', __FILE__

describe TxtServer::App do

  describe '/_search' do

    before(:each) do
      @search_service = class_double('TxtServer::Search').as_stubbed_const(transfer_nested_constants: true)
    end

    it "calls TxtServer::Search service to obtain results" do
      expect(@search_service).to receive(:find_docs).and_return({hit: 1})
      post_query({query: 'oil'})
    end

    context 'results found' do

      let(:search_result) {
        {
          total: 100,
          hit: 2,
          documents: [
            {
              name: 'recipe1',
              filename: 'recipe1.txt',
              content: %{
                60ml gin
                20ml vodka
                10ml Lillet Blanc or Cocchi Americano
              }
            }, {
              name: 'recipe2',
              filename: 'recipe2.txt',
              content: %{
                half Lime, cut into wedges
                2 tsp Sugar
                2 oz Cachaça
              }
            }

          ]
        }
      }

      before(:each) do
        allow(@search_service).to receive(:find_docs).and_return(search_result)
        post_query({query: 'oil'})
      end

      it "should respond with status 200" do
        expect(last_response).to be_ok
      end

      it "should respond in JSON" do
        expect(last_response.headers["Content-Type"]).to eq("application/json")
      end

      it 'should respond with result of TxtServer::Search.find_docs converted to json' do
        expect(last_response.body).to eq(json(search_result))
      end

    end

    context 'nothing found' do 
      before(:each) do
        allow(@search_service).to receive(:find_docs).and_return({hit: 0})
        post_query({query: 'oil'})
      end

      it "should respond in JSON" do
        expect(last_response.headers["Content-Type"]).to eq("application/json")
      end

      it "should respond with 404 if no docs found" do
        expect(last_response.status).to eq(404)
        expect(response_body[:message]).to eq("Nothing found")
      end
    end

    it "should fail if payload is not valid JSON" do
      post_query("bananas AND appples")
      expect(last_response.status).to eq(400)
      expect(response_body[:message]).to eq("Problems parsing JSON")
    end

    it "should fail if payload is not a valid Query" do
      post_query({query: 'bananas AND appples)'})
      expect(last_response.status).to eq(400)
      expect(response_body[:message]).to eq("Query parse error at offset: 19")
    end

  end

  it "serves static files" do
    get '/pasta_salad.txt'
    expect(last_response).to be_ok
  end


end

require File.expand_path '../spec_helper.rb', __FILE__

describe TxtServer::Search do

  subject { TxtServer::Search }

  let(:recipes_dir) { '/var/lib/recipes' }
  let(:recipe1) { File.join(recipes_dir, 'recipe1.txt') }
  let(:recipe2) { File.join(recipes_dir, 'recipe2.txt') }
  let(:recipe3) { File.join(recipes_dir, 'recipe3.txt') }

  let(:sample_content) {
    %{
      60ml gin
      20ml vodka
      10ml Lillet Blanc or Cocchi Americano
    }
  }

  let(:other_content) {
    %{
      half Lime, cut into wedges
      2 tsp Sugar
      2 oz Cachaça
    }
  }

  describe '.make_doc' do
    let(:filename) { '/var/lib/martini_007.txt' }

    it 'makes document item' do
      doc = subject.make_doc(filename, sample_content)
      expect(doc[:name]).to eq('martini 007')
      expect(doc[:filename]).to eq('martini_007.txt')
      expect(doc[:content]).to eq(sample_content)
    end
  end

  describe '.walk_docs' do

    it 'returns total number of processed documents' do
      allow(Dir).to receive(:glob).with("#{recipes_dir}/*.txt")
        .and_yield( recipe1 )
        .and_yield( recipe2 )
        .and_yield( recipe3 )
      allow(IO).to receive(:read).and_return(sample_content)
      tester = double('tester')
      allow(tester).to receive(:test) { true }
      total = subject.walk_docs(recipes_dir, tester)
      expect(total).to eq(3)
    end

    it 'tests calling tester#test if content is fit to search query' do
      allow(Dir).to receive(:glob).with("#{recipes_dir}/*.txt").and_yield(recipe1).and_yield(recipe2)
      allow(IO).to receive(:read).and_return(sample_content)
      tester = double('tester')
      allow(tester).to receive(:test) { true }
      expect(tester).to receive(:test).with(sample_content).twice
      subject.walk_docs(recipes_dir, tester) {}
    end

    it 'yields docs' do
      allow(Dir).to receive(:glob).with("#{recipes_dir}/*.txt").and_yield( recipe1 )
      allow(IO).to receive(:read).and_return(sample_content)
      tester = double('tester')
      allow(tester).to receive(:test) { true }

      subject.walk_docs(recipes_dir, tester) do |doc|
        expect(doc[:name]).to eq('recipe1')
        expect(doc[:filename]).to eq('recipe1.txt')
        expect(doc[:content]).to eq(sample_content)
      end
    end

  end

  describe '.find_docs' do

    before(:each) do
      allow(Dir).to receive(:glob).with("#{recipes_dir}/*.txt").and_yield( recipe1 ).and_yield( recipe2 )

      allow(IO).to receive(:read).with(recipe1).and_return(sample_content)
      allow(IO).to receive(:read).with(recipe2).and_return(other_content)

      tester = double('tester')
      allow(tester).to receive(:test).with(sample_content).and_return(false)
      allow(tester).to receive(:test).with(other_content).and_return(true)
      @result = subject.find_docs(recipes_dir, tester)
    end

    it 'returns total number of processed documents' do
      expect(@result[:total]).to eq(2)
    end

    it 'counts a number of hit documents' do
      expect(@result[:hit]).to eq(1)
    end

    it 'returns array of found documents' do
      expect(@result[:documents].size).to eq(1)
      doc = @result[:documents][0]
      expect(doc[:name]).to eq('recipe2')
      expect(doc[:content]).to eq(other_content)
      expect(doc[:filename]).to eq('recipe2.txt')
    end
  end

end


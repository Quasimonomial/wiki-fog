require 'rails_helper'

describe WikipediaService do
  describe '#initialize' do
    context 'when a word count is provided' do
      context "when the word count is 200 or less" do
        it 'should set the options to the provided params' do
          service = WikipediaService.new({"article_title"=>"words", "word_count"=>"70"})
          expect(service.article_title).to eq("words")
          expect(service.random_page).to be_nil
          expect(service.word_count).to eq(70)
        end
      end

      context 'when the word count is over 200' do
        it "should set the word count to 200" do
          service = WikipediaService.new({"article_title"=>"words", "word_count"=>"500"})
          expect(service.word_count).to eq(200)
        end
      end

      context 'when a word count is not provided' do
        it "should set the word count to 200" do
          service = WikipediaService.new({"article_title"=>"words", "word_count"=>"500"})
          expect(service.word_count).to eq(200)
        end
      end
    end
  end

  describe '#get_page_data' do
    context 'the article is found' do
      it 'returns text a frequency hash of the given length' do
        service = WikipediaService.new({"article_title"=>"United States"})
        service.stub(:get_link_text).and_return('')
        service.stub(:fetch_links).and_return([])

        expect(service.get_page_data).to be_truthy
        expect(service.get_page_data.length).to eq(service.word_count)
      end
    end

    context 'the article is not found' do
      it 'returns false' do
        service = WikipediaService.new({"article_title"=>"garbage text poiuytrewqlkjhgfdsamnbvcxz"})
        expect(service.get_page_data).to be_falsey
      end
    end

    context 'no article title is given' do
      it 'returns false' do
        service = WikipediaService.new()
        expect(service.get_page_data).to be_falsey
      end
    end
  end

  describe '#generate_word_frequency_hash' do
    it 'returns a frequency hash of appearing words' do
      service = WikipediaService.new()
      text = "b b c c c"
      expect(service.send(:generate_word_frequency_hash, text)).to eq([{"text"=>"c", "weight"=>3}, {"text"=>"b", "weight"=>2}])
    end

    it 'ignores blacklisted words' do
      service = WikipediaService.new()
      text = "has has has has has has a a a a b b c c c"
      expect(service.send(:generate_word_frequency_hash, text)).to eq([{"text"=>"c", "weight"=>3}, {"text"=>"b", "weight"=>2}])
    end

    it "respects the services's word count" do
      service = WikipediaService.new({"word_count"=>"3"})
      text = "b b c c c d d d d d d e e e e e f f f f f f f f f g"
      expect(service.send(:generate_word_frequency_hash, text)).to eq([{"text"=>"f", "weight"=>9}, {"text"=>"d", "weight"=>6}, {"text"=>"e", "weight"=>5}])
    end
  end

  describe '#get_page' do
    context 'random_page is true' do
      it "returns a random page" do
        service = WikipediaService.new({"random_page"=>true})
        Wikipedia::Client.any_instance.stub(:find_random).and_return(
          Wikipedia::Page.new({
            'query' => {
              'pages' => {
                '0' => {
                  'title' => 'Dragon'
                }
              }
            }
          }.to_json)
        )
        service.send(:get_page_data)
        expect(service.article_title).to eq('Dragon')
      end
    end

    context 'random_page is false' do
      context 'article is found' do
        it 'finds that article and returns it' do
          service = WikipediaService.new({"article_title"=>"cat"})
          expect(Wikipedia).to receive(:find).with(service.article_title)
          service.send(:get_page_data)
        end
      end

      context 'article is not found' do
        it "returns false" do
          service = WikipediaService.new({"article_title"=>"garbage text poiuytrewqlkjhgfdsamnbvcxz"})
          service.send(:get_page_data)
        end
      end
    end
  end
end

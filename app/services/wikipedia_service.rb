class WikipediaService
  require 'uri'
  require 'wikipedia'

  MOST_COMMON_WIKIPEDIA_WORDS = ["time","person","year","way","day","thing","man","world","life","hand","part","child","eye","woman","place","work","week","case","point","government","company","number","group","problem","fact","be","have","do","say","get","make","go","know","take","see","come","think","look","want","give","use","find","tell","ask","work","seem","feel","try","leave","call","good","new","first","last","long","great","little","own","other","old","right","big","high","different","small","large","next","early","young","important","few","public","bad","same","able","to","of","in","for","on","with","at","by","from","up","about","into","over","after","beneath","under","above","the","and","a","that","I","it","not","he","as","you","this","but","his","they","her","she","or","an","will","my","one","all","would","there","their"]

  WORD_BLACKLIST = MOST_COMMON_WIKIPEDIA_WORDS + ["has", "also", "which", "s", "was", "are", "is", "if", "no", "like", "where", "being", "who", "them", "had", "however", "often", "while", "only", "many", "during", "between", "these", "when", "most", "such", "than", "some", "more", "been", "may", "cats", "were", "its"]

  attr_accessor :article_title, :random_page, :word_count

  def initialize options = {}
    options["word_count"] = 50 if options["word_count"].blank?
    @article_title = options["article_title"]
    @random_page = options["random_page"]
    @word_count = [options["word_count"].to_i, 200].min
  end

  def get_page_data
    page = get_page

    return false unless page && page.text

    text = page.text

    text += get_link_text fetch_links

    generate_word_frequency_hash text
  end

  private

  def generate_word_frequency_hash text
    frequency_hash = Hash.new(0)

    words = text.split(/\W+|'/)

    words.each do |word|
      next if WORD_BLACKLIST.include?(word.downcase)
      frequency_hash[word.downcase] += 1
    end

    frequency_hash.sort_by{|k, v| -v}.first(word_count).map do |word|
      { "text" => word[0], "weight" => word[1]}
    end
  end

  def get_link_text links
    text = ''
    links.each_slice(20) do |links|
      api_link = URI.escape("http://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exlimit=max&exintro&explaintext&titles=#{links.join('|')}")
      response = HTTParty.get(api_link)

      response["query"]["pages"].each do |id, article|
        begin
          article_text = article["extract"]
          text += article_text
        rescue
        end
      end
    end
    text
  end

  def get_page
    if random_page
      random_page = Wikipedia::Client.new.find_random
      @article_title = random_page.title
      random_page
    else
      return false if article_title.blank?
      Wikipedia.find( article_title )
    end
  end

  def fetch_links
    wikipedia_link_base = "https://en.wikipedia.org/w/api.php?action=query&prop=links&format=json&pllimit=max&titles="

    plcontinue = ''
    link_names = []

    loop do
      wikipedia_page_link = "#{wikipedia_link_base}#{article_title}#{plcontinue}"
      response = HTTParty.get(wikipedia_page_link)
      continue_value = response["continue"].try(:[], "plcontinue")
      plcontinue = continue_value ? "&plcontinue=#{continue_value}" : nil

      response["query"]['pages'].first[1]["links"].each do |link|
        link_names << link["title"]
      end

      break unless plcontinue
    end

    link_names
  end
end

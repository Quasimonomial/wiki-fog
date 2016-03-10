class WikipediaService
  require 'wikipedia'

  MOST_COMMON_WIKIPEDIA_WORDS = ["time","person","year","way","day","thing","man","world","life","hand","part","child","eye","woman","place","work","week","case","point","government","company","number","group","problem","fact","be","have","do","say","get","make","go","know","take","see","come","think","look","want","give","use","find","tell","ask","work","seem","feel","try","leave","call","good","new","first","last","long","great","little","own","other","old","right","big","high","different","small","large","next","early","young","important","few","public","bad","same","able","to","of","in","for","on","with","at","by","from","up","about","into","over","after","beneath","under","above","the","and","a","that","I","it","not","he","as","you","this","but","his","they","her","she","or","an","will","my","one","all","would","there","their"]

  WORD_BLACKLIST = MOST_COMMON_WIKIPEDIA_WORDS + ["has", "also", "which", "s", "was", "are", "is", "if", "no", "like", "where", "being", "who", "them", "had", "however", "often", "while", "only", "many", "during", "between", "these", "when", "most", "such", "than", "some", "more", "been", "may", "cats", "were"]


  def do_the_thing
    article_title = 'Cat'

    page = Wikipedia.find( article_title )

    text = page.text
    links = WikipediaService.fetch_links article_title

    links.each do |link|
      puts "fetching #{link}"
      link_page = Wikipedia.find(link)
      text += " #{link_page.text} "
    end

    generate_word_frequency_hash text
  end

  def generate_word_frequency_hash text
    frequency_hash = Hash.new(0)

    words = text.split(/\W+|'/)

    words.each do |word|
      next if WORD_BLACKLIST.include?(word.downcase)
      frequency_hash[word.downcase] += 1
    end

    pp Hash[frequency_hash.sort_by{|k, v| v}]

    frequency_hash
  end

  def find_random_article
    Wikipedia.find_random_article
  end

  def self.fetch_links title
    wikipedia_link_base = "https://en.wikipedia.org/w/api.php?action=query&prop=links&format=json&pllimit=max&titles=#{title}"

    plcontinue = ''
    link_names = []

    loop do
      wikipedia_page_link = "#{wikipedia_link_base}#{plcontinue}"
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

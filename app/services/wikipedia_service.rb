class WikipediaService
  require 'wikipedia'

  WORD_BLACKLIST = ["the", "and", "of", "to", "a", "is", "as", "with", "their", "by",
    "or", "be", "on", "s", "at", "nt", "t", "f", "in", "for", "are"]

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

    words = text.split(/\W+/)

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
    wikipedia_link = "https://en.wikipedia.org/w/api.php?action=query&prop=links&format=json&pllimit=500&titles=#{title}"
    response = HTTParty.get(wikipedia_link)
    link_pile = response["query"]['pages'].first[1]["links"]

    link_names = []

    link_pile.each do |link|
      link_names << link["title"]
    end

    link_names
  end
end

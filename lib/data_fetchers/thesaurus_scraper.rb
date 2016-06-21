# ThesaurusScraper class scrapes synonyns from thesaurus.com/browse.
#
# It scrapes the synonyms and their respective word scores, and returns them as an array.

class ThesaurusScraper

  def new_thesaurus(current_word)
    # Generate new thesaurus word/pairs unit.
    words_values_array = get_word_value_array(current_word)
    words_values = parse_words_and_values(words_values_array[0])
    [words_values, words_values_array[1]]
  end

  # def query(word)
  #   # Return false if word is not in synonym list, or a point value if it is.
  # end

  def get_word_value_array(word)
    html = RestClient.get("http://www.thesaurus.com/browse/#{word}")
    word_string = Nokogiri::HTML(html).css("div.relevancy-list ul li a").to_a
    part_of_speech = Nokogiri::HTML(html).css("div.mask ul li a em")[0].text
    word_definition = Nokogiri::HTML(html).css("div.mask ul li a strong")[0].text
    [word_string, "(#{part_of_speech}) #{word_definition}"]
  end

  def parse_words_and_values(wv_array)
    words_values = {}
    wv_array.each do |attribute|
      word = attribute.children.first.text
      score = attribute.attr("data-complexity").to_i * attribute.attr("data-category").match(/relevant-(.)/)[1].to_i
      words_values[word] = score
    end

    words_values
  end

  def test_scraper
    begin
      get_word_value_array("test")
    rescue 
      return false
    else
      return true
    end
  end

end
# APIEngine class interacts with the Thesaurus API.
#  
# It returns to the Game a full thesaurus list for a single word.


class APIEngine
  attr_reader :wordlist

  def initialize
    @thesaurus_api_key = YAML.load_file("#{__dir__}/api.yml")["THESAURUS_KEY"]
    @dictionary_api_key = YAML.load_file("#{__dir__}/api.yml")["DICTIONARY_KEY"]
  end

  def new_thesaurus(current_word)
    # Generate new thesaurus word/pairs unit.
    xml = get_xml(current_word)
    synonym_list = parse_xml_into_synonym_array(xml)
  end

  def query(word)
    # Return false if word is not in synonym list, or a point value if it is.
  end

  def get_xml(word)
    RestClient.get("http://www.dictionaryapi.com/api/v1/references/thesaurus/xml/#{word}?key=#{@thesaurus_api_key}")
  end

  def parse_xml_into_synonym_array(xml)
    word_array = []
    word_string = Nokogiri::XML(xml).css("syn").text
    word_string.split(", ").each do |word|
      word.gsub!(/ \[.+\]/, "") if word.include?("[") # Removes words with bracketed notes at the end.

      if word.include?("(s)") # If words have (s) at the end, adds both the word and its plural.
        w = word.gsub(" (s)", "")
        word_array << [w, w + "s"]
      else word_array << word
      end
    end
    word_array.flatten
  end

end

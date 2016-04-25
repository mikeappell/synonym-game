# Game class. 
# 
# Holds onto the thesaurus listing for a single word, which is sent to it by APIEngine.
# Sends to the API the current randomly generated word, and takes guesses/returns answers.
# Keeps track of score.

class Game
  attr_accessor :total_score, :current_score
  attr_reader :api_engine

  def initialize
    @scraper = ThesaurusScraper.new
    @random_word = RandomWord.new
    @total_score = 0
    @current_score = 0
    @guesses = []
  end

  def start_game
    @current_word = @random_word.get_new_word
    @current_thesaurus = @scraper.new_thesaurus(@current_word)
    @all_synonyms = @current_thesaurus.keys
    @current_score = 0
    @current_word
  end

  def end_game
    @total_score += @current_score
    hits_and_misses
  end

  def guess_word(word)
    if @guesses.include?(word)
      "Already guessed"
    elsif @all_synonyms.include?(word)
      @current_score += @current_thesaurus[word]
      @guesses << word
      @current_thesaurus[word]
    else 
      @guesses << word
      false
    end
  end

  def current_word_definition

  end

  def hits_and_misses
    guesses_correct, guesses_wrong, all_words, all_words_guessed = [], [], [], []

    @current_thesaurus.each do |word, value|
      if @guesses.include?(word) 
        all_words_guessed << "#{word.bluebold} : #{value}".ljust(40)
      else 
        all_words << "#{word} : #{value}".ljust(30)
      end
    end

    @guesses.each do |word|
      if @all_synonyms.include?(word)
        guesses_correct << word.bluebold.ljust(30)
      else
        guesses_wrong << word.redbold.ljust(30)
      end
    end

    [guesses_correct, guesses_wrong, all_words, all_words_guessed]
  end
  
  def test_scraper
    @scraper.test_scraper
  end

end
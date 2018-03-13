# Game class. 
# 
# Holds onto the thesaurus listing for a single word, which is sent to it by APIEngine.
# Sends to the API the current randomly generated word, and takes guesses/returns answers.
# Keeps track of score.

class Game
  attr_accessor :total_score, :current_score
  attr_reader :api_engine

  def initialize(word = nil)
    @scraper = ThesaurusScraper.new
    @random_word = RandomWord.new
    @total_score = 0
    @current_score = 0
    @guesses = []
  end

  def start_game
    @current_word = @random_word.get_new_word
    @current_thesaurus, word_definition = @scraper.new_thesaurus(@current_word)
    @all_synonyms = @current_thesaurus.keys
    @current_score = 0
    @guesses = []
    "#{@current_word} - #{word_definition}"
  end

  def end_game(cli: true)
    @total_score += @current_score
    hits_and_misses(cli)
  end

  def guess_word(word)
    if @guesses.include?(word)
      "Already guessed"
    elsif word == @current_word
      "Original word"
    elsif  @all_synonyms.include?(word)
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

  def hits_and_misses(cli = true)
    guesses_correct, guesses_wrong, all_words, all_words_guessed = [], [], [], []

    @current_thesaurus.each do |word, value|
      if @guesses.include?(word) 
        all_words_guessed << (cli ? "#{word.bluebold} : #{value}".ljust(43) : "#{word} : #{value}")
      else 
        all_words << (cli ? "#{word} : #{value}".ljust(30) : "#{word} : #{value}")
      end
    end

    @guesses.each do |word|
      if @all_synonyms.include?(word)
        guesses_correct << (cli ? word.bluebold.ljust(30) : word)
      else
        guesses_wrong << (cli ? word.redbold.ljust(30) : word)
      end
    end

    { guesses_correct: guesses_correct, guesses_wrong: guesses_wrong,
      all_words: all_words, all_words_guessed: all_words_guessed }
  end

  def test_scraper
    @scraper.test_scraper
  end

end
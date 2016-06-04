class CLI

  def start
    puts "Welcome to the Synonym Game!"
    @game = Game.new

    test_scraper

    user_options
  end

  def help
    puts "Typing (p) for Play will begin a new game. You will be presented with a word, "
  end

  def user_options
    puts "Would you like to play a game? Options are #{"play (p)".greenbold}, see your #{"current score (s)".greenbold}, view the #{"help (h)".greenbold} options, and #{"quit (q)".redbold}."
    choice = gets.chomp
    if choice == "p"
      play_game
    elsif choice == "q"
      quit
    elsif choice == "h"
      # help
      user_options
    elsif choice == "s"
      puts "Current score is #{@game.current_score}."
      user_options
    else
      puts "Didn't quite catch that."
      user_options
    end
  end

  def play_game
    @lines_down = 1
    current_word = @game.start_game
    puts "Your word is '#{current_word}'."
    # puts "Your word is '#{current_word}'. Definition: #{@game.current_word_definition}."
    puts "Enter any and all synonyms you can think of. Type #{"q".redbold} if you want to exit early."
    puts "Go!\n"

    @timer_thread = Thread.new {timer}
    @guess_thread = Thread.new {guesses_loop}
    @guess_thread.join

    @game.end_game
    puts "\n\nGame complete! You scored #{@game.current_score.to_s.green}. Your total score for this session is #{@game.total_score.to_s.green}.\n"
    guesses_correct, guesses_wrong, all_words, all_words_guessed = @game.hits_and_misses
    puts "Your guesses were:\n"
    present_word_array(guesses_correct)
    present_word_array(guesses_wrong)
    puts "\nAll possible synonyms:\n"
    present_word_array(all_words)
    present_word_array(all_words_guessed)

    puts "\n\n"
    user_options
  end

  def quit
    puts "Hope you had fun! Seeya next time."
  end

  def timer
    countdown = 30
    start = Time.now
    countdown.times do 
      sleep(1)
    end
    @guess_thread.exit
  end

  def guesses_loop
    loop do
      guess = gets.chomp
      if guess == "q"
        @timer_thread.exit
        break
      end
      value = @game.guess_word(guess)
      if value == "Already guessed"
        puts "Already guessed that one, can't fool me!"
      elsif value
        puts "Correct! That word was worth #{value} points. Your score is #{@game.current_score}."
      else 
        puts "Incorrect! Try again."
      end
    end
  end

  def present_word_array(word_array)
    word_array.each_with_index do |word, index|

      # Formats the array listing, spacing it into two columns.

      unless (index + 1) % 4 == 0
        print "#{word.to_s}"
      else puts "#{word}"
      end
    end
    puts "\n"
  end

  def test_scraper
    if @game.test_scraper
      puts "Internet connection active, scraper functioning correctly.".greenbold
    else 
      puts "No internet connection, scraper is down. Try again later.".redbold
    end
  end

  # def update_timer(countdown, start)
  #   print "\033[s" + "\n"
  #   print "Timer: #{((countdown - (Time.now - start)).to_i)}" + "\033[u"
  # end

end
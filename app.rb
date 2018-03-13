require_relative 'config/environment'

class App < Sinatra::Base

  configure do
    set :game, nil
    set :test, nil
  end

  get '/' do
    erb :index
  end

  post '/startGame.json', provides: :json do
    settings.game ||= Game.new
    # UpdateCounts.update_play_count
    content_type :json
    { current_word: settings.game.start_game }.to_json
  end

  post '/startGameWithWord.json', provides: :json do
    settings.game ||= Game.new
    content_type :json
    { current_word: settings.game.start_game }.to_json
  end
  
  post '/endGame.json', provides: :json do
    hits_and_misses = settings.game.end_game(cli: false)
    content_type :json
    { hits_and_misses: hits_and_misses }.to_json
  end

  post '/newView.json' do
    # UpdateCounts.update_view_count
    status 200
    body ''
  end

  post '/makeGuess.json', provides: :json do
    guessed_word = Rack::Utils.escape_html(params[:guess])
    returned_value = settings.game.guess_word(guessed_word)
    content_type :json
    { returned_value: returned_value, guess: guessed_word }.to_json
  end

end
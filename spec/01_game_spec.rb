require_relative 'spec_helper'

describe "Game" do

  let(:new_game) { Game.new }
  let(:thesaurus) { thesaurus = new_game.instance_variable_get(:@current_thesaurus).dup }

  describe "#initialize" do
    it "starts with 0 score" do
      expect(new_game.current_score).to eq(0)
    end
  end

  describe "#start_game" do
    it "has a current word" do
      expect(new_game.start_game).to be_a(String)
      expect(new_game.start_game.length).to be > 0
    end

    it "has a current thesaurus" do
      new_game.start_game
      expect(thesaurus).to be_a(Hash)
      expect(thesaurus.keys.size).to be > 0
    end
  end

  describe "#guess_word" do

    before(:each) do
      new_game.start_game
    end

    it "knows when you've already guessed a word" do
      new_game.guess_word(thesaurus.keys.first)
      expect(new_game.guess_word(thesaurus.keys.first)).to eq("Already guessed")
    end

    context "correct guess" do
      it "increments the current score" do
        score = new_game.guess_word(thesaurus.keys.first)
        expect(new_game.instance_variable_get(:@current_score)).to eq(score)
      end

      it "returns the word score" do
        expect(new_game.guess_word(thesaurus.keys.first)).to eq(thesaurus[thesaurus.keys.first])
      end

      it "adds the word to guesses" do
        new_game.guess_word(thesaurus.keys.first)
        expect(new_game.instance_variable_get(:@guesses)).to include(thesaurus.keys.first)
      end
    end

    context "incorrect guess" do
      it "doesn't increment the score" do
        new_game.guess_word("nevergonnagiveuupnevergonnaletudown")
        expect(new_game.instance_variable_get(:@current_score)).to eq(0)
      end
      
      it "adds the word to guesses" do
        new_game.guess_word("nevergonnagiveuupnevergonnaletudown")
        expect(new_game.instance_variable_get(:@guesses)).to include("nevergonnagiveuupnevergonnaletudown")
      end
    end
  end

  describe "#end_game" do
    it "increments total score" do
      new_game.start_game
      score = new_game.guess_word(thesaurus.keys.first)
      new_game.end_game
      expect(new_game.instance_variable_get(:@total_score)).to eq(score)
    end

    it "returns an array containing hits and misses" do
      new_game.start_game
      expect(new_game.end_game).to be_an(Array)
    end
  end

  describe "#hits_and_misses" do
    it "returns a 2d array containing user guess hits and misses" do
      new_game.start_game
      gg1 = thesaurus.keys[0]
      gg2 = thesaurus.keys[1]
      bg1 = "jibbajabbajibbajabba!!"
      bg2 = "wubbalubbadubdub!!"

      vals = [gg1, gg2, bg1, bg2].map { |guess| new_game.guess_word(guess) }
      [gg1, gg2, bg1, bg2].each { |guess| thesaurus.delete(guess) }

      new_game.end_game
      all_guesses = ["#{gg1.bluebold} : #{vals[0]}".ljust(43), "#{gg2.bluebold} : #{vals[1]}".ljust(43)]
      all_words = thesaurus.map{ |word, score| "#{word} : #{score}".ljust(30)}
      expect(new_game.hits_and_misses).to eq([[gg1.bluebold.ljust(30), gg2.bluebold.ljust(30)], [bg1.redbold.ljust(30), bg2.redbold.ljust(30)], all_words, all_guesses])
    end
  end
end
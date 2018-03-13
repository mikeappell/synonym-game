# RandomWord class.
#
# Parses and remembers simple wordlist. Returns random word from wordlist.

class RandomWord
  def initialize
    @wordlist = File.read("./db/wordlist.txt").split("\n")
  end

  def get_new_word
    random_index = rand(@wordlist.size)
    @wordlist[random_index]
  end
end
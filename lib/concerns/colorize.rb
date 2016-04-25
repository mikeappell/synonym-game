class String

  def green
    Term::ANSIColor.green + self + Term::ANSIColor.clear
  end

  def red
    Term::ANSIColor.red + self + Term::ANSIColor.clear
  end

  def blue
    Term::ANSIColor.blue + self + Term::ANSIColor.clear
  end

  def bold
    Term::ANSIColor.bold + self + Term::ANSIColor.clear
  end

  def greenbold
    Term::ANSIColor.green + Term::ANSIColor.bold + self + Term::ANSIColor.clear
  end

  def redbold
    Term::ANSIColor.red + Term::ANSIColor.bold + self + Term::ANSIColor.clear
  end
  
  def bluebold
    Term::ANSIColor.blue + Term::ANSIColor.bold + self + Term::ANSIColor.clear
  end

end
require_relative 'dictionary'

class Descrambler
  def initialize(letters)
    @letters = letters.gsub(/[^a-zA-Z]/, '').downcase.chars
  end

  def suggest
    selected_words = ::Dictionary.words_with_char_count(@letters.length).select do |word|
      word.chars.sort == @letters.sort
    end
    selected_words
  end
end

# puts Descrambler.new('octsnare').suggest
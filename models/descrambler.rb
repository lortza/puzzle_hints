require_relative 'dictionary'

class Descrambler
  def initialize(input)
    @input = input.gsub(/[^a-zA-Z]/, '').downcase
    @letters = @input.chars
  end

  def suggest
    selected_words = ::Dictionary.words_with_char_count(@letters.length).select do |word|
      word.chars.sort == @letters.sort
    end
    results = selected_words - [@input]
    results << "no results" if results.empty?
    results
  end
end

# puts Descrambler.new('octsnare').suggest
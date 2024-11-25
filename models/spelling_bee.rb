require_relative "dictionary"

class SpellingBee
  def initialize(must_contain: "", can_contain: "")
    @must_contain_letter = must_contain.gsub(/[^a-zA-Z]/, "").downcase
    @can_contain_letters = can_contain.gsub(/[^a-zA-Z]/, "").downcase.chars
    @containable_letters = @can_contain_letters << @must_contain_letter
  end

  def suggest
    ::Dictionary.words_with_min_char_count(4).select do |word|
      word_letters = word.chars.uniq
      word.include?(@must_contain_letter) && (word_letters - @containable_letters).length.zero?
    end
  end
end

# puts SpellingBee.new(
#   must_contain: 'n',
#   can_contain: 'dmoehy'
# ).suggest

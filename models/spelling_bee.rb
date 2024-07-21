require_relative 'dictionary'

module SpellingBee
  def self.spelling_bee(must_contain:, can_contain:)
    containable_letters = (can_contain << must_contain)
    selected_words = ::Dictionary.wordle_possible_answers.select do |word|
      word.chomp!
      next if word.length < 4
      word_letters = word.chars.uniq
      word.include?(must_contain) && (word_letters - containable_letters).length.zero?
    end
    pp selected_words
  end
end
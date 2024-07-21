module Dictionary
  def self.wordle_possible_answers
    # Source gist: https://gist.github.com/scholtes/94f3c0303ba6a7768b47583aff36654d
    # Alphabetical list of words that can be guessed and which can be the word of the day (2,315 words).
    words = File.open('data/wordle_dictionary_possible_answers.txt', "r")
    parse(words).map(&:upcase)
  end

  def self.wordle_valid_non_answers
    # Source gist: https://gist.github.com/scholtes/94f3c0303ba6a7768b47583aff36654d
    # Alphabetical list of words that can be guessed but are never selected as the word of the day (10,657 words).
    words = File.open('data/wordle_dictionary_valid_words_not_answers.txt', "r")
    parse(words).map(&:upcase)
  end

  def self.all
    words = File.open('data/words_alpha.txt', "r")
    parse(words)
  end

  # def self.four_char_min_words
  #   words = File.open('data/words_with_4_or_more_chars.txt', "r")
  #   parse(words)
  # end

  def self.words_with_char_count(num)
    words = File.open('data/words_alpha.txt', "r")
    words.readlines.select { |w| w.length == num + 2 }.map { |w| w.gsub(/\r\n/, '') }.map(&:downcase)
  end

  def self.words_with_min_char_count(num)
    words = File.open('data/words_alpha.txt', "r")
    words.readlines.select { |w| w.length >= num + 2 }.map { |w| w.gsub(/\r\n/, '') }.map(&:downcase)
  end

  def self.words_in_char_count_range(min:, max:)
    words = File.open('data/words_alpha.txt', "r")
    words.readlines.select { |w| (w.length >= min + 2) && (w.length <= max + 2) }.map { |w| w.gsub(/\r\n/, '') }.map(&:downcase)
  end

  private

  def self.parse(words)
    words.readlines.map { |w| w.gsub(/\n/, '') }
  end
end

# puts Dictionary.words_in_char_count_range(min: 6, max: 8)
# puts Dictionary.wordle_possible_answers
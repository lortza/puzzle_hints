require_relative "dictionary"

class Wordle
  PLACEHOLDER_CHARACTER = "_"

  def initialize(word_with_placeholders:, excluded_letters: "", required_letters: "", print_results: false)
    @submitted_word_with_placeholders = word_with_placeholders.upcase
    @excluded_letters = excluded_letters.gsub(/[^a-zA-Z]/, "").chars.uniq.map(&:upcase)
    @required_letters = required_letters.gsub(/[^a-zA-Z]/, "").chars.uniq.map(&:upcase)
    @available_letters = ("A".."Z").to_a - @excluded_letters
    @print_results = print_results
  end

  def temp_list
    %w[a b c d e f]
  end

  def suggest
    # raise 'Must have at least 1 known letter' if @submitted_word_with_placeholders.count(PLACEHOLDER_CHARACTER) > 4 && @excluded_letters.length < 10

    built_words = []
    words_with_placeholders = [@submitted_word_with_placeholders]
    # While this array of words has at least one presence of PLACEHOLDER_CHARACTER
    while words_with_placeholders.length > 0
      # Loop over each word...
      words_with_placeholders.each do |word|
        # Skip if the word does not have the placeholder character...
        next unless word.include?(PLACEHOLDER_CHARACTER)

        # For each word, replace the first instance of the placeholder...
        word.chars.each_with_index do |word_letter, index|
          # Skip this letter if it is alpha...
          next unless word_letter == PLACEHOLDER_CHARACTER

          @available_letters.each do |available_letter|
            word[index] = available_letter
            if word.include?(PLACEHOLDER_CHARACTER)
              words_with_placeholders << word.dup
            elsif !@required_letters.empty?
              (built_words << word.dup) if @required_letters.all? { |l| word.include?(l) }
            else
              built_words << word.dup
            end
          end # each available letter
          # remove original word from words_with_placeholders array
          words_with_placeholders.delete(word)
        end # each placeholder char
      end # words_with_placeholders.each
    end # while

    # Return only the words that appear in both the dictionary and the built words
    results = ::Dictionary.wordle_possible_answers & built_words
    results << "no suggestions" if results.empty?
    if @print_results
      puts results
      puts "-------"
      puts "#{results.length} words found"
      puts ""
      puts "FINISHED"
    else
      results
    end
  end
end

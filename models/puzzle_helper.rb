module PuzzleHelper
  # Wordle dictionary gist: https://gist.github.com/scholtes/94f3c0303ba6a7768b47583aff36654d
  # new:
  official_wordle_word_list = File.open("/Users/annerichardson/dev/learning/sandbox/wordle_dictionary_possible_answers.txt", "r")

  File.open("/Users/annerichardson/dev/learning/sandbox/words_sample.txt", "r")
  text_file = File.open("/Users/annerichardson/dev/learning/sandbox/words_alpha.txt", "r")
  File.open("/Users/annerichardson/dev/learning/sandbox/words_with_4_or_more_chars.txt", "r")
  # json_file = File.open('/Users/annerichardson/dev/learning/sandbox/words_dictionary.json', "r")
  DICTIONARY_WORDS = official_wordle_word_list.readlines.map { |w| w.delete("\n") }.map(&:upcase)
  FIVE_CHAR_WORDS = text_file.readlines.select { |w| w.length == 7 }.map { |w| w.gsub("\r\n", "") }.map(&:upcase)

  def self.spelling_bee(must_contain:, can_contain:)
    containable_letters = (can_contain << must_contain)
    selected_words = DICTIONARY_WORDS.select do |word|
      word.chomp!
      next if word.length < 4
      word_letters = word.chars.uniq
      word.include?(must_contain) && (word_letters - containable_letters).length.zero?
    end
    pp selected_words
  end

  def self.wordle_og(word_with_placeholders:, excluded_letters:, placeholder_character:)
    available_letters = ("A".."Z").to_a - excluded_letters
    word_with_placeholders = word_with_placeholders.downcase
    raise "Must have at least 2 known letters" if word_with_placeholders.count(placeholder_character) > 3

    available_letters = available_letters.map(&:downcase)

    words_with_placeholders = [word_with_placeholders]
    # while this array of words has at least one presence of _
    while words_with_placeholders.length > 0
      # loop over each word
      words_with_placeholders.each do |word|
        # skip if the word does not have the placeholder character
        next unless word.include?(placeholder_character)
        # for each word, replace the first instance of the placeholder
        word.chars.each_with_index do |word_letter, index|
          # skip this letter if it is alpha
          next unless word_letter == placeholder_character
          available_letters.each do |available_letter|
            word[index] = available_letter
            if word.include?(placeholder_character)
              words_with_placeholders << word.dup
            elsif DICTIONARY_WORDS.include?(word)
              pp word.upcase
            end
          end # each available letter
          # remove original word from words_with_placeholders array
          words_with_placeholders.delete(word)
        end # each placeholder char
      end # words_with_placeholders
    end # while
  end

  # This is the 2nd fastest method
  def self.wordle_intersection(word_with_placeholders:, excluded_letters:, placeholder_character:, required_letters: nil)
    required_letters = required_letters&.map(&:upcase)
    excluded_letters = excluded_letters.map(&:upcase)
    available_letters = ("A".."Z").to_a - excluded_letters
    word_with_placeholders = word_with_placeholders.upcase
    raise "Must have at least 2 known letters" if word_with_placeholders.count(placeholder_character) > 3 && excluded_letters.length < 10
    built_words = []
    words_with_placeholders = [word_with_placeholders]
    # while this array of words has at least one presence of _
    while words_with_placeholders.length > 0
      # loop over each word
      words_with_placeholders.each do |word|
        # skip if the word does not have the placeholder character
        next unless word.include?(placeholder_character)
        # for each word, replace the first instance of the placeholder
        word.chars.each_with_index do |word_letter, index|
          # skip this letter if it is alpha
          next unless word_letter == placeholder_character
          available_letters.each do |available_letter|
            word[index] = available_letter
            if word.include?(placeholder_character)
              words_with_placeholders << word.dup
            elsif required_letters
              (built_words << word.dup) if required_letters.all? { |l| word.include?(l) }
            else
              built_words << word.dup
            end
          end # each available letter
          # remove original word from words_with_placeholders array
          words_with_placeholders.delete(word)
        end # each placeholder char
      end # words_with_placeholders.each
    end # while

    # return only the words that appear in both the dictionary and the built words
    results = FIVE_CHAR_WORDS & built_words
    puts "#{results.length} words found"
    puts results
    puts "-------"
    puts ""
    puts ""
    puts "FINISHED"
  end

  # This is the most accurate and fastest method
  def self.wordle_with_dictionary(word_with_placeholders:, excluded_letters:, required_letters: nil, placeholder_character: "_")
    required_letters = required_letters&.map(&:upcase)
    available_letters = ("A".."Z").to_a - excluded_letters.map(&:upcase)
    word_with_placeholders = word_with_placeholders.upcase
    raise "Must have at least 2 known letters" if word_with_placeholders.count(placeholder_character) > 3 && excluded_letters.length < 10

    built_words = []
    # available_letters = available_letters.map(&:upcase)
    words_with_placeholders = [word_with_placeholders]
    # while this array of words has at least one presence of _
    while words_with_placeholders.length > 0
      # loop over each word
      words_with_placeholders.each do |word|
        # skip if the word does not have the placeholder character
        next unless word.include?(placeholder_character)

        # for each word, replace the first instance of the placeholder
        word.chars.each_with_index do |word_letter, index|
          # skip this letter if it is alpha
          next unless word_letter == placeholder_character

          available_letters.each do |available_letter|
            word[index] = available_letter
            if word.include?(placeholder_character)
              words_with_placeholders << word.dup
            elsif required_letters
              (built_words << word.dup) if required_letters.all? { |l| word.include?(l) }
            else
              built_words << word.dup
            end
          end # each available letter
          # remove original word from words_with_placeholders array
          words_with_placeholders.delete(word)
        end # each placeholder char
      end # words_with_placeholders.each
    end # while

    # return only the words that appear in both the dictionary and the built words
    results = DICTIONARY_WORDS & built_words
    puts results
    puts "-------"
    puts "#{results.length} words found"
    puts ""
    puts "FINISHED"
  end

  def self.wordle_recursion(word_with_placeholders:, excluded_letters:, placeholder_character:)
    available_letters = ("A".."Z").to_a - excluded_letters
    word_with_placeholders = word_with_placeholders.downcase
    raise "Must have at least 2 known letters" if word_with_placeholders.count(placeholder_character) > 3

    @available_letters = available_letters.map(&:downcase)
    @placeholder_character = placeholder_character
    @generated_words = []

    process_words_with_placeholders([word_with_placeholders])

    proposed_words = @generated_words.uniq.select do |generated_word|
      DICTIONARY_WORDS.include?(generated_word)
    end

    puts proposed_words.any? ? proposed_words.map(&:upcase) : "There are no dictionary entries for this word."
  end

  def self.process_words_with_placeholders(array_of_words)
    array_of_words.each do |word|
      next unless word.include?(@placeholder_character)
      process_word_with_placeholder(word)
    end
  end

  def self.process_word_with_placeholder(word)
    new_placeholder_words = []
    word.chars.each_with_index do |char, char_index|
      next unless char == @placeholder_character
      @available_letters.each do |letter|
        word[char_index] = letter
        if word.include?(@placeholder_character)
          new_placeholder_words << word.dup
        else
          @generated_words << word.dup
        end
      end
      process_words_with_placeholders(new_placeholder_words)
    end
  end
end

# File.foreach(text_file) do |line|
#   File.write(destination_file, line, mode: "a") if line.chomp.length > 3
# end
# puts 'done'

# PuzzleHelper.plus
# PuzzleHelper.spelling_bee(must_contain: 'v', can_contain: %w[c e n a t i])

# word_with_placeholders = 'X__'
# available_letters = %w[A B C]
# placeholder_character = '_'
# word_with_placeholders = '__ALE'
# excluded_letters = 'SCIONTRBUM'.chars
# required_letters = nil
# available_letters = 'QWEYUIADFGJKLZXVBNM'.chars

# start_time = Time.now
# puts start_time
# # PuzzleHelper.wordle(word_with_placeholders: word_with_placeholders, excluded_letters: excluded_letters, placeholder_character: placeholder_character) # 24.057118
# PuzzleHelper.wordle_intersection(word_with_placeholders: word_with_placeholders, excluded_letters: excluded_letters, required_letters: required_letters, placeholder_character: placeholder_character) # 0.004096
# # PuzzleHelper.wordle_recursion(word_with_placeholders: word_with_placeholders, excluded_letters: excluded_letters, placeholder_character: placeholder_character) # 23.707097
# puts (Time.now - start_time)

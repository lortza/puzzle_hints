require_relative "../models/wordle"
require "pry"

RSpec.describe Wordle do
  let(:wordle) do
    Wordle.new(
      word_with_placeholders: word_with_placeholders,
      required_letters: required_letters,
      excluded_letters: excluded_letters,
      print_results: print_results
    )
  end

  describe "#suggest" do
    let(:word_with_placeholders) { "_a__e" }
    let(:required_letters) { "u" }
    let(:excluded_letters) { "qicks" }
    let(:print_results) { nil }
    let(:puzzle_answer) { "MAUVE" }

    it "includes the actual puzzle answer" do
      suggestions = wordle.suggest
      expect(suggestions).to include(puzzle_answer)
    end

    it "only returns suggestions that have 5 letters" do
      suggestions = wordle.suggest
      five_letter_suggestions = suggestions.select { |s| s.length == 5 }
      expect(suggestions.length).to eq(five_letter_suggestions.length)
    end

    it "returns suggestions in uppercase" do
      suggestion = wordle.suggest.first
      expect(suggestion).to eq(suggestion.upcase)
    end

    context "when no excluded_letters are provided" do
      let(:excluded_letters) { "" }
      it "provides suggestions" do
        suggestions = wordle.suggest
        expect(suggestions.any?).to eq(true)
      end
    end

    context "when no required_letters are provided" do
      let(:required_letters) { "" }
      it "provides suggestions" do
        suggestions = wordle.suggest
        expect(suggestions.any?).to eq(true)
      end
    end

    context "when there is only 1 suggestion" do
      let(:word_with_placeholders) { "z_b__" }
      let(:required_letters) { "a" }
      let(:excluded_letters) { "qwplvxs" }

      it "returns an array of suggestions" do
        suggestions = wordle.suggest
        expect(suggestions).to match_array(["ZEBRA"])
      end
    end

    context "when there are multiple suggestions" do
      let(:word_with_placeholders) { "_la__" }
      let(:required_letters) { "gan" }
      let(:excluded_letters) { "or" }
      let(:expected_suggestions) { ["CLANG", "GLAND", "SLANG"] }

      it "returns an array of suggestions" do
        suggestions = wordle.suggest
        expect(suggestions).to match_array(expected_suggestions)
      end
    end

    describe "handling non-alpha characters in the required_letters and excluded_letters" do
      let(:word_with_placeholders) { "s_a_t" }
      let(:puzzle_answer) { "SHAFT" }

      context "when numbers are provided" do
        let(:required_letters) { "h2" }
        let(:excluded_letters) { "l34r" }

        it "gracefully discards numbers" do
          suggestion = wordle.suggest.first
          expect(suggestion).to eq(puzzle_answer)
        end
      end

      context "when symbols are provided" do
        let(:required_letters) { "h~`!@#$%^&*()_+-=" }
        let(:excluded_letters) { "lr{}[]|/:;'<>,.?" }

        it "gracefully discards symbols" do
          suggestion = wordle.suggest.first
          expect(suggestion).to eq(puzzle_answer)
        end
      end

      context "when spaces are provided" do
        let(:required_letters) { "h" }
        let(:excluded_letters) { "lr" }

        it "gracefully discards spaces" do
          suggestion = wordle.suggest.first
          expect(suggestion).to eq(puzzle_answer)
        end
      end
    end

    describe "printing results" do
      context "when print_results is not provided" do
        let(:print_results) { nil }

        it "returns an array of results" do
          expect(wordle.suggest).to be_a(Array)
        end
      end

      context "when print_results is provided" do
        let(:print_results) { true }

        it "prints results to teh screen and returns nil" do
          expect(wordle.suggest).to be_a(NilClass)
        end
      end
    end
  end
end

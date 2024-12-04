require "sinatra"
require "sinatra/multi_route" # from sinatra-contrib gem
require "sinatra/url_for"

if settings.environment == :development
  require "pry"
end

require_relative "models/wordle"
require_relative "models/spelling_bee"
require_relative "models/descrambler"

# Define route handlers below
# get '/' do
#   "Hello World!"
#   erb :index
# end

# get '/wordle' do
#   # Get all posts from database
#   # @posts = Post.all

#   # Render posts index view
#   erb :'wordle/index'
# end

get "/", "/wordle" do
  @letter_1 = params[:letter_1]&.gsub(/[^a-zA-Z]/, "")
  @letter_2 = params[:letter_2]&.gsub(/[^a-zA-Z]/, "")
  @letter_3 = params[:letter_3]&.gsub(/[^a-zA-Z]/, "")
  @letter_4 = params[:letter_4]&.gsub(/[^a-zA-Z]/, "")
  @letter_5 = params[:letter_5]&.gsub(/[^a-zA-Z]/, "")

  incoming_letters_blank = [@letter_1, @letter_2, @letter_3, @letter_4, @letter_5].compact.empty?
  if incoming_letters_blank
    @suggestions = []
  else
    word_w_placeholders = [
      letter_or_placeholder(@letter_1),
      letter_or_placeholder(@letter_2),
      letter_or_placeholder(@letter_3),
      letter_or_placeholder(@letter_4),
      letter_or_placeholder(@letter_5)
    ].join

    @required_letters = params[:required_letters].nil? ? "" : params[:required_letters]
    @excluded_letters = params[:excluded_letters].nil? ? "" : params[:excluded_letters]
    @suggestions = Wordle.new(
      word_with_placeholders: word_w_placeholders,
      required_letters: @required_letters,
      excluded_letters: @excluded_letters
    ).suggest
  end

  erb :wordle
end

get "/spelling_bee" do
  @must_contain = params[:must_contain]&.gsub(/[^a-zA-Z]/, "")
  @can_contain = params[:can_contain]&.gsub(/[^a-zA-Z]/, "")

  @suggestions = if [@must_contain, @can_contain].compact.empty?
    []
  else
    SpellingBee.new(
      must_contain: @must_contain,
      can_contain: @can_contain
    ).suggest
  end

  erb :spelling_bee
end

get "/descrambler" do
  @input = params[:input]&.gsub(/[^a-zA-Z]/, "")

  @suggestions = if @input.nil? || @input.empty?
    []
  else
    Descrambler.new(@input).suggest
  end

  erb :descrambler
end

# post "/posts" do
#   # Get posted form data
#   title = params[:title]
#   body = params[:body]

#   # Create post in database
#   @post = Post.create(title: title, body: body)

#   # Redirect to post page
#   redirect "/posts/#{@post.id}"
# end

def letter_or_placeholder(value)
  (value.nil? || value&.empty?) ? Wordle::PLACEHOLDER_CHARACTER : value
end

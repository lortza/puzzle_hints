require 'sinatra'
require "sinatra/multi_route" # from sinatra-contrib gem
require 'pry'

require_relative 'models/wordle'


# Define route handlers below
# get '/' do
#   "Hello World!"
#   erb :index
# end

get '/wordle' do
  # Get all posts from database
  # @posts = Post.all

  # Render posts index view
  erb :'wordle/index'
end

get '/', '/wordle/suggestions' do
  # placeholder_character = "_"
  @letter_1 = params[:letter_1]
  @letter_2 = params[:letter_2]
  @letter_3 = params[:letter_3]
  @letter_4 = params[:letter_4]
  @letter_5 = params[:letter_5]

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
      required_letters: @required_letters.chars,
      excluded_letters: @excluded_letters.chars,
      placeholder_character: Wordle::PLACEHOLDER_CHARACTER
    ).suggest
    # @suggestions = Wordle.temp_list
  end

  erb :'wordle/suggestions'
end

post '/posts' do
  # Get posted form data
  title = params[:title]
  body = params[:body]

  # Create post in database
  # @post = Post.create(title: title, body: body)

  # Redirect to post page
  # redirect "/posts/#{@post.id}"
end

def letter_or_placeholder(value)
  value.nil? || value&.empty? ? Wordle::PLACEHOLDER_CHARACTER : value
end
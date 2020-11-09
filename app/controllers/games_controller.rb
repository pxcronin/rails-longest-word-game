require 'net/http'
require 'open-uri'

class GamesController < ApplicationController
  def new
    charset = Array('a'..'z')
    @letters = Array.new(10) { charset.sample }.join
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word = open(url).read
    word_json = JSON.parse(word)
    @score = 0
    @letters_hash = Hash[params[:letters].split('').group_by{ |char| char }.map{ |key, val| [key, val.size] }]
    @word_hash = Hash[params[:word].split('').group_by{ |char| char }.map{ |key, val| [key, val.size] }]
    @grid_check = (@word_hash.to_a - @letters_hash.to_a).empty?
    case 
    when word_json['found'] && @grid_check
      @score += params[:word].length * 3
      @message = "Congratulations! #{params[:word]} is an English word and you scored #{@score} points!"
    when word_json['found'] == false
      @message = "Sorry, it looks like #{params[:word]} is not an English word"
    else
      @message = "Sorry, you cannot make #{params[:word]} out of the grid of letters - #{params[:letters]}"
    end
  end
end

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...9).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @answer = params[:answer]
    @grid = params[:letters]
    valid = "Congratulations! #{@answer} is a valid English word!"
    not_english = "Sorry but #{@answer} does not seem to be a valid English word..."
    not_in_grid = "Sorry but #{@answer} can't be build out of #{@grid}"
    if in_the_grid?(@answer, @grid)
      @score = verif_word?(@answer) ? valid : not_english
    else
      @score = not_in_grid
    end
  end

  def verif_word?(wrd)
    response = open("https://wagon-dictionary.herokuapp.com/#{wrd}")
    json = JSON.parse(response.read)
    json['found']
  end

  def in_the_grid?(wrd, grid)
    wrd.chars.all? { |letter| wrd.count(letter) <= grid.count(letter) }
  end
end

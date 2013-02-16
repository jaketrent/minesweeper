require "sinatra"
require "sinatra/json"
require "slim"
require "./lib/minesweeper"

# class CoffeeEngine < Sinatra::Base
  
#   set :views,   File.dirname(__FILE__)    + '/public/coffee'
  
#   get "/coffee/*.js" do
#     puts 'getting coffee'
#     filename = params[:splat].first
#     coffee filename.to_sym
#   end
  
# end

# use CoffeeEngine

set :slim, :pretty => true

get "/" do
  slim :index
end

get "/coffee/*.js" do
  filename = params[:splat].first
  coffee "../public/coffee/#{filename}".to_sym
end

get "/ws/board/:difficulty" do

  difficulties = {
    easy: { height: 5, width: 5, mines: 5 },
    normal: { height: 10, width: 10, mines: 10 },
    hard: { height: 10, width: 10, mines: 30 },
    insane: { height: 10, width: 10, mines: 80 },
  }

  json (Minesweeper.new difficulties[params[:difficulty].to_sym]).find_mines.board
end
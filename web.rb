require "sinatra"
require "sinatra/json"
require "slim"
require "./lib/minesweeper"

set :slim, :pretty => true

get "/" do
  slim :index
end

get "/ws/board/:difficulty" do

  difficulties = {
    easy: { height: 5, width: 5, mines: 5 },
    normal: { height: 10, width: 10, mines: 10 },
    hard: { height: 10, width: 10, mines: 50 },
    insane: { height: 10, width: 10, mines: 80 },
  }

  json (Minesweeper.new difficulties[params[:difficulty].to_sym]).find_mines.board
end
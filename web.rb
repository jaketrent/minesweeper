require "sinatra"
require "sinatra/json"
require "slim"
require "./lib/minesweeper"

set :slim, :pretty => true

get "/" do
  slim :index
end

get "/ws/board/:height/:width/:difficulty" do
  json (Minesweeper.new params[:height], params[:width], params[:difficulty]).find_mines.board
end
require "spec_helper"
require "minesweeper"

describe Minesweeper do
  
  describe "#initialize" do

    let(:difficulty) { { height: 5, width: 6, mines: 5 } }
    let(:ms) { Minesweeper.new difficulty }

    it "has a board" do
      expect(ms).to respond_to :board
    end

    it "creates board of appropriate dimensions" do
      expect(ms.board.count).to eq 5
      expect(ms.board[0].count).to eq 6
    end

    it "has at least one bomb" do
      any_bombs = ms.board.find do |row|
        row.include? "*"
      end
     any_bombs.count.should be > 0
    end

    it "has at leastw one blank" do
      any_blanks = ms.board.find do |row|
        row.include? "."
      end
     any_blanks.count.should be > 0
    end

  end

end
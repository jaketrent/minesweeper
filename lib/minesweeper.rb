
class Minesweeper

  attr_reader :board

  def initialize
    @board = [["*", ".", ".", "."], [".", ".", ".", "."], [".", "*", ".", "."], [".", ".", ".", "."]]
  end

  def print_board
    board.each do |row|
      puts row.join
    end
  end

  def prev_col colIndx
    colIndx > 0 ? colIndx - 1 : -1
  end

  def next_col colIndx
    colIndx < board[0].count - 1 ? colIndx + 1 : -1
  end

  def up_row rowIndx
    rowIndx > 0 ? rowIndx - 1 : -1
  end

  def down_row rowIndx
    rowIndx < board.count - 1 ? rowIndx + 1 : -1
  end

  def bomb? cell
    cell == "*"
  end

  def count_bomb rowIndx, colIndx
    if rowIndx == -1 or colIndx == -1
      0
    else
      if bomb? board[rowIndx][colIndx]
        1
      else
        0
      end
    end
  end

  def find_mines
    board.each_index do |rowIndx|
      board[rowIndx].each_index do |colIndx|
        cell = board[rowIndx][colIndx]
        unless cell == "*"
          num_bombs = 0
          
          # W
          num_bombs += count_bomb rowIndx, prev_col(colIndx)
          # E
          num_bombs += count_bomb rowIndx, next_col(colIndx)
          # N
          num_bombs += count_bomb up_row(rowIndx), colIndx
          # S
          num_bombs += count_bomb down_row(rowIndx), colIndx
          # NW
          num_bombs += count_bomb up_row(rowIndx), prev_col(colIndx)
          # NE
          num_bombs += count_bomb up_row(rowIndx), next_col(colIndx)          
          # SW
          num_bombs += count_bomb down_row(rowIndx), prev_col(colIndx)
          # SE
          num_bombs += count_bomb down_row(rowIndx), next_col(colIndx)
          
          board[rowIndx][colIndx] = num_bombs

        end
      end
    end
  end

end

minesweeper = Minesweeper.new

puts "Inital"
minesweeper.print_board

minesweeper.find_mines

puts "Final"
minesweeper.print_board





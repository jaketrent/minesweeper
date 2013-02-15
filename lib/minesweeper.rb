
class Minesweeper

  attr_accessor :board

  def initialize params
    @board = gen_board params[:height], params[:width], params[:mines]
  end

  def gen_board height, width, mines
    blank_board = Array.new(height) { Array.new(width) }
    board_with_mines = gen_mines blank_board, mines
    complete_board = fill_in_board board_with_mines
    complete_board
  end

  def fill_in_board board
    board.each_index do |row_indx|
      board[row_indx].each_index do |col_indx|
        unless bomb? board[row_indx][col_indx]
          board[row_indx][col_indx] = "."
        end
      end
    end
    board
  end

  def gen_mines board, mines
    height = board.count
    width = board[0].count
    mines.times do
      board[Random.rand(height)][Random.rand(width)] = "*"
    end
    board
  end

  def print_board
    board.each do |row|
      puts row.join
    end
  end

  def prev_col col_indx
    col_indx > 0 ? col_indx - 1 : -1
  end

  def next_col col_indx
    col_indx < board[0].count - 1 ? col_indx + 1 : -1
  end

  def up_row row_indx
    row_indx > 0 ? row_indx - 1 : -1
  end

  def down_row row_indx
    row_indx < board.count - 1 ? row_indx + 1 : -1
  end

  def bomb? cell
    cell == "*"
  end

  def count_bomb row_indx, col_indx
    if row_indx == -1 or col_indx == -1
      0
    else
      if bomb? board[row_indx][col_indx]
        1
      else
        0
      end
    end
  end

  def find_mines
    board.each_index do |row_indx|
      board[row_indx].each_index do |col_indx|
        cell = board[row_indx][col_indx]
        unless cell == "*"
          num_bombs = 0
          
          # W
          num_bombs += count_bomb row_indx, prev_col(col_indx)
          # E
          num_bombs += count_bomb row_indx, next_col(col_indx)
          # N
          num_bombs += count_bomb up_row(row_indx), col_indx
          # S
          num_bombs += count_bomb down_row(row_indx), col_indx
          # NW
          num_bombs += count_bomb up_row(row_indx), prev_col(col_indx)
          # NE
          num_bombs += count_bomb up_row(row_indx), next_col(col_indx)          
          # SW
          num_bombs += count_bomb down_row(row_indx), prev_col(col_indx)
          # SE
          num_bombs += count_bomb down_row(row_indx), next_col(col_indx)
          
          board[row_indx][col_indx] = num_bombs

        end
      end
    end
    self
  end

end

# minesweeper = Minesweeper.new 4, 4, "easy"

# minesweeper.find_mines

# puts "Final"
# minesweeper.print_board





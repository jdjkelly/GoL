require 'set'

class Game 
  def initialize(board, steps)
    @board, @steps = Board.new(board), steps
    self.play
  end

  def play
    1..@steps.times do 
      self.next
    end
    @board.to_s
  end

  def next
    @board.next!
  end
end

class Cell

end

class Board
  def initialize(board)
    @cells = board
  end

  def next!
    votes, next_board = Hash.new(0), Hash.new

    @cells.each do |coords, state|
      find_neighbours(coords).each do |neighbour|
        if state == :on
          votes[coords]++
          next_board[coords] = :dying
        end
      end
    end
  
    votes.each do |coords, on_neighbour_count|
      if on_neighbour_count == 2
        next_board[coords] = :on
      end
    end

    @board = next_board
  end

  def find_neighbours(coords)
    transforms = Array.new [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1,1]]
    transforms.collect do |transform|
      [transform[0] + coords[0], transforms[1] + coords[1]]
    end
  end

  def to_s
    puts @board
  end
end

Game.new(
  {
    [1,1] => :on,
    [2,1] => :on,
    [1,2] => :on,
    [2,2] => :on,
    [0,2] => :dying,
    [2,3] => :dying,
    [1,0] => :dying,
    [3,1] => :dying
  }, 10
)

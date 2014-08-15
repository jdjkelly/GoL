require 'pry'

class Game
  def initialize initial_states, generations
    @generations, @board = generations, Board.new(initial_states)
  end

  def play
    puts @board.to_s
    puts "============================================"
    @generations.times do 
      binding.pry
      @board.tick
      puts @board.to_s
      puts "=============================================" 
    end
  end
end

class Cell
  attr_accessor :next_state 
  attr_accessor :state

  def initialize value
    @position, @state = value[0], value[1]
  end

  def dead?
    @state == 0
  end

  def alive?
    @state == 2
  end

  def dying?
    @state == 1
  end

  def neighbours position=@position
    transforms = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]
    transforms.map do |transform|
      transform[0] += position[0]
      transform[1] += position[1]
      transform
    end 
  end

  def inspect_neighbours cells
    @cells = cells
  
    self.neighbours().each do |neighbour|
      if !cell_exists?(neighbour)
        count = 0
        neighbours(neighbour).each do |other_neighbour|
          if cell_exists?(other_neighbour) && cell_exists?(other_neighbour).alive?
            count += 1 
          end
        end
        if count == 2
          @cells.push Cell.new(neighbour, 2)
        end
      end
    end 

    @cells
  end

  def cell_exists?(position) 
    @cel ls.select do |cell|
      cell.position == position  
    end
  end

  def to_s
    state
  end
end

class Board
  def initialize initial_states
    @cells = initial_states.map do |value| 
      Cell.new(value)
    end 
  end

  def tick    
    @cells.each do |cell|
      next !cell.next_state.nil? 

      if cell.dying?
        cell.next_state = 0
      elsif cell.alive?
        cell.next_state = 1
        @cells = cell.inspect_neighbours(@cells)
      end
    end

    @cells.each do |cell|
      if cell.next_state == 0
        @cells.delete(cell)
      else
        cell.state = cell.next_state
        cell.next_state = nil
      end
    end
  end

  def to_s
    @cells.map do |cell|
      cell.to_s
    end 
  end
end

Game.new( [[[0,1], 2], [[0,2], 1]], 10).play

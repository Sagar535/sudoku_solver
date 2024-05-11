=begin
 board is array of nine arrays
 each of those array represent a row
=end
def sudoku_solver(board)
  solved = false
  loops = (0..8).to_a

  # assign possible values 1 to 9 to each cell that doesn't hold any value

  loops.each do |first_loop|
    loops.each do |second_loop|
      board[first_loop][second_loop] ||= (1..9).to_a
    end
  end

  p board

  loop_count = 0

  until solved

    p "solved: #{solved}"
    loops.each do |first_loop|
      loops.each do |second_loop|
        cell = board[first_loop][second_loop]
        # eliminate from the related rows
        loops.each do |row_loop|
          next if row_loop == second_loop # skip if we are in same cell

          row_cell = board[first_loop][row_loop]
          next if row_cell.integer?

          board[first_loop][row_loop] -= [cell] if row_cell.include?(cell)

          board[first_loop][row_loop] = board[first_loop][row_loop].first if board[first_loop][row_loop].count == 1
        end

        # eliminate from the related columns
        loops.each do |column_loop|
          next if column_loop == first_loop # skip if we are in same cell

          column_cell = board[column_loop][second_loop]
          next if column_cell.integer?

          board[column_loop][second_loop] -= [cell] if column_cell.include?(cell)

          board[column_loop][second_loop] = board[column_loop][second_loop].first if board[column_loop][second_loop].count == 1
        end

        # eliminate from the box
        box = box_finder(first_loop, second_loop)

        box.each do |xy|
          next if xy == [first_loop, second_loop]
          x, y = xy
          box_cell = board[x][y]
          next if box_cell.integer?

          board[x][y] -= [cell] if box_cell.include?(cell)

          board[x][y] = board[x][y].first if board[x][y].count == 1
        end
      end
    end

    loop_count += 1
    solved = loop_count == 100
  end

  p board
end

# TODO: FIXME: Complete it so that we can print the board at last
def board_printer(board)
  loops = (0..8).to_a

  loops.each do |first_loop|
  end
end

# cell will be array of
def box_finder(row, column)
  relative_position = find_relative_position(row, column)

  first_box = [
    [0, 0], [0, 1], [0, 2],
    [1, 0], [1, 1], [1, 2],
    [2, 0], [2, 1], [2, 2]
  ]

  required_box = first_box.map do |cell|
                    row_offset = cell[0] - relative_position[0]
                    column_offset = cell[1] - relative_position[1]
                    [row + row_offset, column + column_offset]
                  end

  required_box
end

# if box was overlapped with first box, what will be the position
def find_relative_position(row, column)
  box_number = find_box_number(row, column)

  if box_number == 1
    return [row, column]
  elsif box_number == 2
    return [row, column - 3]
  elsif box_number == 3
    return [row, column - 6]
  elsif box_number == 4
    return [row - 3, column]
  elsif box_number == 5
    return [row-3, column - 3]
  elsif box_number == 6
    return [row-3, column - 6]
  elsif box_number == 7
    return [row - 6, column]
  elsif box_number == 8
    return [row - 6, column - 3]
  elsif box_number == 9
    return [row-6, column - 6]
  end
end

# find box no
def find_box_number(row, column)
  box = [1, 2, 3] if [0,1,2].include? row
  box = [4, 5, 6] if [3,4,5].include? row
  box = [7, 8, 9] if [6,7,8].include? row

  box = box.intersection [1, 4, 7] if [0, 1, 2].include? column
  box = box.intersection [2, 5, 8] if [3, 4, 5].include? column
  box = box.intersection [3, 6, 9] if [6, 7, 8].include? column

  box.flatten.first
end

class Array
  def integer?
    false
  end
end

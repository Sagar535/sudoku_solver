=begin
 board is array of nine arrays
 each of those array represent a row
=end
def sudoku_solver(board)
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

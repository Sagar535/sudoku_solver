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

    value_changed = false

    p "solved: #{solved}"
    loops.each do |first_loop|
      rows = get_rows(first_loop)
      loops.each do |second_loop|
        columns = get_columns(second_loop)

        #  cell that is currently being checked for selectively trimming the values
        cell = board[first_loop][second_loop]

        rows.each do |row|
          rx, ry = row
          next if ry == second_loop # skip if we are in same cell

          row_cell = board[rx][ry]

          next if row_cell.integer?

          # include? will check for each cell contains the number
          # FIXME: we can run the following only if cell is integer
          if cell.integer? && row_cell.include?(cell)
            board[rx][ry] -= [cell]
            value_changed = true
          end
        end

        columns.each do |column|
          cx, cy = column
          next if cy == first_loop # skip if we are in same cell

          column_cell = board[cx][cy]

          next if column_cell.integer?

          # include? will check for each cell contains the number
          # FIXME: we can run the following only if cell is integer
          if cell.integer? && column_cell.include?(cell)
            board[cx][cy] -= [cell]
            value_changed = true
          end
        end

        # boxes = box_coordinates(first)
        # eliminate from the related rows
        # loops.each do |row_loop|
        #   next if row_loop == second_loop # skip if we are in same cell

        #   row_cell = board[first_loop][row_loop]
        #   next if row_cell.integer?

        #   board[first_loop][row_loop] -= [cell] if row_cell.include?(cell)

        #   if board[first_loop][row_loop].count == 1
        #     board[first_loop][row_loop] = board[first_loop][row_loop].first
        #     value_changed = true
        #   end
        # end

        # eliminate from the related columns
        # loops.each do |column_loop|
        #   next if column_loop == first_loop # skip if we are in same cell

        #   column_cell = board[column_loop][second_loop]
        #   next if column_cell.integer?

        #   board[column_loop][second_loop] -= [cell] if column_cell.include?(cell)

        #   if board[column_loop][second_loop].count == 1
        #     board[column_loop][second_loop] = board[column_loop][second_loop].first
        #     value_changed = true
        #   end
        # end

        # eliminate from the box
        box = box_coordinates(first_loop, second_loop)

        box.each do |xy|
          next if xy == [first_loop, second_loop]
          x, y = xy
          box_cell = board[x][y]
          next if box_cell.integer?

          board[x][y] -= [cell] if box_cell.include?(cell)

          if board[x][y].count == 1
            value_changed = true
            board[x][y] = board[x][y].first
          end
        end
      end
    end

    # run these loops only if there is no change in cell values
    unless value_changed
      # set as that value
      # if only repeated once in row
      loops.each do |first_loop|
        row = board[first_loop]
        value_changed = false

        row.each_with_index do |cell, index|
          value = nil
          next if cell.integer?
          next if value_changed

          row.each do |other_cell|
            next if other_cell == cell
            if other_cell.integer?
              board[first_loop][index] -= [other_cell]
            else
              value = cell - other_cell if value.nil?

              value = value - other_cell
            end
          end

          if value&.size == 1
            p "first_loop: #{first_loop}, index: #{index}"
            value_changed = true
            board[first_loop][index] = value.first
          end
        end
      end

      # # set as that value
      # # if only repeated once in column

      # loops.each do |first_loop|
      #   column = []
      #   loops.each do |second_loop|
      #     column << board[second_loop][first_loop]
      #   end

      #   # p "unique in column #{first_loop}: "
      #   column.each_with_index do |cell, index|
      #     value = nil
      #     next if cell.integer?

      #     column.each do |other_cell|
      #       next if other_cell == cell
      #       next if other_cell.integer?

      #       value = cell - other_cell if value.nil?

      #       value = value - other_cell
      #     end

      #     if value&.size == 1
      #       board[first_loop][index] = value.first
      #     end
      #   end
      # end

      # set as that value
      # if only repeated once in box

      # take each coordinate for each box
      [[0,0], [0, 2], [0, 6], [3, 0], [3, 3], [3, 6], [6, 0], [6, 3], [6, 6]].each do |ij|
        i, j = ij

        # p "i: #{i}, j: #{j}"

        box = box_coordinates(i, j)
        value_changed = false
        box.each do |xy|
          value = nil
          x,y = xy
          # p "x: #{x}, y: #{y}"
          next if value_changed
          next if board[x][y].integer?
          box.each do |ab|
            a, b = ab
            # p "a: #{a}, b: #{b}"
            next if a == x and b == y
            if board[a][b].integer?
              board[x][y] -= [board[a][b]]
            else
              value = board[x][y] - board[a][b] if value.nil?

              value = value - board[a][b]
            end
          end

          if value&.size == 1
            p "x: #{x}, y: #{y}"
            board[x][y] = value.first
            value_changed = true
          end
        end
      end
    end

    p "Loop count: #{loop_count}"
    p "THE BOARD:"
    board_printer(board)


    loop_count += 1
    solved = loop_count == 100
  end
end

# TODO: FIXME: Complete it so that we can print the board at last
def board_printer(board)
  board.each do |row|
    p row
  end
end

# cell will be array of
def box_coordinates(row, column)
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

# row coordinates
def get_rows(row)
  rows = []
  (0..8).to_a.each do |n|
    rows << [row, n]
  end

  rows
end

# column coordinates
def get_columns(column)
  columns = []
  (0..8).to_a.each do |n|
    columns << [n, column]
  end

  columns
end

class Array
  def integer?
    false
  end
end

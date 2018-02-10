

def euclidean_distance(pos1, pos2)
  (((pos1[1].to_f - pos2[1].to_f) ** 2) + ((pos1[0].to_f - pos2[0].to_f) ** 2)) ** 0.5
end


# pos2 = (y1, x1), pos1 = (y2, x2) since we are travelling to pos1
def slope_of_line(pos2, pos1)
  if (pos1[0].to_f - pos2[0].to_f) == 0
    return 0
  end
  (pos1[1].to_f - pos2[1].to_f) / (pos1[0].to_f - pos2[0].to_f)
end


def find_b(slope, pos)
  pos[1].to_f - pos[0].to_f * slope
end


def find_intersection_x(slope, b, cut_y)
  return_value = b
  if slope != 0
    return_value = (cut_y - b) / slope
  end
  return_value
end

def driver
  writeTo = File.open('polycake.out', 'w')

  data = []
  File.open('polycake.in', 'r').each_line {|line| data.push(line.split(' '))}

  # Read how many shapes there are
  data[0] = data[0][0].to_i

  # Our position within the vertex data
  cur_pos = 1

  # Loop to repeat for each shape
  while data[0] > 0 do

    # puts "\nNew shape:\n"

    data[0] = data[0] - 1

    # Number of vertices in current shape and the y-position of the cut
    vertices = data[cur_pos][0].to_i
    cut_y = data[cur_pos][1].to_f

    # puts "\n--A Increasing cur_pos from: " + cur_pos.to_s
    cur_pos = cur_pos + 1

    # Perimeter values
    perm_1 = 0
    perm_2 = 0

    # The x-positions of the cut, to eb determined when we discover intersecting lines
    x1_cut = 0.0
    x2_cut = 0.0


    pos1 = data[cur_pos]          # The next vertex and also the first
    first_vertex = data[cur_pos]  # Storing the first vertex for the end

    # puts "\n--B Increasing cur_pos from: " + cur_pos.to_s
    cur_pos = cur_pos + 1

    # A flag to indicate whether or not we are still within the same shape
    first_shape = true

    inc_flag = false

    # We need to explore every vertex
    while vertices > 0 do
      set_first_shape = false

      vertices = vertices - 1

      # Set the current vertex to be the previous one
      pos2 = pos1

      # In this case we want to use the very first vertex
      if vertices == 0
        pos1 = first_vertex
        # puts "\n--G The last vertex"
      else                       # Otherwise we read in the next vertex
        pos1 = data[cur_pos]

        # puts "\n--C Increasing cur_pos from: " + cur_pos.to_s
        cur_pos = cur_pos + 1
      end

      # If we cross the intersection line
      if (pos1[1].to_f < cut_y and pos2[1].to_f > cut_y) or (pos1[1].to_f > cut_y and pos2[1].to_f < cut_y)

        if vertices == 0
          inc_flag = true
        end

        # Find the slope of the line and the b value
        slope = slope_of_line(pos1, pos2)
        b = find_b(slope, pos1)

        # If we are looking a the first perimeter, then set the first x value for the cut point
        if first_shape
          x1_cut = find_intersection_x(slope, b, cut_y)
          pos1 = [x1_cut, cut_y]
        else
          x2_cut = find_intersection_x(slope, b, cut_y)
          pos1 = [x2_cut, cut_y]
        end

        vertices = vertices + 1

        # puts "\n--F Decreasing cur_pos from: " + cur_pos.to_s
        cur_pos = cur_pos - 1
        set_first_shape = true
      end

      if first_shape
        perm_1 = perm_1 + euclidean_distance(pos1, pos2)
      else
        perm_2 = perm_2 + euclidean_distance(pos1, pos2)
      end

      if set_first_shape
        first_shape = !first_shape
      end

    end

    perm_1 = '%0.3f' % (perm_1 + (x1_cut - x2_cut).abs)
    perm_2 = '%0.3f' % (perm_2 + (x1_cut - x2_cut).abs)

    # puts "\n\nCuts and final:"
    # puts x1_cut
    # puts x2_cut
    # puts perm_1 + ' ' + perm_2 + "\n"

    if perm_1 < perm_2
      writeTo.puts(perm_1 + ' ' + perm_2)
    else
      writeTo.puts(perm_2 + ' ' + perm_1)
    end


    # puts "\n--D Increasing cur_pos from: " + cur_pos.to_s
    # puts inc_flag
    if inc_flag
      cur_pos = cur_pos + 1
    end

  end

end

driver

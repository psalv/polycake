

def euclidean_distance(pos1, pos2)
  (((pos1[2].to_i - pos2[2].to_i) ** 2) + ((pos1[0].to_i - pos2[0].to_i) ** 2)) ** 0.5
end


def slope_of_line(pos1, pos2)
  (pos1[2].to_i - pos2[2].to_i).abs / (pos1[0].to_i - pos2[0].to_i).abs
end


def find_b(slope, pos)
  pos[2].to_i - pos[1].to_i * slope
end


def find_intersection_x(slope, b, cut_y)
  (cut_y - b) / slope
end

def driver
  writeTo = File.open('polycake_small.out', 'w')

  data = []
  File.open('polycake_small.in', 'r').each_line {|line| data.push(line)}

  # Read how many shapes there are
  data[0] = data[0].to_i

  # Our position within the vertex data
  cur_pos = 1

  # Loop to repeat for each shape
  while data[0] > 0 do
    data[0] = data[0] - 1

    # Number of vertices in current shape and the y-position of the cut
    vertices = data[cur_pos][0].to_i
    cut_y = data[cur_pos][2].to_i

    cur_pos = cur_pos + 1

    # Perimeter values
    perm_1 = 0
    perm_2 = 0

    # The x-positions of the cut, to eb determined when we discover intersecting lines
    x1_cut = 0
    x2_cut = 0


    pos1 = data[cur_pos]          # The next vertex and also the first
    first_vertex = data[cur_pos]  # Storing the first vertex for the end
    cur_pos = cur_pos + 1

    # A flag to indicate whether or not we are still within the same shape
    first_shape = true

    # We need to explore every vertex
    while vertices > 0 do
      vertices = vertices - 1

      # Set the current vertex to be the previous one
      pos2 = pos1

      # In this case we want to use the very first vertex
      if vertices == 0
        pos1 = first_vertex
      else                       # Otherwise we read in the next vertex
        pos1 = data[cur_pos]
        cur_pos = cur_pos + 1
      end

      puts pos2
      puts pos1

      if (pos1[2].to_i < cut_y and pos2[2].to_i > cut_y) or (pos1[2].to_i > cut_y and pos2[2].to_i < cut_y)
        first = !first
        puts first
      end

    end




  end



end


driver
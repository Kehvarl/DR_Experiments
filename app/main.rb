class Ground_Generate
  def initialize args
    @ground = generate_ground_lines
    ground_render args
    @x = 0
    @vx = 1
  end

  def generate_ground(width=2560, max_h=180, min_h = 5, max_change=5)
    arr = []
    w = 1
    x = -1
    h = min_h
    counter = 0
    target_y = rand(max_h)
    while x < width
      x += 1
      if (target_y - h).abs <= 1
        counter = rand(100)
      end
      if counter > 0
        counter -=1
        if counter <= 0
          target_y = [rand(max_h), min_h].max
          counter = 0
        end
      end
      if width - x <= [h, 50].max
        target_y = min_h
      end
      if h < target_y
        h += rand(max_change)
      elsif h > target_y
        h -= rand(max_change)
      end
      arr << {x:x, y:0, w:w, h:h, r:64, g:64, b:64}.solid!
      arr << {x:x, y:h, w:w, h:1, r:0, g:255, b:0}.solid!
    end
    arr
  end

  def generate_ground_lines(width=2560, max_h=180, min_h = 5, max_change=50)
    arr = []
    x = 0
    w = 5
    y = min_h
    target_y = min_h
    while x + w < width
      arr << {x:x, y:y, x2:x+w, y2:target_y, r:128, g:128, b:128}.line!
      x += w
      w = [rand(100), (width - x - 25)].min
      y = target_y
      target_y += rand(max_change + max_change) - max_change
      if width - x <= 50
        arr << {x:x, y:y, x2:width, y2:min_h, r:128, g:128, b:128}.line!
        break
      end
    end
    arr
  end

  def ground_render args
    args.outputs[:ground].w = 2560
    args.outputs[:ground].h = 720
    args.outputs[:ground].primitives <<{x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
    args.outputs[:ground].primitives << @ground.map do |g|
      g
    end
  end

  def tick args
    if args.inputs.keyboard.key_down.right
      @vx += 1
    end
    if args.inputs.keyboard.key_down.left
      @vx -= 1
    end
    @x += @vx
    args.outputs.primitives <<{x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
    #args.outputs.primitives << @ground.map do |g|
    #  g[:x] = (g[:x] - @vx) % 2560
    #  g[:x2] = (g[:x2] - @vx) % 2560
    #  g
    #end
    args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720,
                                path: :ground,
                                source_x: @x, source_y: 0,
                                source_w: 1280, source_h: 720}
  end
end


def tick args
  args.state.gt ||= Ground_Generate.new(args)
  args.state.gt.tick(args)
end

class Ground_Generate
  def initialize args
    @ground = generate_ground_lines
    ground_render args
    generate_ship args
    @last = 'generate_ground'
    @next = 'generate_ground_lines'
    @projectiles = []
    @x = 0
    @y = 360
    @vx = 1
    @ship_flipped = false
    @frame = 0
  end

  def generate_ship args
    args.outputs[:ship].w = 256
    args.outputs[:ship].h = 32
    args.outputs[:ship].background_color = [255, 255, 255, 0]
    x = 0
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    x += 64
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x+8, y:  8, x2: x+4, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x+8, y: 24, x2: x+4, y2: 16, r: 128, g: 128, b: 128}.line!
    x += 64
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x+8, y:  8, x2: x+2, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x+8, y: 24, x2: x+2, y2: 16, r: 128, g: 128, b: 128}.line!
    x += 64
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+63, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y:  0, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x, y: 32, x2: x+16, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x+8, y:  8, x2: x, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:ship].primitives << {x: x+8, y: 24, x2: x, y2: 16, r: 128, g: 128, b: 128}.line!
    args.outputs[:mini_ship].w = 12
    args.outputs[:mini_ship].h = 8
    args.outputs[:mini_ship].background_color = [255, 255, 255, 0]
    x = 0
    args.outputs[:mini_ship].primitives << {x: x, y: 0, x2: x+12, y2: 4, r: 128, g: 128, b: 128}.line!
    args.outputs[:mini_ship].primitives << {x: x, y: 8, x2: x+12, y2: 4, r: 128, g: 128, b: 128}.line!
    args.outputs[:mini_ship].primitives << {x: x, y: 0, x2: x+ 4, y2: 4, r: 128, g: 128, b: 128}.line!
    args.outputs[:mini_ship].primitives << {x: x, y: 8, x2: x+ 4, y2: 4, r: 128, g: 128, b: 128}.line!
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
      arr << {x:x, y:h, w:w+3, h:4, r:0, g:255, b:0}.solid!
      arr << {x:x+2560, y:0, w:w, h:h, r:64, g:64, b:64}.solid!
      arr << {x:x+2560, y:h, w:w+3, h:4, r:0, g:255, b:0}.solid!
    end
    arr
  end

  def generate_ground_lines(width=2560, max_h=180, min_h = 5, max_change=50)
    arr = []
    x = -1
    w = 5
    y = min_h
    target_y = min_h
    while x + w <= width
      arr << {x:x, y:y, x2:x+w, y2:target_y, r:128, g:128, b:128}.line!
      x += w
      w = [rand(100), (width - x)].min
      y = target_y
      target_y += rand(max_change + max_change) - max_change
      if target_y < min_h
        target_y = min_h
      end
      if target_y > max_h
        target_y = max_h
      end
      if x <= 1280
        arr << {x:x+2560, y:y, x2:x+2560+w, y2:target_y, r:128, g:128, b:128}.line!
        if 1280 - x <= 100 and x < 1280
          arr << {x:x, y:y, x2:1280, y2:min_h, r:128, g:128, b:128}.line!
          arr << {x:x+2560, y:y, x2:3840, y2:min_h, r:128, g:128, b:128}.line!
          x = 1280
          y = min_h
          target_y = min_h
        end
      end
      if width - x <= 100
        arr << {x:x, y:y, x2:width, y2:min_h, r:128, g:128, b:128}.line!
        arr << {x:x, y:y, x2:width, y2:min_h, r:128, g:128, b:128}.line!
        break
      end
    end
    arr
  end

  def ground_render args
    args.outputs[:ground].w = 5120
    args.outputs[:ground].h = 720
    args.outputs[:ground].primitives << @ground.map { |g| g }
  end

  def tick args
    if args.inputs.keyboard.key_down.tab
      @ground = send(@next)
      ground_render args
      tmp = @last
      @last = @next
      @next = tmp
    end

    if args.inputs.keyboard.down
      @y -= 1
    elsif args.inputs.keyboard.up
      @y += 1
    end
    if args.inputs.keyboard.right
      @vx += 0.1
      @ship_flipped = false
      @frame = (@frame + 1) % 3
    elsif args.inputs.keyboard.left
      @vx -= 0.1
      @ship_flipped = true
      @frame = (@frame + 1) % 3
    else
      @frame = 0
    end
    if args.inputs.keyboard.key_down.space
      if @ship_flipped
        x = 576
        v = -16
      else
        x = 672
        v = 16
      end
      @projectiles << [x, @y, @ship_flipped, v]
    end
    @x = (@x + @vx) % 2560
    args.outputs[:scene].width = 1280
    args.outputs[:scene].height = 720
    args.outputs[:minimap].width = 2560
    args.outputs[:minimap].height = 720
    args.outputs[:scene].primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
    # Ground
    args.outputs[:scene].primitives << {x: 0, y: 0, w: 1280, h: 720,
                                        path: :ground,
                                        source_x: @x, source_y: 0,
                                        source_w: 1280, source_h: 720}.sprite!
    # Ship
    args.outputs[:scene].primitives << {x: 608, y: @y, w: 64, h: 32,
                                        flip_horizontally: @ship_flipped,
                                        path: :ship,
                                        source_x: @frame * 64, source_y: 0,
                                        source_w: 64, source_h: 32}.sprite!

    args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720,
                                path: :scene,
                                source_x: 0, source_y: 0,
                                source_w: 1280, source_h: 720}.sprite!

    args.outputs.primitives << {x: (@x/6 + 510)%2560, y: @y/4 + 539, w: 12, h: 8,
                                          flip_horizontally: @ship_flipped,
                                          path: :mini_ship}.sprite!

    args.outputs.primitives << @ground.map do |g|
      t = g.copy
      if t.x <= 2560
        t.x = t.x/4 + 320
        t.y = t.y/4 + 539
        if t.x2
          t.x2 = t.x2/4 + 320
          t.y2 = t.y2/4 + 539
        else
          t.w = t.w/4
          t.h = t.h/4
        end
        t
      end
    end

    args.outputs.primitives <<{x:319, y:538, w:641, h:181, r:0, g:128, b:0}.border!



    @projectiles.each do |p|
      p[0] += p[3]
      if p[2]
        x2 = p[0]-2
      else
        x2 = p[0]+2
      end
      args.outputs.primitives << {x:p[0], y:p[1]+15, w:40, h:2, r:128, g:255, b:255}.solid!
      args.outputs.primitives << {x:x2, y:p[1]+14, w:36, h:4, r:0, g:255, b:0}.solid!
    end
    @projectiles = @projectiles.select { |p|  p[0] >0 and p[0] < 1280}
  end
end


def tick args
  args.state.gt ||= Ground_Generate.new(args)
  args.state.gt.tick(args)
end

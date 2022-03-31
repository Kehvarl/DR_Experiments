class Projectile
  attr_accessor :x, :y, :w, :h, :r, :g, :b, :a, :v, :blendmode_enum

  def initialize opts
    super
    @x = opts[:x] || 0
    @y = opts[:y] || 0
    @w = opts[:w] || 40
    @h = opts[:h] || 4
    @r = opts[:r] || 0
    @g = opts[:g] || 255
    @b = opts[:b] || 0
    @a = opts[:a] || 255
    @v = opts[:v] || 0
  end

  def tick args
    @x += @v
  end

  def primitive_marker
    :solid
  end
end

class Enemy
  attr_accessor :x, :y, :w, :h, :r, :g, :b, :a, :v, :blendmode_enum

  def initialize opts
    super
    @x  = opts[:x]  ||   0
    @y  = opts[:y]  ||   0
    @w  = opts[:w]  ||  16
    @h  = opts[:h]  ||  16
    @r  = opts[:r]  ||   0
    @g  = opts[:g]  || 128
    @b  = opts[:b]  || 128
    @a  = opts[:a]  || 255
    @vx = opts[:vx] ||   0
    @vy = opts[:vy] ||   0
  end

  def tick args
    @x += @vx
    @y += @vy
  end

  def primitive_marker
    :solid
  end
end

class Scene
  attr_accessor :w, :h, :background, :entities
  def initialize opts
    super
    @w  = opts[:w]  ||  2560
    @h  = opts[:h]  ||  720
  end

  def render
    arr = []

    arr
  end
end

class Defender
  def initialize args
    @ground = generate_ground_lines
    ground_render args
    @last = 'generate_ground'
    @next = 'generate_ground_lines'
    @projectiles = []
    @enemies = []
    @x = 0
    @y = 360
    @vx = 1
    @ship_flipped = false
    @frame = 0
    @enemies << Enemy.new(x: rand(max=2560), y: rand(max=540))
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
    args.outputs[:ground].h = 640
    args.outputs[:ground].primitives << @ground.map { |g| g }

    args.outputs[:minimap].width = 640
    args.outputs[:minimap].height = 160
    args.outputs[:minimap].primitives << @ground.map do |g|
      t = g.copy
      if t.x <= 2560
        t.x = t.x/4
        t.y = t.y/4
        if t.x2
          t.x2 = t.x2/4
          t.y2 = t.y2/4
        else
          t.w = t.w/4
          t.h = t.h/4
        end
        t
      end
    end
  end

  def handle_keys args
    if args.inputs.keyboard.key_down.one
      @enemies << Enemy.new(x: rand(max=2560), y: rand(max=540))
    end
    if args.inputs.keyboard.key_down.tab
      @ground = send(@next)
      ground_render args
      tmp = @last
      @last = @next
      @next = tmp
    end

    if args.inputs.keyboard.down
      @y -= 2
      if @y < 0
        @y = 0
      end
    elsif args.inputs.keyboard.up
      @y += 2
      if @y > 526
        @y = 526
      end
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
        v = -14
      else
        x = 672
        v = 14
      end
      @projectiles << Projectile.new(x: x, y: @y + 14, v: v)
    end
  end

  def render_scene args
    args.outputs[:scene].width = 1280
    args.outputs[:scene].height = 720
    args.outputs[:scene].primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
    # Ground
    args.outputs[:scene].primitives << {x: 0, y: 0, w: 1280, h: 720,
                                        path: :ground,
                                        source_x: @x, source_y: 0,
                                        source_w: 1280, source_h: 720}.sprite!
    # Ship
    args.outputs[:scene].primitives << {x: 608, y: @y, w: 64, h: 32,
                                        flip_horizontally: @ship_flipped,
                                        path: 'sprites/sheet.png',
                                        source_x: @frame * 64, source_y: 0,
                                        source_w: 64, source_h: 32}.sprite!
    @enemies.each do |e|
      if e.x>= @x and e.x<= (@x + 1280)
        t = e.clone
        #t.x -= @x
        #t.x = t.x
        args.outputs[:scene].primitives << t
      end
    end
    args.outputs[:scene].primitives << {x: 0, y: 700, w: 64, h: 32, text: @x, r: 255}.label!
  end

  def render args
    # Draw Scene
    args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720,
                                path: :scene,
                                source_x: 0, source_y: 0,
                                source_w: 1280, source_h: 720}.sprite!

    # Draw Minimap
    # Minimap Ship
    args.outputs.primitives << {x: ((@x + 608)%2496)/4 + 320, y: @y/4 + 560, w: 12, h: 8,
                                flip_horizontally: @ship_flipped,
                                path: 'sprites/mini_ship.png'}.sprite!

    # Minimap
    args.outputs.primitives << {x: 320, y: 560, w: 640, h: 160,
                                path: :minimap}.sprite!
    # Minimap Border
    args.outputs.primitives <<{x:319, y:559, w:641, h:161, r:0, g:128, b:0}.border!

  end

  def tick args
    handle_keys args
    @x = (@x + @vx) % 2560
    render_scene args
    render args

    @projectiles.each { |p| p.tick args }
    @enemies.each { |e| e.tick args }
    @projectiles = @projectiles.select { |p|  p.x >0 and p.x < 1280}

    args.outputs.primitives << @projectiles.map { |p| p }

  end
end

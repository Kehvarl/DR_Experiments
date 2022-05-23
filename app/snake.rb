class Entity
  attr_accessor :x, :y, :vx, :vy

  def initialize x, y, vx, vy
    super
    @x = x
    @y = y
    @vx = vx
    @vy = vy
  end
end


class Snake
  attr_accessor :x, :y, :vx, :vy
  def initialize args
    super
    game_reset args
  end

  def game_reset args
    @w = 160
    @h = 90
    @x = 60
    @y = 45
    @s = 8
    @vx = 0
    @vy = 0
    @tiles = Array.new(@h){Array.new(@w, 0)}
    @foods = [[rand(@w), rand(@h)]]
    @enemies = []
    @enemies << new_enemy
    @snake = Array.new()
    @length = 5

    for x in 0..(@w-1)
      if x < @w/2-4 or x > @w/2+4
        @tiles[0][x] = 255
        @tiles[@h-1][x] = 255
      end
    end
    for y in 0..(@h-1)
      if y < @h/2-1 or y > @h/2+4
        @tiles[y][0] = 255
        @tiles[y][@w-1] = 255
      end
    end
    args.state.game = :running
  end

  def new_enemy
    {x: rand(@w), y: rand(@h), v: [[-1,0],[1,0],[0,-1],[0,1]].sample}
  end

  def handle_keys args
    if args.inputs.keyboard.down
      @vx = 0
      @vy = -1
    elsif args.inputs.keyboard.up
      @vx = 0
      @vy = 1
    end

    if args.inputs.keyboard.right
      @vx = 1
      @vy = 0
    elsif args.inputs.keyboard.left
      @vx = -1
      @vy = 0
    end
  end

  def render_screen args
    for y in 0..(@h-1)
      for x in 0..(@w-1)
        args.outputs.solids << {x: (x*@s).to_i, y: (y*@s).to_i, w: @s, h: @s, r:@tiles[y][x], g:0, b:0}
      end
    end
    @foods.each do |c|
      args.outputs.sprites << {x: (c[0]*@s).to_i, y: (c[1]*@s).to_i, w: @s, h: @s, path:"sprites/circle/blue.png"}
    end

    @enemies.each do |c|
      args.outputs.sprites << {x: (c.x*@s).to_i, y: (c.y*@s).to_i, w: @s, h: @s, path:"sprites/circle/red.png"}
    end

    @snake.each do |c|
      args.outputs.sprites << {x: (c[0]*@s).to_i, y: (c[1]*@s).to_i, w: @s, h: @s, path:"sprites/circle/green.png"}
    end
    c = @snake[-1]
    args.outputs.sprites << {x: (c[0]*@s).to_i, y: (c[1]*@s).to_i, w: @s, h: @s, path:"sprites/hexagon/green.png"}
  end

  def update_enemies
    e2 = []
    for c in @enemies
      x = c.x
      y = c.y
      vx = c.v[0]
      vy = c.v[1]

      if x <= 0
        x = @w-1
      elsif x >= @w
        x = 0
      end
      if y <= 0
        y = @h-1
      elsif y >= @h
        y = 0
      end

      if @tiles[y][x+vx] > 0
        vx = -vx
      end
      if @tiles[y+vy][x] > 0
        vy = -vy
      end

      x += vx
      y += vy
      e2 << {x:x, y:y, v:[vx, vy]}
    end
    @enemies = e2
  end

  def game_tick args
    handle_keys args
    if @vx == 0 and @vy == 0
      return
    end
    update_enemies
    @x += @vx
    @y += @vy
    if @x <= 0
      @x = @w-1
    elsif @x >= @w
      @x = 0
    end
    if @y <= 0
      @y = @h-1
    elsif @y >= @h
      @y = 0
    end
    if @foods.include?([@x,@y])
      @length += 1
      @foods.delete([@x,@y])
      @foods << [rand(@w), rand(@h)] # Need to check for edges
    end

    if @tiles[@y][@x] > 0 or
        @snake.select { |s| s[0]==@x and s[1]==@y }.length > 0 or
        @enemies.select{|e| e.x==@x and e.y==@y }.length > 0
      args.state.game = :game_over
      return
    end

    while @snake.length+1 > @length
      @snake.shift()
    end
    @snake << [@x, @y]

    render_screen args
  end

  def game_over_tick args
    render_screen args
    w, h = args.gtk.calcstringbox("Press Space To Start.",0)

    args.outputs.borders << {x: 560, y: 300, w: w+20, h: 2*h+25, r:0, g:192, b:128}
    args.outputs.solids << {x: 560, y: 300, w: w+20, h: 2*h+25, r:128, g:128, b:128}
    args.outputs.labels << {x: 570, y: 355, text: "Game Over"}
    args.outputs.labels << {x: 570, y: 335, text: "Press Space To Start."}

    if args.inputs.keyboard.space
      game_reset args
    end
  end

  def tick args
    case args.state.game
    when :running
      game_tick args
    when :game_over
      game_over_tick args
    end
  end
end

# TODO: Refactor
# TODO: Enemy collision detection broken
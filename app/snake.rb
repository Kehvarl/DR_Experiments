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
    @snake = Array.new()
    @length = 5

    for x in 0..(@w-1)
      @tiles[0][x] = 255
      @tiles[@h-1][x] = 255
    end
    for y in 0..(@h-1)
      @tiles[y][0] = 255
      @tiles[y][@w-1] = 255
    end
    args.state.game = :running
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
    for c in @snake
      args.outputs.solids << {x: (c[0]*@s).to_i, y: (c[1]*@s).to_i, w: @s, h: @s, r:0, g:128, b:128}
    end
    c = @snake[-1]
    args.outputs.solids << {x: (c[0]*@s).to_i, y: (c[1]*@s).to_i, w: @s, h: @s, r:0, g:192, b:255}
  end

  def game_tick args
    handle_keys args
    @x += @vx
    @y += @vy
    if rand(32) > 20
      @length += 1
    end
    while @snake.length+1 > @length
      @snake.shift()
    end
    if @vx == 0 and @vy == 0
      return
    end

    if @tiles[@y][@x] > 0 or @snake.select { |s| s[0]==@x and s[1]==@y }.length > 0
      args.state.game = :game_over
      return
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

# need random foodstuffs
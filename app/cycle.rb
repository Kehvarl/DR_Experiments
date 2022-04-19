class Cycle
  attr_accessor :x, :y, :vx, :vy
  def initialize args
    super
    game_reset args
  end

  def game_reset args
    @x = 60
    @y = 45
    @vx = 0
    @vy = 0
    @x2 = 80
    @y2 = 45
    @vx2 = 0
    @vy2 = 0
    @tiles = Array.new(90){Array.new(160, 0)}
    for x in 0..159
      @tiles[0][x] = 255
      @tiles[89][x] = 255
    end
    for y in 0..89
      @tiles[y][0] = 255
      @tiles[y][159] = 255
    end
    args.state.game = :running
  end

  def render
    arr = []
    arr
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

  def handle_ai args
    if @vx2 == 0 and @vy2 == 0
      case rand(max=4)
      when 0
        @vx2 = 1
      when 1
        @vx2 = -1
      when 2
        @vy2 = 1
      when 3
        @vy2 = -1
      end
    else
      if @tiles[@y2 + @vy2][@x2 + @vx2] > 0
        if @vx2 != 0
          @vx2 = 0
          @vy2 = [-1,1].sample
        else
          @vx2 = [-1,1].sample
          @vy2 = 0
        end
      end
    end
  end

  def game_tick args
    @tiles[@y][@x] = 64
    @tiles[@y2][@x2] = 128
    handle_keys args
    @x += @vx
    @y += @vy
    if @vx == 0 and @vy == 0
      return
    end
    handle_ai args
    @x2 += @vx2
    @y2 += @vy2
    if @tiles[y][x] > 0
      args.state.game = :game_over
      return
    end
    for y in 0..89
      for x in 0..159
        args.outputs.solids << {x: x*8, y: y*8, w: 8, h: 8, r:@tiles[y][x], g:0, b:0}
      end
    end
    args.outputs.solids << {x: @x*8, y: @y*8, w: 8, h: 8, r:128, g:0, b:128}
    args.outputs.solids << {x: @x2*8, y: @y2*8, w: 8, h: 8, r:0, g:128, b:128}
  end

  def game_over_tick args
    for y in 0..89
      for x in 0..159
        args.outputs.solids << {x: x*8, y: y*8, w: 8, h: 8, r:@tiles[y][x], g:0, b:0}
      end
    end
    args.outputs.solids << {x: @x*8, y: @y*8, w: 8, h: 8, r:128, g:0, b:128}
    args.outputs.borders << {x: 560, y: 300, w: 300, h: 100, r:0, g:192, b:128}
    args.outputs.solids << {x: 560, y: 300, w: 300, h: 100, r:128, g:128, b:128}
    args.outputs.labels << {x: 600, y: 360, text: "Game Over"}
    args.outputs.labels << {x: 600, y: 340, text: "Press Space To Start."}

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
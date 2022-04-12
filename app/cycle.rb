class Cycle
  attr_accessor :x, :y, :vx, :vy
  def initialize args
    super
    @x = 640
    @y = 480
    @vx = 0
    @vy = 0
    @tiles = Array.new(120){Array.new(160, 0)}
    @tiles[rand(120)][rand(160)] = rand(128)+128
    @tiles[rand(120)][rand(160)] = rand(128)+128
    @tiles[rand(120)][rand(160)] = rand(128)+128
    @tiles[rand(120)][rand(160)] = rand(128)+128
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

  def tick args
    handle_keys args
    @x += @vx
    @y += @vy
    args.outputs.solids << {x: @x, y: @y, w: 24, h: 32, r:128, g:0, b:128}
    for y in 0..119
      for x in 0..159
        args.outputs.solids << {x: x*8, y: y*8, w: 8, h: 8, r:@tiles[y][x], g:0, b:0}
      end
    end
  end
end

class Cycle
  attr_accessor :x, :y, :vx, :vy
  def initialize args
    super
    @x = 640
    @y = 480
    @vx = 0
    @vy = 0
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
  end
end

# Defender Project rewrite.
# Scene Object
# # Ground
# # Enemies
# # Projectiles
# # Camera Position

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

require 'cairo'
require 'pango'

#require_relative '../lib/pseudo_vasp/two_d_view.rb'
def hsv_to_rgb(h,s,v)
  hsv_to_rgb4(h,s,v)
end

def hsv_to_rgb_full h, s, v
  s /= 100.0
  v /= 100.0
  c = v * s
  x = c * (1 - ((h / 60.0) % 2 - 1).abs)
  m = v - c
  r, g, b = case
            when h < 60  then [c, x, 0]
            when h < 120 then [x, c, 0]
            when h < 180 then [0, c, x]
            when h < 240 then [0, x, c]
            when h < 300 then [x, 0, c]
            else              [c, 0, x]
            end
#  [r, g, b].map{|channel| ((channel + m) * 255).ceil }
    [r, g, b].map { |channel| ((channel + m)) }
end

def hsv_to_rgb2(h, s, v)
  s /= 100.0
  v /= 100.0
  c = v * s
  x = (h % 180.0) / 180.0
  m = v - c
  r, g, b = if h < 180 then [1 - x, x, 0]
            else [0 , 1 - x, x]
            end
  [r, g, b].map { |channel| ((channel + m)) }
end

def hsv_to_rgb4(h, s, v)
  s /= 100.0
  v /= 100.0
  c = v * s
  x = (h % 90.0) / 90.0
  m = v - c

  r, g, b = if h < 90 then [1, x, 0]
            elsif h < 180 then [1 - x, 1, 0]
            elsif h < 270 then [0 , 1, x]
            else [0 ,1 - x ,1 ]
            end
  [r, g, b].map { |channel| ((channel + m)) }
end

def draw_line(x_i, y_i, x_f, y_f)
  x_offset = 20
  $context.move_to(x_offset+x_i,y_i)
  $context.line_to(x_offset+x_f,y_f)
  $context.stroke
end

surface = Cairo::SVGSurface.new('view_2.svg', 380, 100)
$context = Cairo::Context.new(surface)
$context.set_line_width(1)
n = 360 #360
dd = 360/n
x0 = 20-dd
x1 = dd*2
n.times do |i|
  input = [dd*i,100,100]
  output = hsv_to_rgb(*input)
  $context.set_source_rgb(*output)
  x0 += dd
  y0,y1 = 0, 50
  $context.rectangle(x0, y0, x1, y1)
  $context.fill
end
$context.set_source_rgb([0,0,0])
$context.fill


draw_line(0,70,360,70)
draw_line(0,65,0,70)
draw_line(360,65,360,70)
rot_dev = 12
(rot_dev+1).times do |dx|
  p mark = (dx)*360/rot_dev
  draw_line(mark,65,mark,70)
  #  p hsv_to_rgb2(mark, 100, 100)
  p hsv_to_rgb(mark, 100, 100)

  p hsv_to_rgb_full(mark/360.0*240, 100, 100)
end
p hsv_to_rgb2(359,100,100)
surface.finish
system "open -a safari view_2.svg"

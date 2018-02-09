require 'cairo'
require_relative '../lib/pseudo_vasp/two_d_view.rb'

def hsv_to_rgb(h, s, v)
  s /= 100.0
  v /= 100.0
    c = v * s
  #x = c * (1 - ((h / 60.0) % 2 - 1).abs)                                      
  x = (h % 180.0) / 180.0
  m = v - c
  r, g, b = if h < 180 then [1 - x, x, h / 360.0]
            else [0 ,1 - x ,h / 360.0]
            end
  [r, g, b].map { |channel| ((channel + m)) }
end

surface = Cairo::SVGSurface.new('view_3.svg', 360, 100)
context = Cairo::Context.new(surface)
context.set_line_width(1)
n = 360
dd = 360/n
x0 = 0
#parameter = -5..5(10)
n.times do |i|
  input = [dd*i,100,100]
  output = hsv_to_rgb(*input)
  context.set_source_rgb(*output)
  x0 += dd
  y0,y1 = 0, 50
  x1 = x0 + 10
  context.rectangle(x0, y0, x1, y1)
  context.fill
end

context.fill
surface.finish
system "open -a safari view_3.svg"

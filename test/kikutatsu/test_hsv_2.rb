require 'cairo'
#require_relative '../lib/pseudo_vasp/two_d_view.rb'

def hsv_to_rgb(h, s, v)
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

surface = Cairo::SVGSurface.new('view_2.svg', 360, 100)
context = Cairo::Context.new(surface)
context.set_line_width(1)
n = 360
dd = 360/n
x0 = 0
x1 = 2
n.times do |i|
  input = [dd*i,100,100]
  output = hsv_to_rgb(*input)
  context.set_source_rgb(*output)
  x0 += dd
  y0,y1 = 0, 50
  context.rectangle(x0, y0, x1, y1)
  context.fill
end

context.fill
surface.finish
system "open -a safari view_2.svg"

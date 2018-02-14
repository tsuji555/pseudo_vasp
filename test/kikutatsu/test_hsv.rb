# -*- coding: utf-8 -*-
require 'cairo'

def hsv_to_rgb(h, s, v)
  s /= 100.0
  v /= 100.0
  c = v * s
  x = (h % 60.0) / 60.0
  m = v - c
  r, g, b = if h < 60 then [1, 1 - x / 2, 0]
            elsif h < 120 then [1, (1 - x) / 2, 0]
            elsif h < 180 then [1 - x, x, 0]
            elsif h < 240 then [0 ,1 - x, x]
            elsif h < 300 then [x ,0 ,1]
            else [1 - x ,0 ,1 - x]
            end
  [r, g, b].map { |channel| ((channel + m)) }
end

surface = Cairo::SVGSurface.new('view2.svg', 360, 100)
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
system "open -a safari view2.svg"

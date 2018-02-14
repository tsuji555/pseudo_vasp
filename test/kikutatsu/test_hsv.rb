# -*- coding: utf-8 -*-
require 'cairo'
require_relative '../../lib/pseudo_vasp/two_d_view.rb'

# http://c4se.hatenablog.com/entry/2013/08/04/190937 by Sacchan
# h = 0..360, s = 0..100, v = 0..100
# return r,g,b=0..255
def hsv_to_rgb(h, s, v)
  s /= 100.0
  v /= 100.0
  c = v * s
  #x = c * (1 - ((h / 60.0) % 2 - 1).abs)
  x = (h % 60.0) / 60.0
  m = v - c
  #r, g, b = if h < 60 then [c, x, 0]
   #         elsif h < 120 then [x, c, 0]
    #        elsif h < 180 then [0, c, x]
     #       elsif h < 240 then [0, x, c]
      #      elsif h < 300 then [x, 0, c]
       #     else [c, 0, x]
  #    end
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
#context.set_source_rgb(0,1,0)
#context.rectangle(0,0,200,100)
#context.fill
#surface.finish
#system "open -a safari view2.svg"
#exit
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
system "open -a safari view2.svg"

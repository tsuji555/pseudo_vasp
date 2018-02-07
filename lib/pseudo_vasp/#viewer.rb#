require 'cairo'

class Viewer
  attr_accessor :scale,:align,:width,:height,:cx,:cy
  attr_accessor :x_lat,:y_lat
  def initialize(pos)
    @pos = pos
    @w_scale = 1
    @width,@height = 300*@w_scale,200*@w_scale
    set_center
    @surface = Cairo::SVGSurface.new('view.svg', @width, @height)
    @context = Cairo::Context.new(@surface)
    @context.set_line_width(1)
    @x_lat=11.1569
    @y_lat=6.34918
  end

  def set_center
    @cx,@cy = @width/2.0,@height*2/3
    @align = 10
    @scale = 100 # draw axes
    @adjust = @scale
  end

  def draw
    draw_backcolor
    draw_center
    draw_axes
#    draw_atoms
#    draw_cell([[1,0],[1,1],[0,1],[0,0]])
  end

  def finish
    @surface.finish
  end

  def draw_backcolor
    @context.set_source_rgb(0.8, 0.8, 0.8)
    @context.rectangle(0, 0, @width, @height)
    @context.fill
  end

  def draw_cell(rect,color=[1,1,1])
    @context.set_source_rgb(*color)
    ini=[0,0]
    rect.each{|fin|
      @context.move_to(*calc_xy(*ini))
      @context.line_to(*calc_xy(*fin))
      @context.stroke
      ini = fin
    }
  end

  def draw_center
    @context.set_source_rgb(0,0,0)
    @context.circle(*calc_xy(0,0),2)
    @context.fill
  end

  def calc_xy(x,y,z=0)
    return @align+@cx+@scale*x,@align+@cy-@scale*y
  end

  def draw_axes
    @context.set_source_rgb(0,0,0)
    [[[-1,0],[1,0]],[[0,-0.2],[0,1]]].each{|line|
      @context.move_to(*calc_xy(*line[0]))
      @context.line_to(*calc_xy(*line[1]))
      @context.stroke
    }
  end

  def draw_atoms
    @context.set_source_rgb(1,0,0)
    @pos.each{|pos|
      if pos[2]>0.1
        @context.circle(*calc_xy(*pos),2)
        @context.fill
      else
        @context.circle(*calc_xy(*pos),2*1.5)
        @context.stroke
      end
    }
  end

  def dist(pos_i,pos_j)
    dist=0.0
    3.times{|i|
      tmp=pos_i[i]-pos_j[i]
      dist += tmp*tmp
    }
    return Math.sqrt(dist)
  end

  def draw_gb_line
    [-2,-1,0,1,2,3,4].each{|gb|
      @context.set_source_rgba(0,0,1,0.5)
      i_p=[gb*x_lat/2.0,-y_lat,0.0]
      @context.move_to(*calc_xy(*i_p))
      f_p=[gb*x_lat/2.0,2.0*y_lat,0.0]
      @context.line_to(*calc_xy(*f_p))
      @context.set_line_width(4)
      @context.stroke
      @context.set_line_width(1)
    }
  end

  def ext_width=(ext_width)
    @ext_width = ext_width
    @ext_list=[]
    (2*@ext_width+1).times{|i| @ext_list << i-@ext_width}
  end

  def draw_extend_atoms(ext_width=1)
    self.ext_width=ext_width
    @extend_a=[]
    @pos.each{|pos|
      @ext_list.each{|xx|
        @ext_list.each{|yy|
          pos_tmp=Array.new(3,0.0)
          pos_tmp[0]=pos[0]+xx * x_lat
          pos_tmp[1]=pos[1]+yy * y_lat
          pos_tmp[2]=pos[2]
          @extend_a << pos_tmp
          if pos[2]>0.1
            @context.circle(*calc_xy(*pos_tmp),2)
            @context.fill
          else
            @context.circle(*calc_xy(*pos_tmp),2*1.5)
            @context.stroke
          end
        }
      }
    }
  end

  def select_layer(layer)
    @layer=layer
  end



end


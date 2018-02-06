require '../lib/pseudo_vasp/eam'
require 'scanf'

GOLD = 1.618034
TINY = 1.0e-20
GLIMIT = 100.0

def val_set(ax, bx, cx, fa, fb, fc, head='')
  cont = sprintf("#{head}_x:=[%7.4f, %7.4f, %7.4f];",ax,bx,cx)
  cont << sprintf("#{head}_y:=[%7.4f, %7.4f, %7.4f];\n",fa,fb,fc)
  cont
end

def swap_x_f(ax, bx, fa, fb)
  dumx, dumf = ax, fa
  ax, fa = bx, fb
  bx, fb = dumx, dumf
  [ax, bx, fa, fb]
end

def fmax(a,b)
  a > b ? a : b
end

def sign(a,b)
  b >= 0.0 ? a.abs : -a.abs
end

def func_0(ax)
  $n_calc+=1
  res =  1.0*(ax-1.0)*(ax-1.0)
  puts ax.to_s+":"+res.to_s
  res
end

def func_x(ax,ay=1.0)
  $n_calc+=1
  $model.set_cell_size(ax,ay)
  $model.total_energy+150.45633275921924
end

def func_y(ay, ax=1.0) # note the order of ax, ay
  $n_calc+=1
  $model.set_cell_size(ax,ay)
  $model.total_energy+150.45633275921924
end

# mnbrak, coding from Num Recipe in C
def mnbrak(ax, bx, method_func=method(:func_x))
  printf("init range:%10.5f-%10.5f\n",ax,bx)
  $n_calc = 0

  fa = method_func.call(ax)
  fb = method_func.call(bx)
  if fa<fb
    ax, bx, fa, fb = swap_x_f(ax, bx, fa, fb)
  end
  cx = bx + GOLD*(bx-ax)
  fc = method_func.call(cx)
  print val_set(ax, bx, cx, fa, fb, fc, ' init')

  while (fb > fc) do
    r = (bx-ax)*(fb-fc)
    q = (bx- cx)*(fb-fa)
    u = bx - ((bx-cx)*q-(bx-ax)*r)/
      (2.0*sign(fmax( (q-r).abs, TINY),q-r))
    ulim = bx + GLIMIT*(cx-bx)

    if ((bx-u)*(u-cx) > 0.0)
      fu = method_func.call(u)
      if (fu < fc)
        ax=bx
        bx=u
        fa=fb
        fb=fu
        break
      elsif (fu > fb)
        cx=u
        fc=fu
        break
      end
      u = cx + GOLD*(cx-bx)
      fu= method_func.call(u)
    elsif ((cx-u)*(u-ulim)>0.0)
      fu = method_func.call(u)
      if (fu<fc)
        bx = cx
        cx = u
        u = cx+GOLD*(cx-bx)
        fb = fc
        fc = fu
        fu = method_func.call(u)
      end
    elsif ((u-ulim)*(ulim-cx) > 0.0)
      u =ulim
      fu =method_func.call(u)
    else
      u = cx + GOLD*(cx-bx)
      fu =method_func.call(u)
    end
    ax=bx
    bx=cx
    cx=u
    fa=fb
    fb=fc
    fc=fu
  end
  print final = val_set(ax, bx, cx, fa, fb, fc,'final')
  printf("n_calc:%4d\n\n",$n_calc)
  return [[ax, fa], [bx, fb], [cx, fc]]
end

if $0 == __FILE__
  file = './POSCAR_0_3315_46_Al'
#  file = './POSCAR_0_3315_46_inner_relax_-4_1'
  $model = EAM.new(file)
  x_min =  mnbrak(1.0, 1.02, method(:func_x) )
  final = "<"
  x_min.each do |val_pair|
    final << sprintf("<%10.5f|%10.5f|%10.5f>,", (val_pair[0]-1.0)*100,0,val_pair[1])
  end
  y_min =  mnbrak(1.0, 1.02, method(:func_y) )
  y_min.each do |val_pair|
    final << sprintf("<%10.5f|%10.5f|%10.5f>,", 0, (val_pair[0]-1.0)*100,val_pair[1])
  end

=begin
  print final+"\n"
  print "indicate additional calc point [x,y]:"
  line = gets
  x,y=line.chomp.split(',')
  $model.set_cell_size(x.to_f/100.0+1.0,y.to_f/100.0+1.0)
  z = $model.total_energy+150.45633275921924
  final << sprintf("<%10.5f|%10.5f|%10.5f>,", x, y,z)

    print "indicate additional calc point [x,y]:"
  line = gets
  x,y=line.chomp.split(',')
  $model.set_cell_size(x.to_f/100.0+1.0,y.to_f/100.0+1.0)
  z = $model.total_energy+150.45633275921924
  final << sprintf("<%10.5f|%10.5f|%10.5f>,", x, y,z)

  print "\n\n"+final+"\n"
=end
  x0, y0 = x_min[0][0], y_min[0][0]
  x1, y1 = x_min[2][0], y_min[2][0]
  [[x0,y0],[x0,y1],[x1,y0],[x1,y1]].each do |vals|
    x, y = vals[0],vals[1]
    $model.set_cell_size(x,y)
    z = $model.total_energy+150.45633275921924
    final << sprintf("<%10.5f|%10.5f|%10.5f>,", (x-1.0)*100, (y-1.0)*100,z)
  end
  print "\n\n"+final+"\n"
end


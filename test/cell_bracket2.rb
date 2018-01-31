require_relative '../lib/pseudo_vasp/eam'
require 'scanf'

GOLD = 1.618034
TINY = 1.0e-20
GLIMIT = 100.0

def val_set(ax, bx, cx, fa, fb, fc, head='')
  cont = sprintf("#{head}_x:=[%7.4f, %7.4f, %7.4f];",ax,bx,cx)
  cont << sprintf("#{head}_y:=[%7.4f, %7.4f, %7.4f];\n",fa,fb,fc)
  cont
end

def func_0(ax)
  $n_calc+=1
  res =  1.0*(ax-1.0)*(ax-1.0)
  puts ax.to_s+":"+res.to_s
  res
end

def func(ax)
  $n_calc+=1
  $model.set_cell_size(ax)
  $model.total_energy+150.45633275921924
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


# mnbrak, coding from Num Recipe in C
def mnbrak(ax, bx)
  printf("init range:%10.5f-%10.5f\n",ax,bx)
  $n_calc = 0

  fa = func(ax)
  fb = func(bx)
  if fa<fb
    ax, bx, fa, fb = swap_x_f(ax, bx, fa, fb)
  end
  cx = bx + GOLD*(bx-ax)
  fc = func(cx)
  print val_set(ax, bx, cx, fa, fb, fc, ' init')

  while (fb > fc) do
    r = (bx-ax)*(fb-fc)
    q = (bx- cx)*(fb-fa)
    u = bx - ((bx-cx)*q-(bx-ax)*r)/
      (2.0*sign(fmax( (q-r).abs, TINY),q-r))
    ulim = bx + GLIMIT*(cx-bx)

    if ((bx-u)*(u-cx) > 0.0)
      fu = func(u)
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
      fu= func(u)
    elsif ((cx-u)*(u-ulim)>0.0)
      fu = func(u)
      if (fu<fc)
        bx = cx
        cx = u
        u = cx+GOLD*(cx-bx)
        fb = fc
        fc = fu
        fu = func(u)
      end
    elsif ((u-ulim)*(ulim-cx) > 0.0)
      u =ulim
      fu =func(u)
    else
      u = cx + GOLD*(cx-bx)
      fu =func(u)
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
  return final
end

if $0 == __FILE__
  file = './POSCAR_0_3315_46_Al'
  $model = EAM.new(file)
  mnbrak(1.0, 1.02)
  mnbrak(0.98, 0.99)
  mnbrak(0.97, 0.975)
  mnbrak(0.97, 0.972)
  mnbrak(0.97, 0.971)
  mnbrak(0.97, 1.001)
end


require '../lib/pseudo_vasp/eam'
require 'scanf'

GOLD = 1.618034
TINY = 1.0e-20
GLIMIT = 100.0
$count = 0
def func(ax)
  p $count+=1
  $model.set_cell_size(ax)
  $model.total_energy
end

def shift(ax, bx, fa, fb)
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
  p ax
  p bx
  p fa = func(ax)
  p fb = func(bx)
  if fa>fb
    ax, bx, fa, fb = shift(ax, bx, fa, fb)
  end
  p cx = bx + GOLD*(bx-ax)
  p fc = func(cx)
  p [ax, bx, cx, fa, fb, fc]
  while (fb > fc) do
    p r = (bx-ax)*(fb-fc)
    p q = (bx- cx)*(fb-fa)
    p u = bx - ((bx-cx)*q-(bx-ax)*r)/
      (2.0*sign(fmax( (q-r).abs, TINY),q-r))
    p ulim = bx + GLIMIT*(cx-bx)

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
    p [ax, bx, cx, fa, fb, fc]
  end
  p [ax, bx, cx, fa, fb, fc]
end

file = './POSCAR_0_3315_46_Al'
$model = EAM.new(file)

mnbrak(0.98, 0.99)
mnbrak(1.0, 1.02)

[0.98,0.99,1.0,1.01,1.02].each do |x|
  printf("%5.2f %10.5f\n",x, func(x))
end

require '../lib/pseudo_vasp/eam'
require 'scanf'
file = './POSCAR_0_3315_46_Al'
model = EAM.new(file)

aa = 19.8145937137
bb = 10.3035887311
cc = 4.04140
n_atom = 46

dx = 0.01
dy = 0.01
n = 5
x0 = 1.0-((n-1)/2)*dx
y0 = 1.0-((n-1)/2)*dy

n.times do |i|
  n.times do |j|
    x = x0 + dx*i
    y = y0 + dy*j
    printf("%4d %4d", (x-1)*100, (y-1)*100)
    printf("%10.5f %10.5f %10.5f ", aa, bb, cc)
    model.set_cell_size(x,y)
    df = model.total_energy
    de = df - n_atom * (-3.39)
    ss = aa*x * bb*y
    es = de / ss * 1.60218 * 10 / 2
    
    printf("%-12.5f %-12.5f\n", df, es)
  end
end

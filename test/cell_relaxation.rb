require '../lib/pseudo_vasp/eam'
require 'scanf'
file = './POSCAR_0_3315_46_Al'
model = EAM.new(file)

dx = 0.01
dy = 0.01
n = 5
x0 = 1.0-((n-1)/2+1)*dx
y0 = 1.0-((n-1)/2+1)*dy
n.times do |i|
  n.times do |j|
    x = x0 + dx*i
    y = y0 + dy*j
    printf("%5.2f, %5.2f, ", x-1, y-1)
    model.set_cell_size(x,y)
    printf("%10.5f\n",  model.total_energy)
  end
end

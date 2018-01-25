require '../lib/pseudo_vasp/eam'
require 'scanf'
file = './POSCAR_0_3315_46_Al'
model = EAM.new(file)

dx = 0.01
n = 3
x = 1.0-((n-1)/2+1)*dx
n.times do
  p x += dx
  model.set_cell_size(x)
  model.show_lt
  p model.total_energy
end

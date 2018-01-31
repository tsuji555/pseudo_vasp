require_relative '../lib/pseudo_vasp/eam'
require 'scanf'

if $0 == __FILE__
  file = './POSCAR_0_3315_46_Al'
  file = './POSCAR_0_3315_46_inner_relax_-4_1'
  $model = EAM.new(file)
  $model.show_atom
  $model.show_atom_at(0)
end

require_relative '../lib/pseudo_vasp/eam'
require_relative '../lib/pseudo_vasp/viewer'
require_relative '../lib/pseudo_vasp/two_d_view'
require 'scanf'

file = './POSCAR_0_3315_46_Al'
p $model = EAM.new(file)

@view = TwoDView.new($model.return_data)
@view.set_data(x_lat: $model.lt[0], y_lat: $model.lt[1], cx: 20, scale: 4)
@view.draw_atom_by_val(1)
@view.finish
system('open -a safari view.svg')
      
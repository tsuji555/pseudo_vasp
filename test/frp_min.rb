require_relative '../lib/pseudo_vasp/eam'
require_relative '../lib/relax_functions/powell'
require 'scanf'

$n_calc = 0

def func_xy(input)
  p $n_calc += 1
  ax = (input[0])
  ay = (input[1])
  p ax, ay
  return (ax-0.1)**2+(ay-0.2)**2
  $model.set_cell_size(ax,ay)
  $model.total_energy+150.45633275921924
end

if $0 == __FILE__
  file = './POSCAR_0_3315_46_Al'
#  file = './POSCAR_0_3315_46_inner_relax_-4_1'
  $model = EAM.new(file)
  p0=[0.0,0.0]
  xi=[[0.0,0.001],[0.001,0.0]]
  printf("%10.5f %10.5f %10.5f #min point.\n",p0[0],p0[1],func_xy(p0))
  powell = Powell.new(:verbose => true)
  p powell.calc(p0, xi, 2, 1.0e-2, method(:func_xy))
end


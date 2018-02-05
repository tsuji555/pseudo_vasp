require '../lib/pseudo_vasp/eam'
require 'scanf'

def print_array_in_maple_format(data, heads)
  data.each_with_index do |ele, i|
    head = heads[i]
    line = ele[0..-2].inject("#{head}:=[") { |s, e| s << format('%7.3f,', e) }
    puts line << format("%7.3f];\n", ele[-1])
  end
end

file = './POSCAR_0_3315_46_Al'
$model = EAM.new(file)

data = [[],[]]
11.times do |i|
  ax = 0.95+i*0.01
  $model.set_cell_size(ax)
  de = $model.total_energy+150.45633275921924
  [ax, de].each_with_index{|val, i| data[i] << val}
end

print_array_in_maple_format(data, %w[ratio d_e])

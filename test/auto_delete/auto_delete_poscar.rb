require './poscar'

file = ARGV[0] || 'POSCAR_0_8417'
poscar = Poscar.new(file)
div = ARGV[1].to_i || 32+2
printf("divide num: %4d\n", div)
printf("a length  : %15.10f\n", a_length = poscar.lat_vec[0][0])
printf("normal dx : %10.5f\n", dx = 1.0/div)

a_half = 0.5
selected = []
poscar.pos.each_with_index do |pos,i_atom|
  x_pos = pos[0]
  if x_pos < dx or  (x_pos > a_half and x_pos < a_half + dx)
    printf("%4d %10.5f\n",i_atom.to_i+1,x_pos)
    selected << i_atom
  end
end

poscar.delete_atoms(selected)
File.open('POSCAR_tmp','w') do |file|
  file.print poscar.poscar_format
end

ATOMS = [[0.0, 0.5, 0.5], [0.5, 0.0, 0.5], [0.5, 0.5, 0.0],
         [0.0, -0.5, 0.5], [-0.5, 0.0, 0.5], [-0.5, 0.5, 0.0],
         [0.0, 0.5, -0.5], [0.5, 0.0, -0.5], [0.5, -0.5, 0.0],
         [0.0, -0.5, -0.5], [-0.5, 0.0, -0.5], [-0.5, -0.5, 0.0]].freeze

A0 = 69.1378255
B0 = 12.47431958
P = 2.148157653
POQ = 2.893854749
Q = 0.7423170267

include Math

A_i = [0.0, 0.0, 0.0].freeze

def atom_energy(lat_const)
  rho = 0.0
  rep = 0.0
  ATOMS.each do |aj|
    r = distance(A_i, aj, lat_const)
    rep += A0 * exp(-P * r)
    h = B0 * exp(-Q * r)
    rho += h * h
  end
  bind = - sqrt(rho)
  [rep, bind, rep + bind]
end

def distance(i_atom, j_atom, lat_const)
  dist = 0.0
  3.times do |i|
    tmp = i_atom[i] - j_atom[i]
    dist += tmp * tmp
  end
  Math.sqrt(dist) * lat_const
end

printf("|%10s |%10s |%10s |%10s\n",
       'ratio', 'repulsive', 'binding', 'total')
4.times { printf('|---------:|') }
puts('')

data = [[], [], [], []]
n = 10
dx = 1.0 / n
ratio = 1.0 - dx * (n / 2 + 1)
n.times do
  ratio += dx
  lat_const = 4.0414 * ratio
  rep, bind, ene = atom_energy(lat_const)
  printf("|%10.5f |%10.5f |%10.5f |%10.5f %4.2f\n",
         ratio, rep, bind, ene, -rep/bind)
  [ratio, rep, bind, ene].each_with_index { |val, i| data[i] << val }
end

data.each_with_index do |ele, i|
  head = %w[ratio e_rep e_bind e_total][i]
  line = ele[0..-2].inject("#{head}:=[") { |s, e| s << format('%7.3f,', e) }
  puts line << format("%7.3f];\n", ele[-1])
end

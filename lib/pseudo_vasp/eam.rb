# pseudo vasp using eam with nearest neighbor model

EAMData = Struct.new(:x, :y, :z, :nl, :ene, :ratio)

class EAM
  attr_reader :lt, :lt0
  def initialize(file)
    lines = File.readlines(file)
    @log = lines[0]
    read_lt(lines)
    mk_atoms(lines)
    extend_z
    mk_nl
#    show_atom
  end

  def read_lt(lines)
    @lt = []
    @lt0 = []
    lines[2..4].each_with_index do |line, i|
      @lt << line.scanf(' %f %f %f')[i]
      @lt0 << line.scanf(' %f %f %f')[i]
    end
  end

  def set_cell_size(x=1.0, y=1.0, z=1.0)
    @lt[0] = @lt0[0]*(x)
    @lt[1] = @lt0[1]*(y)
    @lt[2] = @lt0[2]*(z)
  end

  def show_lt
    p @lt
  end

  def total_energy
    sum = 0.0
    @atoms[0..@n_atoms - 1].each_with_index do |iatom, i|
      ene, rep, bind = atom_energy(i)
      sum += ene
    end
    return sum
  end

  def return_data
    data = []
    @atoms[0..@n_atoms - 1].each_with_index do |iatom, i|
      ene, rep, bind = atom_energy(i)
      ratio = -rep/bind
      data << EAMData.new(*iatom.pos, iatom.nl, ene, ratio)
    end
    data
  end

  def show_atom
    @atoms[0..@n_atoms - 1].each_with_index do |iatom, i|
      ene, rep, bind = atom_energy(i)
      printf('%4d %10.5f %10.5f %10.5f',
             i, iatom.pos[0], iatom.pos[1], iatom.pos[2])
      printf("%4d %10.5f %6.3f %10.5f %10.5f %4.2f\n",
             iatom.nl.size, ene, ene + 3.39, rep, bind, -rep/bind)
    end
  end

  def show_atom_at(i)
    iatom = @atoms[i]
    printf("%4d %10.5f %10.5f %10.5f\n\n",
           i, iatom.pos[0], iatom.pos[1], iatom.pos[2])
    iatom.nl.each do |j|
      jatom = @atoms[j]
      d = distance(iatom.pos, jatom.pos)
      printf("%4d %10.5f %10.5f %10.5f %10.5f\n",
             j, jatom.pos[0], jatom.pos[1], jatom.pos[2], d)
    end
  end

  def extend_z
    tmp_atoms = []
    @atoms.each_with_index do |iatom|
      pos = iatom.pos
      tmp_atoms << Atom.new([pos[0], pos[1], pos[2] - @lt[2]])
      tmp_atoms << Atom.new([pos[0], pos[1], pos[2] + @lt[2]])
    end
    @atoms += tmp_atoms
  end

  def mk_nl
    @atoms[0..@n_atoms - 1].each_with_index do |iatom, i|
      @atoms[0..-1].each_with_index do |jatom, j|
        next if j <= i
        if distance(iatom.pos, jatom.pos) < CUT_OFF
          iatom.nl << j
          jatom.nl << i
        end
      end
    end
  end

  def distance(ipos, jpos)
    tmp = 0.0
    lt2 = [@lt[0], @lt[1], @lt[2] * 3.0]
    # usual periodic lattice distance except small z-direction
    3.times do |i|
      x1 = ipos[i] - jpos[i]
      x = x1 - (x1 / (lt2[i])).round * lt2[i]
      tmp += x * x
    end
    Math.sqrt(tmp)
  end

  def mk_atoms(lines)
    @n_atoms = lines[5].scanf('%d')[0]
    @atoms = []
    lines[8..8 + @n_atoms - 1].each do |line|
      pos = line.scanf(' %f %f %f')
      tmp = [pos[0] * @lt[0], pos[1] * @lt[1], pos[2] * @lt[2]]
      @atoms << Atom.new(tmp)
    end
  end

  A0 = 69.1378255
  B0 = 12.47431958
  P = 2.148157653
  POQ = 2.893854749
  Q = 0.7423170267
  # for phi(r0)=-3.39, Ev=0.8, p=3.0 at r0, r0=2.8577
  CUT_OFF = 4.0414 * 0.82

  include Math

  def atom_energy(i)
    rho = 0.0
    rep = 0.0
    ai = @atoms[i]
    ai.nl.each do |j|
      r = distance(ai.pos, @atoms[j].pos)
      rep += A0 * exp(-P * r)
      h = B0 * exp(-Q * r)
      rho += h * h
    end
    bind = - sqrt(rho)
    [rep+bind, rep, bind]
  end
end

# simple class of atom
class Atom
  attr_accessor :pos, :nl
  def initialize(pos = [0.0, 0.0, 0.0])
    @pos = pos
    @nl = []
  end
end


class Poscar
  attr_accessor :comment, :scaling_factor, :lat_vec, :n_atoms, :pos
  attr_accessor :elements, :relax
  attr_accessor :dynamics_selector, :direct_cartesian_switch
  RE_3F = /([-+]?[\d\.]+)\s*([-+]?[\d\.]+)\s*([-+]?[\d\.]+)/
  RE_3F3D = /([-+]?[\d\.]+)\s*([-+]?[\d\.]+)\s*([-+]?[\d\.]+)\s*(\d)\s*(\d)\s*(\d)/
  RE_3F3W = /([-+]?[\d\.]+)\s*([-+]?[\d\.]+)\s*([-+]?[\d\.]+)\s*(\w)\s*(\w)\s*(\w)/

  def initialize(file_name)
    @pos = []
    @elements = []
    @relax = []
    file = read(file_name)
    read_headers(file)
    read_pos(file)
    file.close
  end

  def read(file_name)
    begin
      file = open(file_name)
    rescue => error
      puts error.to_s
      exit
    end
    file
  end

  def read_headers(file)
    @comment = file.gets.chomp
    @scaling_factor = file.gets.chomp.to_f

    @lat_vec = []
    3.times { @lat_vec << file.gets.match(RE_3F)[1..3].map(&:to_f) }
    @n_atoms = file.gets.chomp.split(' ').map(&:to_i)
    if (line = file.gets) =~ /Selective dynamics/
      @dynamics_selector = true
      if file.gets !~ /Direct/
        print "Not support Cartesian mode.\n"
        exit
      end
    else
      @dynamics_selector = false
      if line !~ /Direct/
        print "Not support Cartesian mode.\n"
        exit
      end
    end
  end

  def read_pos(file)
    @n_atoms.each_with_index do |size, element|
      size.times do
        tmp = file.gets.match(RE_3F3D)[1..6]
        @pos << [tmp[0], tmp[1], tmp[2]].map(&:to_f)
        @relax << [tmp[3], tmp[4], tmp[5]].map(&:to_i)
        @elements << element
      end
    end
  end

  def poscar_format
    text = format("%s\n", @comment)
    text << format("%15.10f\n", @scaling_factor)
    @lat_vec.each do |vec|
      text << format("%15.10f %15.10f %15.10f\n",
                     vec[0], vec[1], vec[2])
    end
    @n_atoms.each { |n_atom| text << format('%4d', n_atom) }
    text << format("\nSelective dynmaics\nDirect\n")
    @pos.each do |pos|
      text << format("%15.10f %15.10f %15.10f T T T\n",
                     pos[0], pos[1], pos[2])
    end
    text
  end

  def delete_atoms(selected)
    p selected.sort.reverse
    p n_del = selected.size
    selected.sort.reverse.each do |i_atom|
      @pos.delete_at(i_atom)
    end
    p @n_atoms[0] = @pos.size
  end
end

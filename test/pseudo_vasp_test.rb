require "test_helper"

class PseudoVaspTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PseudoVasp::VERSION
  end

  def test_read_unit_poscar
    file = 'test/POSCAR_0'
    model = EAM.new(file)
    assert true
  end

  def test_read_boundary_poscar
    file = 'test/POSCAR_0_3315_46_Al'
    model = EAM.new(file)
    assert true
  end


end

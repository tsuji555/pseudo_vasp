require "test_helper"
require "cell_bracket2"
require "cell_eam"

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

  def test_mn_brak_case_1
    expected ='final_x:=[ 1.0200,  1.0000,  0.9676];final_y:=[ 0.2414,  0.0000,  1.1178];'
    file = 'test/POSCAR_0_3315_46_Al'
    $model = EAM.new(file)
    actual = mnbrak(1.0, 1.02)
    assert_equal actual.chomp, expected
  end

  def test_mn_brak_case_1
      file = 'test/POSCAR_0_3315_46_Al'
    $model = EAM.new(file)
    actual = mnbrak(1.0, 1.02)
    assert_equal actual.chomp, expected
  end
end

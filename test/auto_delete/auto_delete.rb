file = ARGV[0] || 'energy_data.txt'
lines = File.readlines(file)
printf("divide num: %4d\n", div = 32)
printf("a length  : %15.10f\n", a_length =   56.0109463716)
#dx = a_length/(32+2)
printf("normal dx : %10.5f\n", 1.0/div)
printf("       dx : %10.5f\n", dx = a_length/div)
a_half = a_length/2.0
lines.each do |line|
  break if line.include?('data for atom 0')
  vals = line.chomp.split(/\s+/)
  # val = vals[6].to_f
  x_pos = vals[2].to_f
  break if vals[1] == nil
  #  puts line.chomp if val>-3.2
  if x_pos < dx or  (x_pos > a_half and x_pos < a_half + dx)
    printf("%4d: %10.5f ", vals[1].to_i+1, x_pos/a_length)
    printf("%10.5f\n", x_pos)
  end
end

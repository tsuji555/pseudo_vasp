require 'fileutils'
s_dir = ARGV[0]
t_dir = ARGV[1]
Dir.entries(s_dir)[2..-1].each do |file|
  p names = file.split('.')
  p t_name = names[0]+'_'+names[1]+'.'+names[2]
  FileUtils.cp(File.join(s_dir,file),
                       File.join(t_dir,t_name),verbose: true)
end

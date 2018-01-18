require "pseudo_vasp/version"
require "pseudo_vasp/eam"
require 'scanf'
require "thor"

module PseudoVasp
  class Command < Thor
    def initialize(*args)
      super
      puts "hello"
    end

    desc 'version, -v', 'show program version'
    #    map "--version" => "version"
    map "--version" => "version"
    def version
      puts PseudoVasp::VERSION
    end

    desc 'eam', 'calc eam'
    def eam(*argv)
      model = EAM.new(argv[0])
    end
  end
end

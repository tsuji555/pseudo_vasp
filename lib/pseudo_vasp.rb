require "pseudo_vasp/version"
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


  end
end

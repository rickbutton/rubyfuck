require "optparse"
require "ostruct"

module Rubyfuck
  class Options

    LANGS = [:bf, :c]

    def self.parse(args)
      options = OpenStruct.new
      
      options.language = nil

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: rubyfuck [options] [file]"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-l", "--language LANG",
          "Instead of interpreting, output compiled code in the specified language.") do |lang|
          options.language = lang.to_sym
        end
      end
      opt_parser.parse!(args)
      options.file = args.last
      options
    end
  end
end

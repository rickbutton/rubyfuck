require "optparse"
require "ostruct"

module Rubyfuck
  class Options

    def self.parse(args)
      options = OpenStruct.new
      
      options.language = nil
      options.passes = -1

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: rubyfuck [options] [file]"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-l", "--language LANG",
          "Instead of interpreting, output compiled code in the specified language.") do |lang|
          options.language = lang.to_sym
        end

        opts.on("-p", "--passes PASSES",
          "Run only the first n passes of optimization") do |passes|
          options.passes = passes.to_i
        end
      end
      opt_parser.parse!(args)
      options.file = args.last
      options
    end
  end
end

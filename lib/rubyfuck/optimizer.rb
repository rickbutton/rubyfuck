Dir[File.join(File.dirname(__FILE__), "optimizer", "*")].each { |f| require f }

module Rubyfuck
  module Optimizer

    OPTS = [FirstPass, SecondPass, ThirdPass]

    def self.optimize(tree, options, opts = OPTS)
      passes = options.passes
      passes = opts.length if passes < 0

      opts[0...passes].each do |o|
        tree = o.new.optimize(tree) 
      end
      tree
    end
  end
end

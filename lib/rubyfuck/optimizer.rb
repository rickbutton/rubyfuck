Dir[File.join(File.dirname(__FILE__), "optimizer", "*")].each { |f| require f }

module Rubyfuck
  module Optimizer

    OPTS = [FirstPass, SecondPass, ThirdPass]

    def self.optimize(tree, options)
      passes = options.passes
      passes = OPTS.length if passes < 0

      OPTS[0...passes].each do |o|
        tree = o.new.optimize(tree) 
      end
      tree
    end
  end
end

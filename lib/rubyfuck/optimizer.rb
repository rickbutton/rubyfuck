Dir[File.join(File.dirname(__FILE__), "optimizer", "*")].each { |f| require f }

module Rubyfuck
  module Optimizer

    OPTS = [FirstPass, SecondPass, ThirdPass]

    def self.optimize(tree)
      OPTS.each do |o|
        tree = o.new.optimize(tree) 
      end
      tree
    end
  end
end

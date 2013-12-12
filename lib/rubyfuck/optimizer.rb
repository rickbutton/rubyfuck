Dir[File.join(File.dirname(__FILE__), "optimizer", "*")].each { |f| require f }

module Rubyfuck
  module Optimizer

    OPTS = [MultiIncDec, MultiMove]

    def self.optimize(tree)
      OPTS.each do |o|
        tree = o.new.optimize(tree) 
      end
      tree
    end
  end
end

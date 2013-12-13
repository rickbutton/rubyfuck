module Rubyfuck::Optimizer
  class ThirdPass

    class State < Struct.new(:simple_loop, :tmp_new, :move, :update_zero, :new)
      def initialize
        reset
        self.new = []
      end

      def reset
        self.simple_loop = false
        self.tmp_new = []
        self.move = 0
        self.update_zero = 0
      end

    end

    def optimize(node)
      state = State.new
      optimize_tree(state, node)
    end

    def optimize_tree(state, tree)
      exprs = tree.exprs
      
      new = optimize_exprs(state, exprs)

      Rubyfuck::Expression::Tree.new(new)
    end

    def optimize_loop(state, l)
      tree = l.tree
      exprs = tree.exprs
      
      if is_simple?(exprs)
        new << make_simple_loop(exprs)
      end
      Rubyfuck::Expression::Loop.new(new)
    end

    def optimize_exprs(state, exprs)
      exprs.each do |e|
        case e
        when Rubyfuck::Expression::Loop
          state.new << optimize_loop(state, e)
        else
          state.new << e
        end
      end
      state.new 
    end
  end
end

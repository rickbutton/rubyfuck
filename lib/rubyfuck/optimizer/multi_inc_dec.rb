require "rubyfuck/expression"

module Rubyfuck::Optimizer
  class MultiIncDec

    class State < Struct.new(:update, :new)
      def initialize
        self.update = 0
        self.new = []
      end
    end

    def optimize(node)
      optimize_tree(node)
    end

    def optimize_tree(tree)
      exprs = tree.exprs

      new = self.optimize_exprs(exprs)

      Rubyfuck::Expression::Tree.new(new)
    end

    def optimize_loop(l)
      tree = l.tree

      new = self.optimize_tree(tree)

      Rubyfuck::Expression::Loop.new(new)
    end

    def optimize_exprs(exprs)
      state = State.new
      exprs.each do |e|
        case e
        when Rubyfuck::Expression::Inc
          handle_inc(e, state)
        when Rubyfuck::Expression::Dec
          handle_dec(e, state)
        when Rubyfuck::Expression::Tree
          handle_tree(e, state)
        when Rubyfuck::Expression::Loop
          handle_loop(e, state)
        else
          handle_other(e, state)
        end
      end

      if state.update.nonzero?
        state.new << generate(state.update)
      end

      state.new
    end

    private

    def handle_inc(e, state)
      state.update += 1
    end

    def handle_dec(e, state)
      state.update -= 1
    end

    def handle_tree(e, state)
      if state.update.nonzero?
        state.new << generate(state.update)
        state.update = 0
      end
      state.new << optimize_tree(e)
    end

    def handle_loop(e, state)
      if state.update.nonzero?
        state.new << generate(state.update)
        state.update = 0
      end
      state.new << optimize_loop(e)
    end

    def handle_other(e, state)
      if state.update.nonzero?
        state.new << generate(state.update)
        state.update = 0
      end
      state.new << e
    end

    def generate(update)
      Rubyfuck::Expression::MultiUpdate.new(update)
    end
  end
end

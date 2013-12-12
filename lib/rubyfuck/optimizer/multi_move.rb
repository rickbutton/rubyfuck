require "rubyfuck/expression"

module Rubyfuck::Optimizer
  class MultiMove

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
      counting = false
      update = 0
      new = []
      exprs.each do |e|
        case e
        when Rubyfuck::Expression::Next
          counting, update, new = handle_next(e, counting, update, new)
        when Rubyfuck::Expression::Prev
          counting, update, new = handle_prev(e, counting, update, new)
        when Rubyfuck::Expression::Tree
          counting, update, new = handle_tree(e, counting, update, new)
        when Rubyfuck::Expression::Loop
          counting, update, new = handle_loop(e, counting, update, new)
        else
          counting, update, new = handle_other(e, counting, update, new)
        end
      end

      if counting
        new << generate(update)
      end

      new
    end

    private

    def handle_next(e, counting, update, new)
      unless counting
        counting = true
      end
      update += 1
      [counting, update, new]
    end

    def handle_prev(e, counting, update, new)
      unless counting
        counting = true
      end
      update -= 1
      [counting, update, new]
    end

    def handle_tree(e, counting, update, new)
      if counting
        counting = false
        new << generate(update)
        update = 0
      end
      new << optimize_tree(e)
      [counting, update, new]
    end

    def handle_loop(e, counting, update, new)
      if counting
        counting = false
        new << generate(update)
        update = 0
      end
      new << optimize_loop(e)
      [counting, update, new]
    end

    def handle_other(e, counting, update, new)
      if counting
        counting = false
        new << generate(update)
        update = 0
      end
      new << e
      [counting, update, new]
    end

    def generate(update)
      Rubyfuck::Expression::MultiMove.new(update)
    end
  end
end

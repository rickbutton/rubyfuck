module Rubyfuck::Optimizer
  class ThirdPass

    def optimize(node)
      optimize_tree(node)
    end

    def optimize_tree(tree)
      exprs = tree.exprs
      
      new = optimize_exprs(exprs)

      Rubyfuck::Expression::Tree.new(new)
    end

    def optimize_exprs(exprs)
      new = []

      exprs.each do |e|
        case e
        when Rubyfuck::Expression::Loop
          new += simplify_loop(e)
        else
          new << e
        end
      end
      new 
    end

    def simplify_loop(l)
      exprs = l.tree.exprs

      simple = true
      move = 0
      deltas = {}
      new = []

      exprs.each do |e|
        case e
        when Rubyfuck::Expression::Loop
          simple = false
          new += simplify_loop(e)
        when Rubyfuck::Expression::In, Rubyfuck::Expression::Out
          simple = false
          new << e
        when Rubyfuck::Expression::MultiMove
          move += e.change
          new << e
        when Rubyfuck::Expression::MultiUpdate
          deltas[move] ||= 0
          deltas[move] += e.change
          new << e
        when Rubyfuck::Expression::MultiUpdateAt
          deltas[move + e.at] ||= 0
          deltas[move + e.at] += e.change
          new << e
        else
          new << e
        end
      end

      if simple && move == 0 && deltas[0] == -1
        result = []
        deltas.delete(0)
        offsets = deltas.keys.sort
        offsets.each do |offset|
          result << Rubyfuck::Expression::MultiplyAdd.new(0, offset, deltas[offset])
        end
        result << Rubyfuck::Expression::Assign.new(0,0)
        result
      else
        t = Rubyfuck::Expression::Tree.new(new)
        l = Rubyfuck::Expression::Loop.new(t)
        [l]
      end
    end
  end
end

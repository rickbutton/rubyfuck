module Rubyfuck::Optimizer
  class SecondPass
    
    class State < Struct.new(:direction, :move, :update, :new)
      def initialize
        self.direction = nil
        self.move = nil
        self.update = nil
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
        when Rubyfuck::Expression::MultiUpdate
          handle_update(e, state)
        when Rubyfuck::Expression::MultiMove
          handle_move(e, state)
        when Rubyfuck::Expression::Tree
          handle_tree(e, state)
        when Rubyfuck::Expression::Loop
          handle_loop(e, state)
        else
          handle_other(e, state)
        end
      end

      if state.move
        state.new << state.move
      end

      if state.update
        state.new << state.update
      end

      state.new
    end

    private

    def handle_move(e, state)
      if state.move
        if state.move.change == -e.change
          state.new << generate(state.move, state.update, state.direction)
          state.move = nil
          state.update = nil
          state.direction = nil
        else
          state.new << state.move
          state.new << state.update
          state.new << e
          state.move = nil
          state.update = nil
          state.direction = nil
        end
      else
        state.move = e
        state.direction = e.change > 0 ? :forward : :backward
      end
    end

    def handle_update(e, state)
      if state.move
        state.update = e
      else
        state.new << e
      end
    end

    def handle_tree(e, state)
      if state.move
        state.new << state.move
        state.move = nil
      end

      if state.update
        state.new << state.update
        state.update = nil
      end


      state.direction = nil
      state.new << optimize_tree(e)
    end

    def handle_loop(e, state)
      if state.move
        state.new << state.move
        state.move = nil
      end

      if state.update
        state.new << state.update
        state.update = nil
      end

      state.direction = nil
      state.new << optimize_loop(e)
    end

    def handle_other(e, state)
      if state.move
        state.new << state.move
        state.move = nil
      end

      if state.update
        state.new << state.update
        state.update = nil
      end

      state.direction = nil
      state.new << e
    end

    def generate(move, update, direction)
      Rubyfuck::Expression::MultiUpdateAt.new(
        move.change, 
        update.change, 
        direction
      )
    end
  end
end

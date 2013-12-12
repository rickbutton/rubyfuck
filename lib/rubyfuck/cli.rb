module Rubyfuck
  class CLI

    def initialize(args)
      @file_name = args.first
    end

    def start
      file = File.open(@file_name)

      parser = Rubyfuck::Parser.new

      tree = parser.parse(file)

      ast = tree.to_ast

      optimized = Rubyfuck::Optimizer.optimize(ast)

      interpreter = Rubyfuck::Interpreter.new

      interpreter.run(optimized)
    end
  end
end

require "rubyfuck/options"

module Rubyfuck
  class CLI

    def initialize(args)
      @options = Options.parse(args)
    end

    def start
      file = File.open(@options[:file])

      parser = Rubyfuck::Parser.new

      tree = parser.parse(file)

      ast = tree.to_ast

      binding.pry

      optimized = Rubyfuck::Optimizer.optimize(ast)

      binding.pry

      if @options.language
        puts Rubyfuck::Compiler.compile(optimized, @options.language)
      else
        interpreter = Rubyfuck::Interpreter.new
        interpreter.run(optimized)
      end

    end
  end
end

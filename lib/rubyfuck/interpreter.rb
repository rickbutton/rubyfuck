require "rubyfuck/runtime"

module Rubyfuck
  class Interpreter

    def initialize(options)
      @options = options
    end

    def run(tree)
      tree.run(Runtime.new(@options))
    end
  end
end

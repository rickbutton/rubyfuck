module Rubyfuck
  class Interpreter

    class Runtime < Struct.new(:mem)

      attr_accessor :p

      def initialize
        @mem = [0]*3000
        @p = 0
      end

      def val
        @mem[@p]
      end

      def val=(value)
        @mem[@p] = value
      end

      def mem
        @mem
      end
    end

    def run(tree)
      tree.run(Runtime.new)
    end
  end
end

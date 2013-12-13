module Rubyfuck
  class Interpreter

    class Runtime

      attr_accessor :p
      attr_reader :options

      def initialize(options)
        @mem = [0]*3000
        @p = 0
        @options = options
      end

      def val
        @mem[@p]
      end

      def val_at(at)
        @mem[at]
      end

      def val_at_offset(offset)
        @mem[@p + offset]
      end

      def val=(value)
        @mem[@p] = value % 256
      end

      def set_val_at(at, value)
        @mem[at] = value % 256
      end

      def set_val_at_offset(offset, value)
        @mem[@p + offset] = value % 256
      end
    end

    def initialize(options)
      @options = options
    end

    def run(tree)
      tree.run(Runtime.new(@options))
    end
  end
end

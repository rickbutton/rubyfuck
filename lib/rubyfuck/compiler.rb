module Rubyfuck
  module Compiler
    def self.compile(ast, lang)
      header(ast, lang) + body(ast, lang) + footer(ast, lang)
    end

    private
      
      def self.header(ast, lang)
        case lang
        when :bf
          ""
        when :c
          "#include <stdio.h>\nint main() {\n char array[30000]; char *ptr = array;\n"
        end
      end

      def self.body(ast, lang)
        ast.send("to_#{lang}")
      end

      def self.footer(ast, lang)
        "return 0;\n}"
      end
  end
end

module Rubyfuck
  module Compiler

    C_HEADER = 
      "#include <stdio.h>\nint main() {\nchar array[30000];\nchar *ptr = array;\n"

    VALID_LANGS = [:c]

    def self.compile(ast, lang)
      raise "invalid language #{lang}" unless VALID_LANGS.include? lang
      header(ast, lang) + body(ast, lang) + footer(ast, lang)
    end

    private
      
      def self.header(ast, lang)
        case lang
        when :c
          C_HEADER
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

module Rubyfuck::Expression
  class Tree < Struct.new(:exprs)

    def run(runtime)
      exprs.each { |e| e.run(runtime) }
    end

    def to_bf
      str = ""
      exprs.each { |e| str += e.to_bf }
      str
    end
  end

  class Loop < Struct.new(:tree)
    def run(runtime)
      tree.run(runtime) until runtime.val == 0
    end

    def to_bf
      "[#{tree.to_bf}]"
    end
  end

  class Next
    def run(runtime)
      runtime.p += 1
    end

    def to_bf
      ">"
    end
  end

  class Prev
    def run(runtime)
      runtime.p -= 1
    end

    def to_bf
      "<"
    end
  end

  class Inc
    def run(runtime)
      runtime.val += 1
    end

    def to_bf
      "+"
    end
  end

  class Dec
    def run(runtime)
      runtime.val -= 1
    end

    def to_bf
      "-"
    end
  end

  class In
    def run(runtime)
      raise "no input implemented"
    end

    def to_bf
      ","
    end
  end

  class Out
    def run(runtime)
      putc runtime.val.chr
    end

    def to_bf
      "."
    end
  end

  class Ignore
    def run(runtime)
    end

    def to_bf
      ""
    end
  end

  # Optimized ast nodes
  class MultiUpdate < Struct.new(:change)
    def run(runtime)
      runtime.val += change
    end

    def to_bf
      if change > 0
        "+" * change
      elsif change < 0
        "-" * -change
      else
        ""
      end
    end
  end

  class MultiMove < Struct.new(:change)
    def run(runtime)
      runtime.p += change
    end

    def to_bf
      if change > 0
        ">" * change
      elsif change < 0
        "<" * -change
      else
        ""
      end
    end
  end

  class MultiUpdateAt < Struct.new(:at, :change)
    def run(runtime)
      p = runtime.p + at
      runtime.mem[p] += change
    end

    def to_bf
      if change > 0
        str = "+" * change
      elsif change < 0
        str = "-" * -change
      else
        ""
      end
      "#{">" * at}#{str}#{"<" * at}"
    end
  end
end

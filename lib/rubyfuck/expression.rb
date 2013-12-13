module Rubyfuck::Expression
  class Tree < Struct.new(:exprs)

    def run(runtime)
      exprs.each { |e| e.run(runtime) }
    end

    def to_c
      str = ""
      exprs.each { |e| str += e.to_c }
      str
    end

    def length
      sum = 0
      exprs.each do |e|
        if e.respond_to? :length
          sum += e.length
        else
          sum += 1
        end
      end
      sum
    end
  end

  class Loop < Struct.new(:tree)
    def run(runtime)
      tree.run(runtime) until runtime.val == 0
    end

    def to_c
      "while (*ptr) {\n#{tree.to_c}}\n"
    end

    def length
      tree.length
    end
  end

  class Next
    def run(runtime)
      runtime.p += 1
    end

    def to_c
      "++ptr;\n"
    end
  end

  class Prev
    def run(runtime)
      runtime.p -= 1
    end

    def to_c
      "--ptr;\n"
    end
  end

  class Inc
    def run(runtime)
      runtime.val += 1
    end

    def to_c
      "++*ptr;\n"
    end
  end

  class Dec
    def run(runtime)
      runtime.val -= 1
    end

    def to_c
      "--*ptr;\n"
    end
  end

  class In
    def run(runtime)
      begin
        system("stty raw -echo")
        getc
      ensure
        system("stty -raw echo")
      end
    end

    def to_c
      "*ptr = getchar();\n"
    end
  end

  class Out
    def run(runtime)
      putc runtime.val.chr
    end

    def to_c
      "putchar(*ptr);\n"
    end
  end

  class Ignore
    def run(runtime)
    end

    def to_c
      ""
    end
  end

  # Optimized ast nodes
  class MultiUpdate < Struct.new(:change)
    def run(runtime)
      runtime.val += change
    end

    def to_c
      "*ptr += #{change};\n"
    end
  end

  class MultiMove < Struct.new(:change)
    def run(runtime)
      runtime.p += change
    end

    def to_c
      "ptr += #{change};\n"
    end
  end

  class MultiUpdateAt < Struct.new(:at, :change, :direction)
    def run(runtime)
      runtime.set_val_at_offset(at, runtime.val_at_offset(at) + change)
    end

    def to_c
      "ptr[#{at}] += #{change};\n"
    end
  end
  
  class Assign < Struct.new(:offset, :change)
    def run(runtime)
      runtime.set_val_at_offset(offset, change)
    end

    def to_c
      "ptr[#{offset}] = #{change};\n"
    end
  end

  class MultiplyAdd < Struct.new(:src, :dest, :value)
    def run(runtime)
      runtime.set_val_at_offset(
        dest,
        runtime.val_at_offset(dest) + runtime.val_at_offset(src) * value
      )
    end

    def to_c
      "ptr[#{dest}] += ptr[#{src}] * #{value};\n"
    end
  end
end

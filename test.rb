require "rubyfuck"
require "pry"

file_name = "mandlebrot.b"
file = File.open(file_name)

parser = Rubyfuck::Parser.new

tree = parser.parse(file.read)

ast = tree.to_ast

interpreter = Rubyfuck::Interpreter.new

optimized = Rubyfuck::Optimizer.optimize(ast)

puts "ast length: #{ast.exprs.length}"
puts "opt length: #{optimized.exprs.length}"

puts optimized.to_bf

raise "error" if ast.to_bf != optimized.to_bf

interpreter.run(optimized)

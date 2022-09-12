require "readline"
require "./reader.rb"
require "./printer.rb"

$repl_env = Hash[:+ => lambda {| x, y | x + y},
            :- => lambda {| x, y | x - y},
            :* => lambda {| x, y | x * y},
            :/ => lambda {| x, y | x / y}]

def read(input)
  return read_str(input)
end

def eval(input, env)
  # p input
  case input
  when Array
    # puts input.class
    unless input.length == 0
      new_ast = eval_ast(input, env)
      # p new_ast
      (input[0] == "\u{0020}") ? (func = new_ast[1]) : (func = new_ast[0])
      if func.respond_to?(:call) && new_ast[0] != "\u{0020}"
        func.call(*new_ast[1..])
      elsif new_ast[0] == "\u{0020}"
        return new_ast
      else
        raise KeyError.new("#{func} is not a callable function")
      end
    else
      return input
    end
  else
    return eval_ast(input, env)
  end
end

def eval_ast(ast, env)
  case ast
  when Symbol
    return env.fetch(ast)
  when Array
    if ast[0] == "\u{0020}"
      vec = Array.new
      ast.each do | token |
        vec.push(eval(token, env))
      end
      return vec
    else
      new_ast = Array.new
      ast.each do | token |
        new_ast.push(eval(token, env))
      end
      return new_ast
    end
  else
    return ast
  end
end

def print(input)
  return pr_str(input, true)
end

def rep(input)
  begin
    result = print(eval(read(input), $repl_env))
  rescue EOFError => error
    result = error
  rescue KeyError => error
    result = error
  rescue ArgumentError => error
    result = error
  end
  return result
end

def main()
  while input = Readline.readline("user> ", true) 
    puts rep(input)
  end
end



main

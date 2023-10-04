require "readline"
require "./reader.rb"
require "./printer.rb"
require "./env.rb"

# $repl_env = Hash[:+ => lambda {| x, y | x + y},
#             :- => lambda {| x, y | x - y},
#             :* => lambda {| x, y | x * y},
#             :/ => lambda {| x, y | x / y}]

$repl_env = Env.new()
$repl_env.set(:+, lambda {| x, y | x + y})
$repl_env.set(:-, lambda {| x, y | x - y})
$repl_env.set(:*, lambda {| x, y | x * y})
$repl_env.set(:/, lambda {| x, y | x / y})

def read(input)
  return read_str(input)
end

def EVAL(input, env)
  # p input
  case input
  when Array
    # puts input.class
    unless input.length == 0
      if input[0] == :evalr
        eval((input[1].class == Array) ? input[1].join(" ") : input[1])
      elsif input[0] == :def!
        env.set(input[1], EVAL(input[2], env))
      elsif input[0] == "let*".to_sym
        new_env = Env.new($repl_env)
        i = 0
        while i < input[1].size
          (input[1][0] == "\u{0020}") ? (offset = 1) : (offset = 0)
          new_env.set(input[1][i + offset], EVAL(input[1][i+1 + offset], new_env))
          i += 2
        end
        EVAL(input[2], new_env)
      else
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
      end
    else
      return input
    end
  when Hash
    keys = input.keys
    new_ast = Hash.new
    keys.each do | key |
      new_ast[key] = EVAL(input[key], env)
    end
    return new_ast
  else
    return eval_ast(input, env)
  end
end

def eval_ast(ast, env)
  case ast
  when Symbol
    return env.get(ast)
  when Array
    if ast[0] == "\u{0020}"
      vec = Array.new
      ast.each do | token |
        vec.push(EVAL(token, env))
      end
      return vec
    else
      new_ast = Array.new
      ast.each do | token |
        new_ast.push(EVAL(token, env))
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
    result = print(EVAL(read(input), $repl_env))
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

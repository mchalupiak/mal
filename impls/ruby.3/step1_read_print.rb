require "readline"
require "./reader.rb"
require "./printer.rb"


def read(input)
  return read_str(input)
end

def eval(input)
  return input
end

def print(input)
  return pr_str(input, true)
end

def rep(input)
  begin
    result = print(eval(read(input)))
  rescue EOFError => error
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

require "readline"

def read(input)
  return input
end

def eval(input)
  return input
end

def print(input)
  return input
end

def rep(input)
  print(eval(read(input)))
end

def main()
  while input = Readline.readline("user> ", true) 
    puts rep(input)
  end
end



main

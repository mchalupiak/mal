class Reader
  def initialize(tokens)
    @position = 0
    @current_token = tokens[0]
    @tokens = tokens
  end

  def next
    token = peek
    @position += 1
    return token
  end

  def peek
    return @tokens[@current_token]
  end

end

def read_str(input)
  tokens = tokenize(input)
  reader = Reader.new(tokens)
  read_form(reader)
end

def tokenize(input)
  token_regex = Regexp.new(/[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/)
  tokens = input.scan(token_regex[0..-2])
  return tokens
end

def read_form(reader)
  case reader.peek
  when "("
    read_list(reader)
  else
    read_atom(reader)
  end
end

def read_list(reader)
  while reader.next != ")"
    read_form(reader)
  end
end

def read_atom(reader)
  case reader.peek.class?
  when Numeric
    return reader.peek
  when String
    return reader.peek
  end
end


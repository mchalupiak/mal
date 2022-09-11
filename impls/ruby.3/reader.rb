class Reader

  def initialize(tokens)
    @position = 0
    @tokens = tokens
  end

  def next
    token = peek
    if @position < @tokens.count
      @position += 1
    end
    return token
  end

  def peek
    return @tokens[@position]
  end

  def pos
    return @position
  end

  def token_len
    return @tokens.count
  end

  def peek1
    return @tokens[@position + 1]
  end

  def next1
    @position += 1
    return peek
  end

end

def read_str(input)
  tokens = tokenize(input)
  reader = Reader.new(tokens)
  return read_form(reader)
end

def tokenize(input)
  token_regex = Regexp.new(/[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/)
  tokens = input.scan(token_regex).flatten
  puts tokens[0..-2].to_s
  unless tokens.count("(") != tokens.count(")")
    return tokens[0..-2]
  else
    raise EOFError.new("EOF Error")
  end
end

def read_form(reader)
  case reader.peek
  when "("
    #form = Array.new
    #while reader.pos < reader.token_len-1
    #  reader.next
    #  # puts form.to_s + "," + reader.pos.to_s + "-2"
    #  form.push(read_list(reader))
    #  puts form.to_s + "," + reader.pos.to_s
    #end
    #puts form.to_s + "form"
    #return form
    # reader.next
    return read_list(reader)
  else
    return read_atom(reader)
  end
end

def read_list(reader)
  reader.next
  arr = Array.new
  while reader.peek != ")"
    # puts reader.peek.to_s + "pos:" + reader.pos.to_s
    arr.push(read_form(reader))
    # puts arr.to_s + "arr"
  end
  # puts "returned"
  reader.next
  return arr
end

def read_atom(reader)
  case
  when !Integer(reader.peek, exception: false).nil?
    return Integer(reader.next)
  when reader.peek.match?(/"(?:\\.|[^\\"])*"?/)
    return reader.next
  when reader.peek == "nil"
    return nil
  when reader.peek == "true"
    return true
  when reader.peek == "false"
    return false 
  else
    return reader.next.to_sym
  end
end

def unescape(str)
  return str.gsub("\\\\", "\\")
end

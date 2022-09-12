
class Reader

  def initialize(tokens)
    @position = 0
    @tokens = tokens.nil? ? Array.new : tokens
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
  if input.nil?
    return nil
  end
  token_regex = Regexp.new(/[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/)
  tokens = input.scan(token_regex).flatten
  # puts tokens[0..-2].to_s
  if tokens.count("(") != tokens.count(")")
    raise EOFError.new("EOF Error: Unmatched Paratheses")
  elsif tokens.count("[") != tokens.count("]")
    raise EOFError.new("EOF Error: Unmatched Brackets")
  elsif tokens.count("{") != tokens.count("}")
    raise EOFError.new("EOF Error: Unmatched Braces")
  # elsif tokens.join("").count("\"") % 2 != 0
    # raise EOFError.new("EOF Error: Unmatched Double Quote")
  elsif tokens[0].match?(/;+/)
    return nil
  else
    return tokens[0..-2]
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
  when "["
    return read_vector(reader)
  when "{"
    return read_hashmap(reader)
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

def read_vector(reader)
  reader.next
  vec = Array.[]("\u{0020}")
  while reader.peek != "]"
    vec.push(read_form(reader))
  end
  reader.next
  return vec
end

def read_hashmap(reader)
  reader.next
  hash = Hash.new
  is_key = true
  key = ""
  entries = 0;
  while reader.peek != "}"
    if is_key
      key = read_form(reader)
      key.class == String ? (is_key = false) : (raise KeyError.new("Key Error: HashMap Keys can only be strings or keywords"))
      hash[key]
    elsif !is_key
      hash[key] = read_form(reader)
      is_key = true
    end
    entries += 1
  end
  if entries % 2 != 0
    raise EOFError.new("Unbalanced Hashmap: Make sure every key has a value")
  end
  reader.next
  return hash
end

def read_atom(reader)
  case
  when reader.peek.nil?
    reader.next
    return nil
  when !Integer(reader.peek, exception: false).nil?
    return Integer(reader.next)
  when reader.peek.match?(/"(?:\\.|[^\\"])*"?/)
    return unescape(reader.next)
  when reader.peek == "nil"
    reader.next
    return nil
  when reader.peek == "true"
    reader.next
    return true
  when reader.peek == "false"
    reader.next
    return false 
  when reader.peek.match?(/^:[A-z]*/)
    return "\u{0020}" + reader.next
  else
    return reader.next.to_sym
  end
end

def unescape(str)
  #p str[1..-2]
  #returnval = str[1..-2].gsub("\\n", "\n").gsub("\\\\", "\\").gsub("\\\"", "\"")
  #p returnval
  return str[1..-2].gsub(/\\./, {"\\\\" => "\\", "\\n" => "\n", "\\\"" => '"'})
end

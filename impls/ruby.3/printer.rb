

def pr_str(ast, print_readably)
  prnt_str = ""
  case ast
  when Array
    ast[0] == "\u{0020}" ? (vec = true) : (vec = false)
    vec ? (prnt_str << "[") : (prnt_str << "(")
    ast.each do | token |
      if token != nil && token != "\u{0020}"
        prnt_str << (pr_str(token, true)) + " "
      end
    end
    prnt_str = prnt_str.rstrip
    vec ? (prnt_str << "]") : (prnt_str << ")")
  when Hash
    keys = ast.keys
    prnt_str << "{ "
    keys.each do | token |
      prnt_str << (pr_str(token, true)) + " " + (pr_str(ast[token], true)) + " "
    end
    prnt_str = prnt_str.rstrip
    prnt_str << " }"

  when Numeric 
    return ast.to_s
  when Symbol
    return ast.to_s
  when NilClass
    return "nil"
  when TrueClass
    return "true"
  when FalseClass
    return "false"
  when String
    if ast.match?(/^\u{0020}/)
      return ast[1..-1]
    elsif print_readably
      return escape(ast)
    else 
      return ast
    end
  end

end

def escape(str)
  minus_quotes = str[1..-2]
  return "\"" + minus_quotes.gsub(/\\/, "\\\\").gsub(/\n/, "\\n").gsub(/\"/, "\\\"") + "\""
end

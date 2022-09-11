def pr_str(ast, print_readably)
  prnt_str = ""
  case ast
  when Array
    prnt_str << "("
    ast.each do | token |
      if token != nil
        prnt_str << (pr_str(token)) + " "
      end
    end
    prnt_str = prnt_str.rstrip
    prnt_str << ")"
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
    if print_readably
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

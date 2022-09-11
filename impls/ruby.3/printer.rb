def pr_str(ast)
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
    return ast
  end

end

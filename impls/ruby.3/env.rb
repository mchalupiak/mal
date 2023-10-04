class Env

  attr_reader :data

  def initialize(outer = nil, binds = nil, exprs = nil)
    @data = Hash.new()
    @outer = outer
    if !binds.nil?
      for i in 0..binds.size-1 do
        if binds[i] == :"&"
          @data[binds[i+1]] = exprs[i..-1]
          break
        else
          @data[binds[i]] = exprs[i]
        end
      end
    end
  end

  def set(symbol, val)
    @data[symbol] = val
  end

  def find(symbol) 
    if @data.key? symbol
      return self
    elsif !@outer.nil?
      @outer.find(symbol)
    else
      return nil
    end
  end

  def get(symbol)
    env = find(symbol)
    return (env.nil? ? (raise KeyError.new("Function #{symbol} not found")) : env.data[symbol])
  end

end

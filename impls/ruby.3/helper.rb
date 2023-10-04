def vecToArr(vec)
  if vec.class != Array
    return vec
  elsif vec[0] == "\u{0020}"
    return (vec[1..-1].map do | x | vecToArr(x) end)
  else
    return (vec.map do | x | vecToArr(x) end)
  end
end

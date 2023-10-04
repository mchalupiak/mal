require "./printer.rb"
require "./helper.rb"

class Namespace

  attr_reader :ns

  def initialize
    @ns = Hash[:+        => lambda {| *x | x.reduce(:+)},
               :-        => lambda {| *x | x.reduce(:-)},
               :*        => lambda {| *x | x.reduce(:*)},
               :/        => lambda {| *x | x.reduce(:/)},
               :prn      => lambda {| *x | puts((x.map {|x| pr_str(x, true)}).join(" ")); nil},
               :list     => lambda {| *x | x},
               :list?    => lambda {| *x | x[0].class == Array && vecToArr(x[0]) == x[0]},
               :empty?   => lambda {| *x | vecToArr(x[0]) == []},
               :count    => lambda {| *x | (x[0].class == Array) ? vecToArr(x[0]).size : 0},
               :"="      => lambda {| *x | vecToArr(x).uniq.count <= 1},
               :"<"      => lambda {| *x | vecToArr(x).sort == vecToArr(x) && vecToArr(x).uniq.count == vecToArr(x).size},
               :"<="     => lambda {| *x | vecToArr(x).sort == vecToArr(x)},
               :">"      => lambda {| *x | vecToArr(x).sort.reverse == vecToArr(x) && vecToArr(x).uniq.count == vecToArr(x).size},
               :">="     => lambda {| *x | vecToArr(x).sort.reverse == vecToArr(x)},
               :"pr-str" => lambda {| *x | (x.map {| x | pr_str(x, true)}).join(" ")},
               :"str"    => lambda {| *x | (x.map {| x | pr_str(x, false)}).join("")},
               :"println"=> lambda {| *x | puts((x.map {|x| pr_str(x, false)}).join(" ")); nil}]
  end

end


class BinomialExpansion
  def initialize(expr)
    @expr = expr
  end

  def self.calculate(expr)
    BinomialExpansion.new(expr).calculate
  end

  def calculate
    initialize_vars
    (0..@n).each do |k|
      calculate_k(k)
    end
    response
  end

  def initialize_vars
    matches = @expr.match(%r{\((-*\d*\w+)([-|+]\d+)\)\^(\d+)})
    
    @a = matches[1].to_i
    
    # NOTE: if is just a one var (x+1) (-n+1)
    if @a.zero?
      @a = matches[1].include?('-') ? -1 : 1
      @a_var = matches[1].sub('-', '')
    else
      @a_var = matches[1].sub(@a.to_s, '')
    end
    
    @b = matches[2].to_i
    @n = matches[3].to_i
    @n_factorial = factorial(@n)
    @results = []
  end

  def calculate_k(k)
    n_minus_k = @n - k
    nk = @n_factorial / (factorial(@n - k) * factorial(k))
    a_pow = @a**n_minus_k
    b_pow = @b**k
    ab = nk * a_pow * b_pow
    @results[k] = ab
  end

  def response
    @results.reverse.each_with_index.reduce("") do |str, (value, index)|
      next str if value.zero?

      first = index.zero?
      last = index == (@results.size - 1)
      pre_str = value >= 0 && !last ? '+' : ''
      
      if first
        pre_str += value.to_s
      else
        pre_str = '-' if value == -1
        pre_str += value.to_s if value != 1 && value != -1
        pre_str += @a_var
        pre_str += "^#{index}" if index > 1
      end
      "#{pre_str}#{str}"
    end
  end

  def factorial(num)
    return 1 if num.zero?

    (1..num).inject(:*) || 1
  end
end

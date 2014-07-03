# encoding: utf-8

class NasaExo

  def initialize(params)
    @year = params[0]
  end

  def what_year
    puts "L'année demandée est: " + @year
  end

end

exo = NasaExo.new(ARGV)

exo.what_year


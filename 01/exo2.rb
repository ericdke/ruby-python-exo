class NasaExo

  def initialize(params)
    @year = params[0]
  end

  def what_year
    # On peut ajouter ici l'année au texte sans faire appel à "to_s" car dans ARGV on n'a pas récupéré le nombre mais une représentation textuelle de ce nombre
    puts "L'année demandée est: " + @year
  end

end

exo = NasaExo.new(ARGV)

exo.what_year


class Saluer
  def dire_bonjour
    puts "Hello World!"
  end
  def dire_au_revoir
    puts "Good bye..."
  end
end
action = Saluer.new
action.dire_bonjour
action.dire_au_revoir

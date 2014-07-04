# _*_ encoding: utf-8 _*_
import sys
mot = sys.argv[1].lower()
if mot == "merci":
    print "Bravo! C'était le mot magique."
elif mot == "wtf":
    print "En effet, ce 'elif' est un peu WTF. Je préfèrerais 'elsif' ou 'else if'..."
else:
    print "Vous avez tapé", mot.upper(), "et puis c'est tout."

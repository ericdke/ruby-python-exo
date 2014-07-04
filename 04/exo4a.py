# _*_ encoding: utf-8 _*_
import sys
mot = sys.argv[1]
longueur = len(mot)
if longueur < 5:
    print "Mot court:",
else:
    print "Mot long:",
print longueur, "lettres"

#Rapport : DM Modèles Linéaires

##Question 1 :
* La dispersion de l’ensemble des transistors est : `0.651919`

##Question 2 :
* La dispersion de l’ensemble des transistors est : `0.789579`
* Les transistors ont été exclus 'valeur = 0' : T29 , T31 , T32 
* La dispersion obtenue est plus grande qu’à la question précédente .

##Question 3 :
* Un critère permettant de minimiser la dispersion des paquets :

1. On assure de extraire 3 paquets par l'ensemble TRANS , par les contraintes suivants: "only_in_one_pack" , "divide_baby" .
2. On minimiser les variables utiliser pour calculer la dispersion : "calculate_max_hfe" , "calculate_max_vbe" ; par chaque paquet.
3. On minimiser la dispersion ; par chaque paquet .

##Question 4 :
* En generale on a extraire 3 paquets par l'ensemble TRANS ; avec deux contraintes une pour verifier que un transistor ne peut etre que dans un paquet et l'autre assurer que l'extraire est fait par égalité card(paquet1)=11, card(paquet2)=11, card(paquet3)=10 . Les critères restent les memes sauf qu'il faut traiter les transistors comme ils sont dans des paquets et pas dans une ensemble .


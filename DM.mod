######
##Q1##
######
reset;

set TRANS; # a partir des donnee il y aura un ensemble TRANS

param MAXHFE >= 0;
param MAXVBE >= 0;
param hfe {TRANS} > 0, <= MAXHFE;
param vbe {TRANS} > 0, <= MAXVBE;
param type {TRANS} symbolic;#dans les indications (symbolic), dans les donnes c'est soit pnp soit npn
var max_hfe;
var min_hfe;
var max_vbe;
var min_vbe;

#comme dans les indications maintenant
subject to restricting_max_hfe {i in TRANS}:
    max_hfe >= hfe[i] #pour le filtrage si on  l'utilise on multiplie par 1 sinon par 0
; 
minimize calculate_max_hfe:
    max_hfe
;
subject to restricting_min_hfe {i in TRANS}:
    min_hfe <= hfe[i]
; 
maximize calculate_min_hfe:
    min_hfe
;

subject to restricting_max_vbe {i in TRANS}:
    max_vbe >= vbe[i]
; 
minimize calculate_max_vbe:
    max_vbe
;
subject to restricting_min_vbe {i in TRANS}:
    min_vbe <= vbe[i]
; 
maximize calculate_min_vbe:
    min_vbe
;

var dispersion;

subject to dispersion_dh:
    dispersion >= (max_hfe - min_hfe)/MAXHFE;
subject to dispersion_vb:
    dispersion >= (max_vbe - min_vbe)/MAXVBE;
minimize calculate_dispersion:
    dispersion
;



data 'transistors-3oct.dat';
solve;
display dispersion;

######
##Q2##
######
reset;

set TRANS; # a partir des donnee il y aura un ensemble TRANS

param E := 4; # le nombre de transistors a exclure

param MAXHFE >= 0;
param MAXVBE >= 0;
param hfe {TRANS} > 0, <= MAXHFE;
param vbe {TRANS} > 0, <= MAXVBE;
param type {TRANS} symbolic;#dans les indications (symbolic), dans les donnes c'est soit pnp soit npn
var max_hfe;
var min_hfe;
var max_vbe;
var min_vbe;

var is_used {TRANS} binary;#si deja utilisee = 1 sinon 0

# en utilisant une boucle for on peut extraire le nombre de transistors
# for {i in TRANS} {
#     nb_trans := nb_trans + 1;
# }

subject to restricting_max_hfe {i in TRANS}:
    is_used[i] * max_hfe >= hfe[i] #pour le filtrage si on  l'utilise on multiplie par 1 sinon par 0
; 
minimize calculate_max_hfe:
    max_hfe
;
subject to restricting_min_hfe {i in TRANS}:
    is_used[i] * min_hfe <= hfe[i]
; 
maximize calculate_min_hfe:
    min_hfe
;

subject to restricting_max_vbe {i in TRANS}:
    is_used[i] * max_vbe >= vbe[i]
; 
minimize calculate_max_vbe:
    max_vbe
;
subject to restricting_min_vbe {i in TRANS}:
    is_used[i] * min_vbe <= vbe[i]
; 
maximize calculate_min_vbe:
    min_vbe
;

var dispersion;

subject to dispersion_dh:
    dispersion >= (max_hfe - min_hfe)/MAXHFE;
subject to dispersion_vb:
    dispersion >= (max_vbe - min_vbe)/MAXVBE;
minimize calculate_dispersion:
    dispersion
;

subject to filter_transistors_used:
    sum {i in TRANS} is_used[i] = card(TRANS) - E;

data 'transistors-3oct.dat';
solve;
display dispersion;

######
##Q3##
######
# Pour distribuer les transistor sur exactement 3 packet on peut soit crer deux variables qui sert comme des points de divisions sur la `set`
# mais dans ce cas il y aura dans chaque packet des transistor succesif, on a choisis la deuxieme solution qui nous permet les distribuer de 
# maniere aleatoire ...

######
##Q4##
######

reset;## oublions l'exclusion

set TRANS; # a partir des donnee il y aura un ensemble TRANS
param P := 3; ## todo define integer ...

set PACKS := 1..P;

var is_filtered {TRANS, PACKS } binary; #if a trans is put in a certain pack this var will have a value of 1

var max_hfe {PACKS};
var min_hfe {PACKS};
var max_vbe {PACKS};
var min_vbe {PACKS};
var dispersion {PACKS};

param MAXHFE >= 0;
param MAXVBE >= 0;
param hfe {TRANS} > 0, <= MAXHFE;
param vbe {TRANS} > 0, <= MAXVBE;
param type {TRANS} symbolic;#dans les indications (symbolic), dans les donnes c'est soit pnp soit npn

var var_hfe {TRANS};

subject to only_in_one_pack {i in TRANS}:# this will make sure that a transistor is put in only one pack
    sum {j in PACKS} is_filtered[i, j] = 1;

subject to divide_baby {j in PACKS}:
    sum {i in TRANS}is_filtered[i, j] >= 10;

#comme dans les indications maintenant
subject to restricting_max_hfe {i in TRANS, j in PACKS}:
    (max_hfe[j]*is_filtered[i, j] - min_hfe[j]*is_filtered[i, j]) >= hfe[i]*is_filtered[i, j] #pour le filtrage si on  l'utilise on multiplie par 1 sinon par 0
;

subject to restricting_max_vbe {i in TRANS, j in PACKS}:
    (max_vbe[j]*is_filtered[i, j] - min_vbe[j]*is_filtered[i, j]) >= vbe[i]*is_filtered[i, j]
; 

subject to dispersion_dh {j in PACKS}:
    dispersion[j] >= (max_hfe[j] - min_hfe[j])/MAXHFE
;
subject to dispersion_vb {j in PACKS}:  
    dispersion[j] >= (max_vbe[j] - min_vbe[j])/MAXVBE
;

minimize calculate_dispersion {j in PACKS}:
    dispersion[j]
;


data 'transistors-3oct.dat';
solve;
display dispersion;


######
##Q5##
######
reset;

set TRANS; 
param P := 3; ## todo define integer ...

set PAIRE dimen 2 within {TRANS, TRANS}; #creer un tableau 2 dim

var is_filtered {TRANS, PAIRE } binary; #if a trans is put in a certain pack this var will have a value of 1

var max_hfe {PAIRE};
var min_hfe {PAIRE};
var max_vbe {PAIRE};
var min_vbe {PAIRE};
var dispersion {PAIRE};

param MAXHFE >= 0;
param MAXVBE >= 0;
param hfe {TRANS} > 0, <= MAXHFE;
param vbe {TRANS} > 0, <= MAXVBE;
param type {TRANS} symbolic;#dans les indications (symbolic), dans les donnes c'est soit pnp soit npn

var var_hfe {TRANS};

subject to only_in_one_pack {i in TRANS}:# this will make sure that a transistor is put in only one pack
    sum {j in PACKS} is_filtered[i, j] = 1;

subject to divide_baby {j in PACKS}:
    sum {i in TRANS}is_filtered[i, j] >= 10;

#comme dans les indications maintenant
subject to restricting_max_hfe {i in TRANS, j in PACKS}:
    (max_hfe[j]*is_filtered[i, j] - min_hfe[j]*is_filtered[i, j]) >= hfe[i]*is_filtered[i, j] #pour le filtrage si on  l'utilise on multiplie par 1 sinon par 0
;

subject to restricting_max_vbe {i in TRANS, j in PACKS}:
    (max_vbe[j]*is_filtered[i, j] - min_vbe[j]*is_filtered[i, j]) >= vbe[i]*is_filtered[i, j]
; 

subject to dispersion_dh {j in PACKS}:
    dispersion[j] >= (max_hfe[j] - min_hfe[j])/MAXHFE
;
subject to dispersion_vb {j in PACKS}:  
    dispersion[j] >= (max_vbe[j] - min_vbe[j])/MAXVBE
;

minimize calculate_dispersion {j in PACKS}:
    dispersion[j]
;


data 'transistors-3oct.dat';
solve;
display dispersion;


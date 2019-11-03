#données
param n ; #nombre d'aérodromes
param d ; #aérodrome de départ
param a ; #aérodrome d'arrivée
param amin ; #nombre minimal d'aérodromes à parcourir
param m ; #nombre de région
param R ; #rayon max
param C{i in 1..n, j in 1..2}; #coordonnées des aérodromes
param di{i in 1..n,j in 1..n} := round(sqrt((C[i,1]-C[j,1])**2 + (C[i,2]-C[j,2])**2));
param M;
#régions de chaque aérodrome
param g{i in 1..n, j in 1..m} ;#matrice binaire des aérodromes/régions
set A  = {i in 1..n,j in 1..n : i !=j and di[i,j] <= R} ; 
set Ad = {i in 1..n : i != d};
set Aa = {i in 1..n : i != a};
#variables
var delta{1..n,1..n} binary;#=1 si on part de i à j =0 sinon
var u{1..n} integer >= 0; #nombres d'aérodromes visités à partir de l'aérodrome d
var x{1..n} binary;#=1 si i est visité = 0 sinon



#objectif
minimize f : sum {(i,j) in A}  di[i,j]*delta[i,j] ;

subject to
c1 {k in 1..m}  : sum {i in 1..n} g[i,k]*x[i] >= 1 ; #chaque région doit être visitée
c2 : sum {i in 1..n}  x[i] >= amin ; #il doit visiter amin aérodrome au moins
c3 {i in Aa} : sum {j in 1..n : (i,j) in A} delta[i,j] = x[i];
c4 {i in Ad} : sum {j in 1..n : (j,i) in A} delta[j,i] = x[i];
c5 {i in 1..n : (i,d) in A} : delta[i,d] = 0;
c6 {j in 1..n : (a,j) in A} : delta[a,j] = 0;
c7 {(i,j) in A} : u[j] >= u[i] + 1 - M*(1 - delta[i,j]);
c8 {i in 1..n} :    u[i] <= n*x[i];
c9 : u[d] = 1;
c10 : u[a] = sum {j in 1..n}  x[j];







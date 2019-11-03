

#données

param n ; #nombre d'aérodromes
param d ; #aérodrome de départ
param a ; #aérodrome d'arrivée
param amin ; #nombre minimal d'aérodromes à parcourir
param m ; #nombre de région
param R ; #rayon max
param C{i in 1..n, j in 1..2}; #coordonnées des aérodromes
param M;
param dist{i in 1..n, j in 1..n} := round(sqrt((C[i,1]-C[j,1])**2 + (C[i,2]-C[j,2])**2) );
#régions de chaque aérodrome
param g{i in 1..n, j in 1..m} ;
set A  = {i in 1..n,j in 1..n : i != j and dist[i,j] <= R} ; 
set Ad = {i in 1..n : i != d};
set Aa = {i in 1..n : i != a};

# ----------------------------------------
# le problème Maître
# ----------------------------------------
var delta{1..n,1..n} binary;#=1 si on part de i à j =0 sinon
var x{1..n} binary;#=1 si i est visité = 0 sinon




#objectif
minimize f : sum {(i,j) in A}  dist[i,j]*delta[i,j] ;

subject to
c1 {k in 1..m}  : sum {i in 1..n} g[i,k]*x[i] >= 1 ; #chaque région doit être visitée
c2 : sum {i in 1..n}  x[i] >= amin ; #il doit visiter amin aérodrome au moins
c3 {i in Aa} : sum {j in 1..n : (i,j) in A} delta[i,j] = x[i];
c4 {i in Ad} : sum {j in 1..n : (j,i) in A} delta[j,i] = x[i];
c5 {i in 1..n : (i,d) in A} : delta[i,d] = 0;
c6 {j in 1..n : (a,j) in A} : delta[a,j] = 0;
c7 : delta[d,a]=0;
c8 : x[d]=1;
c9 : x[a]=1;

# ----------------------------------------
param nSous_tours >= 0 integer;
param z>= 0 integer;
set S {1..nSous_tours} within 1..n;

subject to c {k in 1..nSous_tours}:
   sum {i in S[k], j in S[k]} delta[i,j] <= card(S[k])-1;

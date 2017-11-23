%
% Contient certains predicats generaux utiles ailleurs
%

supprime(_,[],[]).
supprime(X,[X|B],S) :- supprime(X,B,S), !.
supprime(X,[Y|B],[Y|S]) :- supprime(X,B,S).
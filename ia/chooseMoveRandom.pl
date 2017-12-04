%
% IA pour le choix du mouvement a effectuer avec la piece donnee par l'adversaire
%
chooseMoveRandom(BoardSize, Move) :-
  repeat,
  Index is random(16), nth0(Index, BoardSize, Elem),
  var(Elem),
  Move is Index.

%
% IA pour le choix d'une piece pour l'adversaire
%

iaChoosePiece(Piece,RemainingPieces) :-
  length(RemainingPieces, NumberPieces),
  random(1, NumberPieces, IndexPiece),
  % pick a piece
  nth0(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)), assert(remainingPieces(NewRemainingPieces)).

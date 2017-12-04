% Method to pick a random piece

% Case where there is only one remaining piece
chooseRandomPiece(Piece,RemainingPieces):-
  length(RemainingPieces, NumberPieces),
  NumberPieces is 1,
  IndexPiece is 1,
  nth1(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)), !.
% Default case
chooseRandomPiece(Piece,RemainingPieces):-
  length(RemainingPieces, NumberPieces),
  random(1, NumberPieces, IndexPiece),
  nth1(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)).

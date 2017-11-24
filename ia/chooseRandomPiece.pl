% Method to pick a random piece
chooseRandomPiece(Piece,RemainingPieces):-
  length(RemainingPieces, NumberPieces),
  random(1, NumberPieces, IndexPiece),
  % pick a piece
  nth0(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)).

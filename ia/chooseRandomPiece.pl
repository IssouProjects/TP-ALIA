% Method to pick a random piece
chooseRandomPiece(Piece,RemainingPieces):-
  length(RemainingPieces, NumberPieces),
  NumberPieces is 1,
  IndexPiece is 1,
  % pick a piece
  nth1(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)), !.

chooseRandomPiece(Piece,RemainingPieces):-
  length(RemainingPieces, NumberPieces),
  random(1, NumberPieces, IndexPiece),
  % pick a piece
  nth1(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)).



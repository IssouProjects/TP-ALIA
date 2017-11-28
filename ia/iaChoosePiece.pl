
%Check if the other player can win with this Piece
winWithThisPiece(Piece, BoardSize, BoardShape, BoardHole, BoardColor):-
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, _, Piece,
  NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  win(NewBoardSize,NewBoardHole,NewBoardColor,NewBoardShape).

% IA pour le choix d'une piece pour l'adversaire
iaChoosePiece(Piece,RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor) :-
  nth0(_, RemainingPieces, Piece),
  \+winWithThisPiece(Piece, BoardSize, BoardShape, BoardHole, BoardColor),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)), !.

% If we can only loose, we pick a random Piece
iaChoosePiece(Piece,RemainingPieces,_,_,_,_):- chooseRandomPiece(Piece, RemainingPieces).

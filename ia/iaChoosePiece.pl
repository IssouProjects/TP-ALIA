%Check if the other player can't win with this Piece
cantWinWithThisPiece(_,0):-false.
cantWinWithThisPiece(Piece, N):-
  cantWinWithThisPiece(Piece, M),
  nth0(M, BoardHole, Elem),
  var(Elem),
  N is M+1,
  Move is M,
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece,
  NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  \+ win(NewBoardSize,NewBoardHole,NewBoardColor,NewBoardShape).

% If we can only loose, we pick a random Piece
iaChoosePiece(Piece,RemainingPieces, 0):-chooseARandomPiece(Piece,RemainingPieces).
% IA pour le choix d'une piece pour l'adversaire
iaChoosePiece(Piece,RemainingPieces,NumberPieces) :-
  NumberPieces is N+1,
  iaChoosePiece(Piece, RemainingPieces,N),
  nth0(NumberPieces, RemainingPieces, Piece),
  cantWinWithThisPiece(Piece, 16),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)), assert(remainingPieces(NewRemainingPieces)).

chooseARandomPiece(Piece,RemainingPieces):-
  length(RemainingPieces, NumberPieces),
  random(1, NumberPieces, IndexPiece),
  % pick a piece
  nth0(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)), assert(remainingPieces(NewRemainingPieces)).

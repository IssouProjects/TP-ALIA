% Import
%:- consult(player).

%Check if the other player can't win with this Piece
cantWinWithThisPiece(_,0,_,_,_,_):-false.
cantWinWithThisPiece(Piece, N, BoardSize, BoardShape, BoardHole, BoardColor):-
  M is N-1,
  writeln(M),
  Move is M,
  cantWinWithThisPiece(Piece, M, BoardSize, BoardShape, BoardHole, BoardColor),
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece,
  NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  \+ win(NewBoardSize,NewBoardHole,NewBoardColor,NewBoardShape),
  writeln("He can't win with this piece").

% IA pour le choix d'une piece pour l'adversaire
iaChoosePiece(Piece,RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor) :-
  nth0(_, RemainingPieces, Piece),
  cantWinWithThisPiece(Piece, 16, BoardSize, BoardShape, BoardHole, BoardColor),
  !,
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)).

% If we can only loose, we pick a random Piece
iaChoosePiece(Piece,RemainingPieces,_,_,_,_):-
  length(RemainingPieces, NumberPieces),
  random(1, NumberPieces, IndexPiece),
  % pick a piece
  nth0(IndexPiece, RemainingPieces, Piece),
  supprime(Piece,RemainingPieces, NewRemainingPieces),
  retract(remainingPieces(RemainingPieces)),
  assert(remainingPieces(NewRemainingPieces)).

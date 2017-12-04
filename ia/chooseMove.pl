
chooseMove(Piece, Move) :-testMoves(Piece, Move).
chooseMove(_, Move) :- writeln('Play a random move.'),
  repeat,
  Index is random(16), boardSize(BoardSize),
  nth0(Index, BoardSize, Elem), var(Elem), Move is Index.

testMoves(Piece,Move) :-
  between(0,15,X),
  nth0(X, BoardSize, Elem), var(Elem), Move is X,
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole),
  boardColor(BoardColor),
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece,
           NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  winTest(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor).

% Check if the game is won
winTest(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor):-
  (winBoard(NewBoardSize); winBoard(NewBoardShape); winBoard(NewBoardHole);
   winBoard(NewBoardColor)).

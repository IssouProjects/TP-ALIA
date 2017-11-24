

%testMoves(Piece, Move, Index) :- nth0(Index, BoardSize, Elem), var(Elem).
%:- Index is 0
%testMoves(Piece, TempMove, Index) :- repeat, var(Elem), nth0(Index, BoardSize, Elem), var(Elem), TempMove is Index, .


iaChooseMove2(Piece, Move) :-testMoves(Piece, Move).
iaChooseMove2(_, Move) :- writeln('Play a random move.'), repeat, Index is random(16), boardSize(BoardSize), nth0(Index, BoardSize, Elem), var(Elem), Move is Index.


testMoves(Piece,Move) :-
  between(0,15,X),
  nth0(X, BoardSize, Elem), var(Elem), Move is X,
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor),
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  winTest(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor).

% Check if the game is won
winTest(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor):- (winBoard(NewBoardSize); winBoard(NewBoardShape); winBoard(NewBoardHole); winBoard(NewBoardColor)).

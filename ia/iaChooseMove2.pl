

%testMoves(Piece, Move, Index) :- nth0(Index, BoardSize, Elem), var(Elem).
%:- Index is 0
%testMoves(Piece, TempMove, Index) :- repeat, var(Elem), nth0(Index, BoardSize, Elem), var(Elem), TempMove is Index, .


iaChooseMove2(Piece, Move) :- boardSize(BoardSize), testMoves(BoardSize, Piece, Move).
iaChooseMove2(_, Move) :- writeln('here'), repeat, Index is random(16), boardSize(BoardSize), nth0(Index, BoardSize, Elem), var(Elem), Move is Index.


testMoves([],_,_):- writeln('here2').
testMoves([X|B],Piece,Move) :-
  nth0(X, BoardSize, Elem), var(Elem), Move is X,
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor),
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  write('Move tested '), writeln(Move),
  displayBoard(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  winTest(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  testMoves(B, Piece, Move).

% Check if the game is won
winTest(NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor):- (winBoard(NewBoardSize); winBoard(NewBoardShape); winBoard(NewBoardHole); winBoard(NewBoardColor)).

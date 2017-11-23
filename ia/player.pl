%
% Ensemble des actions a entreprendre apres le choix du coup a jouer
%

playMoveBoard(Board,Move,Piece,NewBoard) :- Board=NewBoard, nth0(Move,NewBoard,Piece).

playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor) :-
  nth0(0, Piece, Size),
  nth0(1, Piece, Shape),
  nth0(2, Piece, Color),
  nth0(3, Piece, Hole),
  playMoveBoard(BoardSize,Move,Size,NewBoardSize), % Play the move and get the result in a new Board
  playMoveBoard(BoardShape,Move,Shape,NewBoardShape), % Play the move and get the result in a new Board
  playMoveBoard(BoardHole,Move,Hole,NewBoardHole), % Play the move and get the result in a new Board
  playMoveBoard(BoardColor,Move,Color,NewBoardColor). % Play the move and get the result in a new Board

applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor) :- % Remove the old board from the KB and store the new one
  retract(boardSize(BoardSize)), assert(boardSize(NewBoardSize)), % Remove the old board from the KB and store the new one
  retract(boardShape(BoardShape)), assert(boardShape(NewBoardShape)), % Remove the old board from the KB and store the new one
  retract(boardHole(BoardHole)), assert(boardHole(NewBoardHole)), % Remove the old board from the KB and store the new one
  retract(boardColor(BoardColor)), assert(boardColor(NewBoardColor)).
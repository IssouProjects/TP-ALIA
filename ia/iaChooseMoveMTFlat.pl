% run randoms test for each move possibility and pick the best one

% saved states
:- dynamic boardSizeSS/1.
:- dynamic boardShapeSS/1.
:- dynamic boardColorSS/1.
:- dynamic boardHoleSS/1.
:- dynamic remainingPiecesSS/1.

iaChooseMoveMTFlat(Piece, Move, Win).

iaChooseMoveMTFlat(Piece, Move, Player) :- length(MoveGrades, 16), runTests(MoveGrades, Piece, Player)

runTests(MoveGrades, Piece, Player):- 
  between(0,15,I),
  testMove(MoveGrades, I, Piece),

testMoves(MoveGrades, Move, Piece, Player):- 
  nth0(Move, BoardSize, Elem), var(Elem), % check if empty case
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  testMove(Move, Piece, Player, 0, _, 0, _, X),
  nth0(Move, MoveGrades, X),
  writeln(X).

testMove(Move, Piece, Player, 100, newI, OldCount, NewCount, FinalCount) FinalCount is OldCount.
testMove(Move, Piece, Player, I, NewI, OldCount, NewCount) :-
  NewI is I+1,
  saveStates(),
  CurrentPlayer = Player,
  randomEndGame(CurrentPlayer, DidWeWin, Player),
  NewCount is OldCount + DidWeWin,
  restoreStates(),
  testMove(Move, Piece, Player, NewI, _, NewCount, _).


Increment(Move, MoveGrades, DidWeWin):-
  nth0(Move, MoveGrades, X),
  var(X),
  X is 0,
  Increment(Move, MoveGrades, DidWeWin).

Increment(Move, MoveGrades, DidWeWin):-
  nth0(Move, MoveGrades, X)

randomEndGame(Player, 1, OriginalPlayer):- gameoverMTFlat(), Player is OriginalPlayer.  
randomEndGame(Player, 0, OriginalPlayer):- gameoverMTFlat(), not(Player is OriginalPlayer).  
randomEndGame(Player, DidWeWin, OriginalPlayer) :-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    iaChoosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
    changePlayer(Player, NextPlayer), % change to the player that will place the spiece
    iaChooseMove(Piece, Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    randomEndGame(NextPlayer, DidWeWin). % next turn!
                                    
gameoverMTFlat() :- 
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces), 
  win(BoardSize,BoardHole,BoardColor,BoardShape), !.
gameoverMTFlat() :- boardShape(BoardShape), isBoardFull(BoardShape).

saveStates() :-
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  BoardSizeSS = BoardSize,
  BoardShapeSS = BoardShape,
  BoardHoleSS = BoardHole,
  BoardColorSS = BoardColor,
  RemainingPiecesSS = RemainingPieces,
  assert(boardSizeSS(BoardSizeSS)),
  assert(boardShapeSS(BoardShapeSS)),
  assert(boardColorSS(BoardHoleSS)),
  assert(boardHoleSS(BoardColorSS)),
  assert(remainingPiecesSS(RemainingPiecesSS)).


restoreStates() :-
  boardSizeSS(BoardSizeSS), boardShapeSS(BoardShapeSS), boardHoleSS(BoardHoleSS), boardColorSS(BoardColorSS), remainingPiecesSS(RemainingPiecesSS),
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  BoardSize = BoardSizeSS,
  BoardShape = BoardShapeSS,
  BoardHole = BoardHoleSS,
  BoardColor = BoardColorSS,
  RemainingPieces = RemainingPiecesSS,
  retract(boardSizeSS(BoardSizeSS)),
  retract(boardShapeSS(BoardShapeSS)),
  retract(boardColorSS(BoardHoleSS)),
  retract(boardHoleSS(BoardColorSS)),
  retract(remainingPiecesSS(RemainingPiecesSS)),
  retract(boardSize(BoardSize)), assert(boardSize(NewBoardSize)), % Remove the old board from the KB and store the new one
  retract(boardShape(BoardShape)), assert(boardShape(NewBoardShape)), % Remove the old board from the KB and store the new one
  retract(boardHole(BoardHole)), assert(boardHole(NewBoardHole)), % Remove the old board from the KB and store the new one
  retract(boardColor(BoardColor)), assert(boardColor(NewBoardColor)).


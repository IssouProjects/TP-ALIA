% run randoms test for each move possibility and pick the best one

% saved states
:- dynamic boardSizeSS/1.
:- dynamic boardShapeSS/1.
:- dynamic boardColorSS/1.
:- dynamic boardHoleSS/1.
:- dynamic remainingPiecesSS/1.

% major saved state
:- dynamic boardSizeSS2/1.
:- dynamic boardShapeSS2/1.
:- dynamic boardColorSS2/1.
:- dynamic boardHoleSS2/1.
:- dynamic remainingPiecesSS2/1.

iaChooseMoveMTFlat(Piece, Move, Player) :- length(MoveGrades, 16), runTests(MoveGrades, Piece, Player), findOptimal(MoveGrades, Move).

findOptimal(MoveGrades, Move) :- findOptimal(MoveGrades, 0, 0, Move, -1).
findOptimal([], FinalMove, _, FinalMove, _).
findOptimal([X|MoveGrades], _, Max, FinalMove, I):-
    N is I+1,
    nonvar(X),
    X > Max,
    findOptimal(MoveGrades, N, X, FinalMove, N).
findOptimal([_|MoveGrades], Move, Max, FinalMove, I):-
    N is I+1,
    findOptimal(MoveGrades, Move, Max, FinalMove, N).


runTests(MoveGrades, Piece, Player):- runTests(MoveGrades, Piece, Player, 0).
runTests(MoveGrades, Piece, Player, 16).
runTests(MoveGrades, Piece, Player, I):- 
  N is I+1,
  saveStates2(),
  write("TESTING CASE: "),
  writeln(I),
  testMovesMCF(MoveGrades, I, Piece, Player),
  writeln("FINISHED: "),
  writeln(I),
  restoreStates2(),
  runTests(MoveGrades, Piece, Player, N).


testMovesMCF(MoveGrades, Move, Piece, Player):- 
  nth0(Move, BoardSize, Elem), var(Elem), % check if empty case
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  testMoveMCF(Move, Piece, Player, X),
  nth0(Move, MoveGrades, X).
  

testMoveMCF(Move, Piece, Player, FinalCount):- testMoveMCF(Move, Piece, Player, 0, 0, FinalCount), !.
testMoveMCF(_, _, _, 100, FinalCount, FinalCount):- writeln("100 DONE"), !.
testMoveMCF(Move, Piece, Player, I, Count, FinalCount) :-
  NewI is I+1,
  saveStates(),
  CurrentPlayer = Player,
  randomEndGame(CurrentPlayer, DidWeWin, Player),
  NewCount is Count + DidWeWin,
  restoreStates(),
  
  testMoveMCF(Move, Piece, Player, NewI, NewCount, FinalCount).

randomEndGame(Player, 1, OriginalPlayer):- Player is OriginalPlayer, gameoverMTFlat().
randomEndGame(Player, 0, OriginalPlayer):- not(Player is OriginalPlayer),gameoverMTFlat(). 
randomEndGame(Player, DidWeWin, OriginalPlayer) :-
    writeln("randomEndGame"),
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    displayBoard(BoardSize, BoardShape, BoardHole, BoardColor),
    iaChoosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
    changePlayer(Player, NextPlayer), % change to the player that will place the spiece
    iaChooseMove(BoardSize, Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    
    randomEndGame(NextPlayer, DidWeWin, OriginalPlayer). % next turn!
                                    
gameoverMTFlat() :- 
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), 
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
  retract(boardSize(BoardSize)), assert(boardSize(BoardSizeSS)), % Remove the old board from the KB and store the new one
  retract(boardShape(BoardShape)), assert(boardShape(BoardShapeSS)), % Remove the old board from the KB and store the new one
  retract(boardHole(BoardHole)), assert(boardHole(BoardHoleSS)), % Remove the old board from the KB and store the new one
  retract(boardColor(BoardColor)), assert(boardColor(BoardColorSS)),
  retract(remainingPieces(RemainingPieces)), assert(remainingPieces(RemainingPiecesSS)),
  retract(boardSizeSS(BoardSizeSS)),
  retract(boardShapeSS(BoardShapeSS)),
  retract(boardColorSS(BoardHoleSS)),
  retract(boardHoleSS(BoardColorSS)),
  retract(remainingPiecesSS(RemainingPiecesSS)).

saveStates2() :-
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  BoardSizeSS = BoardSize,
  BoardShapeSS = BoardShape,
  BoardHoleSS = BoardHole,
  BoardColorSS = BoardColor,
  RemainingPiecesSS = RemainingPieces,
  assert(boardSizeSS2(BoardSizeSS)),
  assert(boardShapeSS2(BoardShapeSS)),
  assert(boardColorSS2(BoardHoleSS)),
  assert(boardHoleSS2(BoardColorSS)),
  assert(remainingPiecesSS2(RemainingPiecesSS)).


restoreStates2() :-
  boardSizeSS2(BoardSizeSS), boardShapeSS2(BoardShapeSS), boardHoleSS2(BoardHoleSS), boardColorSS2(BoardColorSS), remainingPiecesSS2(RemainingPiecesSS),
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  retract(boardSize(BoardSize)), assert(boardSize(BoardSizeSS)), % Remove the old board from the KB and store the new one
  retract(boardShape(BoardShape)), assert(boardShape(BoardShapeSS)), % Remove the old board from the KB and store the new one
  retract(boardHole(BoardHole)), assert(boardHole(BoardHoleSS)), % Remove the old board from the KB and store the new one
  retract(boardColor(BoardColor)), assert(boardColor(BoardColorSS)),
  retract(remainingPieces(RemainingPieces)), assert(remainingPieces(RemainingPiecesSS)),
  retract(boardSizeSS2(BoardSizeSS)),
  retract(boardShapeSS2(BoardShapeSS)),
  retract(boardColorSS2(BoardHoleSS)),
  retract(boardHoleSS2(BoardColorSS)),
  retract(remainingPiecesSS2(RemainingPiecesSS)).


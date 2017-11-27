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

iaChooseMoveMTFlat(Piece, Move, Player) :- 
  length(MoveGrades, 16),
  runTests(MoveGrades, Piece, Player),
  findOptimal(MoveGrades, Move), !.

findOptimal(MoveGrades, Move) :- findOptimal(MoveGrades, 0, 0, Move, -1).
findOptimal([], FinalMove, _, FinalMove, _).
findOptimal([X|MoveGrades], _, Max, FinalMove, I):-
    N is I+1,
    nonvar(X),
    write(N),
    write(" - "),
    writeln(X),
    X > Max,
    findOptimal(MoveGrades, N, X, FinalMove, N).
findOptimal([_|MoveGrades], Move, Max, FinalMove, I):-
    N is I+1,
    findOptimal(MoveGrades, Move, Max, FinalMove, N).


runTests(MoveGrades, Piece, Player):- runTests(MoveGrades, Piece, Player, 0).
runTests(_, _, _, 16).
runTests(MoveGrades, Piece, Player, I):- 
  N is I+1,
  saveStates2,
  testMovesMCF(MoveGrades, I, Piece, Player),
  restoreStates2,
  runTests(MoveGrades, Piece, Player, N).


testMovesMCF(MoveGrades, Move, _, _):- 
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor),
  nth0(Move, BoardSize, Elem), nonvar(Elem), % check if empty case
  nth0(Move, MoveGrades, 0).

testMovesMCF(MoveGrades, Move, Piece, Player):- 
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor),
  nth0(Move, BoardSize, Elem), var(Elem), % check if empty case
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  testMoveMCF(Move, Piece, Player, X),
  nth0(Move, MoveGrades, X).
  

testMoveMCF(Move, Piece, Player, FinalCount):- testMoveMCF(Move, Piece, Player, 0, 0, FinalCount), !.
testMoveMCF(_, _, _, 10, FinalCount, FinalCount).
testMoveMCF(Move, Piece, Player, I, Count, FinalCount) :-
  NewI is I+1,
  saveStates,
  CurrentPlayer = Player,
  randomEndGame(CurrentPlayer, DidWeWin, Player),
  NewCount is Count + DidWeWin,
  restoreStates,
  testMoveMCF(Move, Piece, Player, NewI, NewCount, FinalCount).

randomEndGame(Player, 1, OriginalPlayer):- Player is OriginalPlayer, gameoverMTFlat, !.
randomEndGame(Player, 0, OriginalPlayer):- not(Player is OriginalPlayer), gameoverMTFlat, !. 
randomEndGame(Player, DidWeWin, OriginalPlayer) :-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    %displayBoard(BoardSize, BoardShape, BoardHole, BoardColor),
    iaChoosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
    changePlayer(Player, NextPlayer), % change to the player that will place the spiece
    iaChooseMove(BoardSize, Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    randomEndGame(NextPlayer, DidWeWin, OriginalPlayer). % next turn!
                                    
gameoverMTFlat :- boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), 
  win(BoardSize,BoardHole,BoardColor,BoardShape).
gameoverMTFlat :- boardShape(BoardShape),isBoardFull(BoardShape).

saveStates :-
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  BoardSizeSS = BoardSize,
  BoardShapeSS = BoardShape,
  BoardHoleSS = BoardHole,
  BoardColorSS = BoardColor,
  RemainingPiecesSS = RemainingPieces,
  assert(boardSizeSS(BoardSizeSS)),
  assert(boardShapeSS(BoardShapeSS)),
  assert(boardHoleSS(BoardHoleSS)),
  assert(boardColorSS(BoardColorSS)),
  assert(remainingPiecesSS(RemainingPiecesSS)).


restoreStates :-
  boardSizeSS(BoardSizeSS), boardShapeSS(BoardShapeSS), boardHoleSS(BoardHoleSS), boardColorSS(BoardColorSS), remainingPiecesSS(RemainingPiecesSS),
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  retract(boardSize(BoardSize)), assert(boardSize(BoardSizeSS)), % Remove the old board from the KB and store the new one
  retract(boardShape(BoardShape)), assert(boardShape(BoardShapeSS)), % Remove the old board from the KB and store the new one
  retract(boardHole(BoardHole)), assert(boardHole(BoardHoleSS)), % Remove the old board from the KB and store the new one
  retract(boardColor(BoardColor)), assert(boardColor(BoardColorSS)),
  retract(remainingPieces(RemainingPieces)), assert(remainingPieces(RemainingPiecesSS)),
  retract(boardSizeSS(BoardSizeSS)),
  retract(boardShapeSS(BoardShapeSS)),
  retract(boardHoleSS(BoardHoleSS)),
  retract(boardColorSS(BoardColorSS)),
  retract(remainingPiecesSS(RemainingPiecesSS)).

saveStates2 :-
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  BoardSizeSS2 = BoardSize,
  BoardShapeSS2 = BoardShape,
  BoardHoleSS2 = BoardHole,
  BoardColorSS2 = BoardColor,
  RemainingPiecesSS2 = RemainingPieces,
  assert(boardSizeSS2(BoardSizeSS2)),
  assert(boardShapeSS2(BoardShapeSS2)),
  assert(boardHoleSS2(BoardHoleSS2)),
  assert(boardColorSS2(BoardColorSS2)),
  assert(remainingPiecesSS2(RemainingPiecesSS2)).


restoreStates2 :-
  boardSizeSS2(BoardSizeSS2), boardShapeSS2(BoardShapeSS2), boardHoleSS2(BoardHoleSS2), boardColorSS2(BoardColorSS2), remainingPiecesSS2(RemainingPiecesSS2),
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
  retract(boardSize(BoardSize)),              assert(boardSize(BoardSizeSS2)), % Remove the old board from the KB and store the new one
  retract(boardShape(BoardShape)),            assert(boardShape(BoardShapeSS2)), % Remove the old board from the KB and store the new one
  retract(boardHole(BoardHole)),              assert(boardHole(BoardHoleSS2)), % Remove the old board from the KB and store the new one
  retract(boardColor(BoardColor)),            assert(boardColor(BoardColorSS2)),           
  retract(remainingPieces(RemainingPieces)),  assert(remainingPieces(RemainingPiecesSS2)),
  retract(boardSizeSS2(BoardSizeSS2)),
  retract(boardShapeSS2(BoardShapeSS2)),
  retract(boardHoleSS2(BoardHoleSS2)),
  retract(boardColorSS2(BoardColorSS2)),
  retract(remainingPiecesSS2(RemainingPiecesSS2)).


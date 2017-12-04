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

% iaChooseMoveMCFlat(Piece, Move, Player) : Move is the optimal move for the Piece, if we want Player to win
chooseMoveMCFlat(Piece, Move, Player) :-
  length(MoveGrades, 16),              % We store here the number of victories for each Move
  runTests(MoveGrades, Piece, Player),
  findOptimal(MoveGrades, Move), !.    % We select the most victorious move


% findOptimal(MoveGrades, Move) : Move is the Index of the maximal value stored in the list MoveGrades
%
% Algo : go through all the list to find its max value, updating the index and the max along the way
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

% runTests(MoveGrades, Piece, Player) : MoveGrades contains the number of Player victories for each possible move (0 to 16)
%                                       with the Piece.
% Algo : runs all tests for the 16 moves
runTests(MoveGrades, Piece, Player):- runTests(MoveGrades, Piece, Player, 0).
runTests(_, _, _, 16).
runTests(MoveGrades, Piece, Player, I):-
  N is I+1,
  saveStates2,
  testMovesMCF(MoveGrades, I, Piece, Player),
  restoreStates2,
  runTests(MoveGrades, Piece, Player, N).

% testMovesMCF(MoveGrades, Move, Piece, Player) : MoveGrades contains the number of Player victories for each possible move (0 to 16)
%
% Algo : play a Move and run random games on the updated board, save the number of victories in MoveGrades
testMovesMCF(MoveGrades, Move, _, _):-
  boardSize(BoardSize),
  nth0(Move, BoardSize, Elem), nonvar(Elem), % check if empty case
  nth0(Move, MoveGrades, 0).

testMovesMCF(MoveGrades, Move, Piece, Player):-
  boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor),
  nth0(Move, BoardSize, Elem), var(Elem), % check if empty case
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  testMoveMCF(Move, Piece, Player, X),
  nth0(Move, MoveGrades, X).

% testMoveMCF(Move, Piece, Player, Count) : Count contains the number of victories out of the 10 randoms games played
%
% Algo : run random games on the board and keep track of the number of victories.
testMoveMCF(Move, Piece, Player, Count):- testMoveMCF(Move, Piece, Player, 0, 0, Count), !.
testMoveMCF(_, _, _, 10, FinalCount, FinalCount).
testMoveMCF(Move, Piece, Player, I, Count, FinalCount) :-
  NewI is I+1,
  saveStates,
  CurrentPlayer = Player,
  randomEndGame(CurrentPlayer, DidWeWin, Player),
  NewCount is Count + DidWeWin,
  restoreStates,
  testMoveMCF(Move, Piece, Player, NewI, NewCount, FinalCount).

% randomEndGame(Player, DidWeWin, OriginalPlayer) : finish a game and tells us the winner. DidWeWin = 1 if OriginalPlayer won,
%                                                   DidWeWin = 0 if OriginalPlayer loses.
% Algo : each player plays, one after another, till the game ends.
randomEndGame(Player, 1, OriginalPlayer):- Player is OriginalPlayer, gameoverMTFlat, !.
randomEndGame(Player, 0, OriginalPlayer):- not(Player is OriginalPlayer), gameoverMTFlat, !.
randomEndGame(Player, DidWeWin, OriginalPlayer) :-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    %displayBoard(BoardSize, BoardShape, BoardHole, BoardColor),
    choosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
    changePlayer(Player, NextPlayer), % change to the player that will place the spiece
    chooseMove(BoardSize, Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    randomEndGame(NextPlayer, DidWeWin, OriginalPlayer). % next turn!

% gameoverMTFlat : is true if the game is over
%
% Algo : check if one player won the game or if the board is full
gameoverMTFlat :- boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor),
  win(BoardSize,BoardHole,BoardColor,BoardShape).
gameoverMTFlat :- boardShape(BoardShape),isBoardFull(BoardShape).

% saveStates : saves the state of the Board
%
% Algo : save all the Boards____ in Board____SS
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

% restoreStates : restores the previously saved state of the board
%
% Algo : restore all the Boards____ from Board____SS
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

% saveStates2 : saves the state of the board (in another variable)
%
% Algo : save all the Boards____ in Board____SS2
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

% restoreStates : restores the previously saved state of the board
%
% Algo : restore all the Boards____ from Board____SS2
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

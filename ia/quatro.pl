%
% Contient le main et le deroulement d'une partie
%

:- consult(init).
:- consult(iaChoosePiece).
:- consult(chooseRandomPiece).
:- consult(iaChooseMove).
:- consult(iaChooseMove2).
:- consult(display).
:- consult(end).
:- consult(player).
:- consult(util).
:- consult(iaChooseMoveMTFlat).
:- consult(minimax2).
:- consult(eval).

:- dynamic boardSize/1.
:- dynamic boardShape/1.
:- dynamic boardColor/1.
:- dynamic boardHole/1.

:- dynamic remainingPieces/1.

reset():- halt, retract(boardSize(_)), retract(boardColor(_)), retract(boardShape(_)), retract(boardHole(_)), retract(remainingPieces(_)).
%TODO Le cas ou le board est plein et il n'y a pas de gagnant n'est pas pris en compte.
play(Player):- gameover(), write('Game is Over. Winner: '), writeln(Player),boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), reset().

% Player 0 thinks a lot
% PLayer 1 thinks a little
play(0):-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), % print it
    iaChoosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
    write(0), write(' choosed a piece for its opponent:'), writeln(Piece),
    iaChooseMove(BoardSize, Move),
    %iaChooseMove2(Piece, Move),
    write(1), write( ' played the piece like a cuck:'), write(Piece), write(' in '), writeln(Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    play(1). % next turn!


play(1):-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), % print it
    iaChoosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
    write(1), write(' choosed a piece for its opponent:'), writeln(Piece),
    iaChooseMoveMinimax(Piece, Move, 1),
    write(0), write( ' played the piece like a chad:'), write(Piece), write(' in '), writeln(Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    play(0). % next turn!

changePlayer(0,1).
changePlayer(1,0).

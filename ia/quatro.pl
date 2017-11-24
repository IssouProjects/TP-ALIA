%
% Contient le main et le deroulement d'une partie
%

:- consult(init).
:- consult(iaChoosePiece).
:- consult(iaChooseMove).
:- consult(iaChooseMove2).
:- consult(display).
:- consult(end).
:- consult(player).
:- consult(util).

:- dynamic boardSize/1.
:- dynamic boardShape/1.
:- dynamic boardColor/1.
:- dynamic boardHole/1.

:- dynamic remainingPieces/1.

reset():- retract(boardSize(_)), retract(boardColor(_)), retract(boardShape(_)), retract(boardHole(_)), retract(remainingPieces(_)).

play(Player):- gameover(), write('Game is Over. Winner: '), writeln(Player),boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), reset().
play(Player):-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), % print it
    write(Player), writeln(' choose a piece for your opponent:'),
    iaChoosePiece(Piece, RemainingPieces), % ask the AI to choose a piece for the opponnent
    changePlayer(Player, NextPlayer), % change to the player that will place the spiece
    write(NextPlayer), writeln( ' play the piece:'),
    %iaChooseMove(BoardSize, Move),
    iaChooseMove2(Piece, Move),
    write(NextPlayer), write( ' played the piece:'), write(Piece), write(' in '), writeln(Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    play(NextPlayer). % next turn!

changePlayer(0,1).
changePlayer(1,0).

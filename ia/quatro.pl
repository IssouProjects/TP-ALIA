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

:- dynamic boardSize/1.
:- dynamic boardShape/1.
:- dynamic boardColor/1.
:- dynamic boardHole/1.

:- dynamic remainingPieces/1.

reset():- retract(boardSize(_)), retract(boardColor(_)), retract(boardShape(_)), retract(boardHole(_)), retract(remainingPieces(_)).
%TODO Le cas ou le board est plein et il n'y a pas de gagnant n'est pas pris en compte.
play(Over) :-  gameover(), boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), reset().

% Player 0 thinks a little
% PLayer 1 is dumb
play(0, PieceStr, Move):-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    iaChoosePiece(Piece, RemainingPieces, BoardSize, BoardShape, BoardHole, BoardColor), % ask the AI to choose a piece for the opponnent
   % write(0), write(' choosed a piece for its opponent:'), writeln(Piece),
    iaChooseMove(BoardSize, Move),
    %iaChooseMove2(Piece, Move),
    %write(1), write( ' played the piece randomly:'), write(Piece), write(' in '), writeln(Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    %displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), % print it
    atomic_list_concat(Piece, ',', Atom), atom_string(Atom, PieceStr).


play(1, PieceStr, Move):-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), remainingPieces(RemainingPieces),
    chooseRandomPiece(Piece, RemainingPieces), % ask the AI to choose a piece for the opponnent
    %write(1), write(' choosed a random piece for its opponent:'), writeln(Piece),
    iaChooseMove2(Piece, Move),
    %write(0), write( ' played the piece:'), write(Piece), write(' in '), writeln(Move),
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    %displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), % print it
    atomic_list_concat(Piece, ',', Atom), atom_string(Atom, PieceStr).

changePlayer(0,1).
changePlayer(1,0).

:- dynamic boardSize/1.
:- dynamic boardShape/1.
:- dynamic boardColor/1.
:- dynamic boardHole/1.

:- dynamic remainingPieces/1.

% Initialize
init :- length(BoardShape, 16), assert(boardShape(BoardShape)),
        length(BoardColor, 16), assert(boardColor(BoardColor)),
        length(BoardHole, 16), assert(boardHole(BoardHole)),
        length(BoardSize, 16), assert(boardSize(BoardSize)),
        length(RemainingPieces, 16), assert(remainingPieces(RemainingPieces)),
        initPieces(RemainingPieces),
        play(0, BoardSize, BoardShape, BoardHole, BoardColor, RemainingPieces).

initPieces(RemainingPieces) :-
    Piece1 = [0, 0, 0, 0],
    Piece2 = [0, 0, 0, 1],
    Piece3 = [0, 0, 1, 0],
    Piece4 = [0, 0, 1, 1],
    Piece5 = [0, 1, 0, 0],
    Piece6 = [0, 1, 0, 1],
    Piece7 = [0, 1, 1, 0],
    Piece8 = [0, 1, 1, 1],
    Piece9 = [1, 0, 0, 0],
    Piece10 = [1, 0, 0, 1],
    Piece11 = [1, 0, 1, 0],
    Piece12 = [1, 0, 1, 1],
    Piece13 = [1, 1, 0, 0],
    Piece14 = [1, 1, 0, 1],
    Piece15 = [1, 1, 1, 0],
    Piece16 = [1, 1, 1, 1];
    RemainingPieces = [Piece1, Piece2, Piece3, Piece4, Piece5, Piece6, Piece7, Piece8, Piece9, Piece10, Piece11, Piece12, Piece13, Piece14, Piece15, Piece16].


play(Player, BoardSize, BoardShape, BoardHole, BoardColor, RemainingPieces):- gameover(BoardSize, BoardShape, BoardHole, BoardColor, Player).
play(Player, BoardSize, BoardShape, BoardHole, BoardColor, RemainingPieces):-
    boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), % instantiate the boards
    displayBoard(BoardSize, BoardShape, BoardHole, BoardColor), % print it
    write(Player), writeln('choose a piece for your opponent:'),
    iaChoosePiece(BoardSize, BoardShape, BoardHole, BoardColor,Piece,Player, RemainingPieces), % ask the AI to choose a piece for the opponnent
    changePlayer(Player, NextPlayer), % change to the player that will place the spiece
    write(Player), writeln( 'play the piece:'),
    iaChooseMove(BoardSize, BoardShape, BoardHole, BoardColor, Piece, Move, Player), %
    playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),  % Play the move and get the result in a new Board
    applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor), % Remove the old board from the KB and store the new one
    play(NextPlayer, BoardSize, BoardShape, BoardHole, BoardColor, RemainingPieces). % next turn!


iaChoosePiece(BoardSize,BoardShape,BoardHole,BoardColor,Piece,Player,RemainingPieces) :- repeat, length(RemainingPieces, NumberPieces), random(1, NumberPieces, IndexPiece), nth0(IndexPiece, RemainingPieces, Piece), var(Piece), writeln(nth0(IndexPiece, RemainingPieces, Piece)).

changePlayer(0,1).
changePlayer(1,0).

gameover(BoardSize, BoardShape, BoardHole, BoardColor, Player) :- win(BoardSize, BoardShape, BoardHole, BoardColor).

append([],L,L).
append([H|T],L,[H|B]) :- append(T,L,B).

playMoveBoard(Board,Move,NewBoard,Player) :- nth0(Move,NewBoard,Player), Board=NewBoard.

iaChooseMove(BoardSize, BoardShape, BoardHole, BoardColor, Piece, Move, Player) :- repeat, Index is random(16), nth0(Index, BoardSize, Elem), var(Elem), !.

playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor) :-
  playMoveBoard(BoardSize,Move,Piece,NewBoardSize), % Play the move and get the result in a new Board
  playMoveBoard(BoardShape,Move,Piece,NewBoardShape), % Play the move and get the result in a new Board
  playMoveBoard(BoardHole,Move,Piece,NewBoardHole), % Play the move and get the result in a new Board
  playMoveBoard(BoardColor,Move,Piece,NewBoardColor). % Play the move and get the result in a new Board

applyEntireMove(BoardSize, BoardShape, BoardHole, BoardColor, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor) :- % Remove the old board from the KB and store the new one
  retract(boardSize(BoardSize)), assert(boardSize(NewBoardSize)), % Remove the old board from the KB and store the new one
  retract(boardSize(BoardShape)), assert(boardSize(NewBoardShape)), % Remove the old board from the KB and store the new one
  retract(boardSize(BoardHole)), assert(boardSize(NewBoardHole)), % Remove the old board from the KB and store the new one
  retract(boardSize(BoardColor)), assert(boardSize(NewBoardColor)). % Remove the old board from the KB and store the new one

% Check if the game is won
win(BoardSize, BoardShape, BoardHole, BoardColor):- winBoard(BoardSize); winBoard(BoardHole); winBoard(BoardShape); winBoard(BoardColor).
  winBoard(Board) :- Board = [P,Q,R,S,_,_,_,_,_,_,_,_,_,_,_,_], P==Q, Q==R, R==S, nonvar(P). % first row
  winBoard(Board) :- Board = [_,_,_,_,P,Q,R,S,_,_,_,_,_,_,_,_], P==Q, Q==R, R==S, nonvar(P). % second row
  winBoard(Board) :- Board = [_,_,_,_,_,_,_,_,P,Q,R,S,_,_,_,_], P==Q, Q==R, R==S, nonvar(P). % third row
  winBoard(Board) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,P,Q,R,S], P==Q, Q==R, R==S, nonvar(P). % fouth row
  winBoard(Board) :- Board = [P,_,_,_,Q,_,_,_,R,_,_,_,S,_,_,_], P==Q, Q==R, R==S, nonvar(P). % first column
  winBoard(Board) :- Board = [_,P,_,_,_,Q,_,_,_,R,_,_,_,S,_,_], P==Q, Q==R, R==S, nonvar(P). % second column
  winBoard(Board) :- Board = [_,_,P,_,_,_,Q,_,_,_,R,_,_,_,S,_], P==Q, Q==R, R==S, nonvar(P). % third column
  winBoard(Board) :- Board = [_,_,_,P,_,_,_,Q,_,_,_,R,_,_,_,S], P==Q, Q==R, R==S, nonvar(P). % fourth column
  winBoard(Board) :- Board = [P,_,_,_,_,Q,_,_,_,_,R,_,_,_,_,S], P==Q, Q==R, R==S, nonvar(P). % first diagonal
  winBoard(Board) :- Board = [_,_,_,P,_,_,Q,_,_,R,_,_,S,_,_,_], P==Q, Q==R, R==S, nonvar(P). % second diagonal

boardFull(Board) :- isBoardFull([]).
isBoardFull([H|T]):- nonvar(H), isBoardFull(T).

% Display the board
displayBoard(BoardSize, BoardHole, BoardFull, BoardColor) :- write("========================="),write('\n'),
                % first line
                write("| "), printval(BoardSize, 0, 's', 'L'), write(' '), printval(BoardHole, 0, 'f', 'e'),write(" | "),
                write(" | "), printval(BoardSize, 1, 's', 'L'), write(' '), printval(BoardHole, 1, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 2, 's', 'L'), write(' '), printval(BoardHole, 2, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 3, 's', 'L'), write(' '), printval(BoardHole, 3, 'f', 'e'), write(" |"), write('\n'),

                %second line
                write("| "), printval(BoardShape, 0, 'o', 'q'), write(' '), printval(BoardColor, 0, 'w', 'b'),write(" | "),
                write(" | "), printval(BoardShape, 1, 'o', 'q'), write(' '), printval(BoardColor, 1, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 2, 'o', 'q'), write(' '), printval(BoardColor, 2, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 3, 'o', 'q'), write(' '), printval(BoardColor, 3, 'w', 'b'), write(" |"), write('\n'),

                write("|=====|=====|=====|=====|\n"),

                % first line
                write("| "), printval(BoardSize, 4, 's', 'L'), write(' '), printval(BoardHole, 4, 'f', 'e'),write(" | "),
                write(" | "), printval(BoardSize, 5, 's', 'L'), write(' '), printval(BoardHole, 5, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 6, 's', 'L'), write(' '), printval(BoardHole, 6, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 7, 's', 'L'), write(' '), printval(BoardHole, 7, 'f', 'e'), write(" |"), write('\n'),

                %second line
                write("| "), printval(BoardShape, 4, 'o', 'q'), write(' '), printval(BoardColor, 4, 'w', 'b'),write(" | "),
                write(" | "), printval(BoardShape, 5, 'o', 'q'), write(' '), printval(BoardColor, 5, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 6, 'o', 'q'), write(' '), printval(BoardColor, 6, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 7, 'o', 'q'), write(' '), printval(BoardColor, 7, 'w', 'b'), write(" |"), write('\n'),

                write("|=====|=====|=====|=====|\n"),

                % first line
                write("| "), printval(BoardSize, 8, 's', 'L'), write(' '), printval(BoardHole, 8, 'f', 'e'),write(" | "),
                write(" | "), printval(BoardSize, 9, 's', 'L'), write(' '), printval(BoardHole, 9, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 10, 's', 'L'), write(' '), printval(BoardHole, 10, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 11, 's', 'L'), write(' '), printval(BoardHole, 11, 'f', 'e'), write(" |"), write('\n'),

                %second line
                write("| "), printval(BoardShape, 8, 'o', 'q'), write(' '), printval(BoardColor, 8, 'w', 'b'),write(" | "),
                write(" | "), printval(BoardShape, 9, 'o', 'q'), write(' '), printval(BoardColor, 9, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 10, 'o', 'q'), write(' '), printval(BoardColor, 10, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 11, 'o', 'q'), write(' '), printval(BoardColor, 11, 'w', 'b'), write(" |"), write('\n'),

                write("|=====|=====|=====|=====|\n"),

                % first line
                write("| "), printval(BoardSize, 12, 's', 'L'), write(' '), printval(BoardHole, 12, 'f', 'e'),write(" | "),
                write(" | "), printval(BoardSize, 13, 's', 'L'), write(' '), printval(BoardHole, 13, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 14, 's', 'L'), write(' '), printval(BoardHole, 14, 'f', 'e'), write(" | "),
                write(" | "), printval(BoardSize, 15, 's', 'L'), write(' '), printval(BoardHole, 15, 'f', 'e'), write(" |"), write('\n'),

                %second line
                write("| "), printval(BoardShape, 12, 'o', 'q'), write(' '), printval(BoardColor, 12, 'w', 'b'),write(" | "),
                write(" | "), printval(BoardShape, 13, 'o', 'q'), write(' '), printval(BoardColor, 13, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 14, 'o', 'q'), write(' '), printval(BoardColor, 14, 'w', 'b'), write(" | "),
                write(" | "), printval(BoardShape, 15, 'o', 'q'), write(' '), printval(BoardColor, 15, 'w', 'b'), write(" |"), write('\n'),

                write("|=====|=====|=====|=====|"),write('\n').

printval(Board,N,CharTrue, CharFalse) :- nth0(N,Board,Val), var(Val), write('?'),!.
printval(Board,N,CharTrue, CharFalse) :- nth0(N,Board,Val), var(Val), Val is 1, write(CharTrue).
printval(Board,N,CharTrue, CharFalse) :- nth0(N,Board,Val), var(Val), Val is 0, write(CharFalse).
%printval(Board,N,CharTrue, CharFalse) :- nth0(N,Board,Val), var(Val), write('?'),!.

% ========================╗
% | A B | A B | A B | A B |
% | C D | C D | C D | C D |
% |=====|=====|=====|=====|
% | A B | A B | A B | A B |
% | C D | C D | C D | C D |
% |=====|=====|=====|=====|
% | A B | A B | A B | A B |
% | C D | C D | C D | C D |
% |=====|=====|=====|=====|
% | A B | A B | A B | A B |
% | C D | C D | C D | C D |
% |=====|=====|=====|=====|
% rond / carré : o / q
% noir / blanc : b / w
% full / troué : f / e
% petit / grand : s / L



% piece = [Size (0 = small, 1 = big),
%     Shape (0 = round, 1 = square),
%     Color (0 = black, 1 = white),
%     Hole (0 = unpierced, 1 = pierced)
% ]

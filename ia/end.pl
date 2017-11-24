%
% Verification de la fin d'une partie
%

gameover() :- win(), !.
gameover() :- boardShape(BoardShape), isBoardFull(BoardShape).

% Check if the game is won
win():- boardSize(BoardSize), boardShape(BoardShape), boardHole(BoardHole), boardColor(BoardColor), (winBoard(BoardSize); winBoard(BoardHole); winBoard(BoardShape); winBoard(BoardColor)).
  winBoard(Board) :- Board = [P,Q,R,S,_,_,_,_,_,_,_,_,_,_,_,_], P==Q, Q==R, R==S, nonvar(P), write('first row completed. '). % first row
  winBoard(Board) :- Board = [_,_,_,_,P,Q,R,S,_,_,_,_,_,_,_,_], P==Q, Q==R, R==S, nonvar(P), write('second row completed. '). % second row
  winBoard(Board) :- Board = [_,_,_,_,_,_,_,_,P,Q,R,S,_,_,_,_], P==Q, Q==R, R==S, nonvar(P), write('third row completed. '). % third row
  winBoard(Board) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,P,Q,R,S], P==Q, Q==R, R==S, nonvar(P), write('fourth row completed. '). % fouth row
  winBoard(Board) :- Board = [P,_,_,_,Q,_,_,_,R,_,_,_,S,_,_,_], P==Q, Q==R, R==S, nonvar(P), write('first column completed. '). % first column
  winBoard(Board) :- Board = [_,P,_,_,_,Q,_,_,_,R,_,_,_,S,_,_], P==Q, Q==R, R==S, nonvar(P), write('second column completed. '). % second column
  winBoard(Board) :- Board = [_,_,P,_,_,_,Q,_,_,_,R,_,_,_,S,_], P==Q, Q==R, R==S, nonvar(P), write('third column completed. '). % third column
  winBoard(Board) :- Board = [_,_,_,P,_,_,_,Q,_,_,_,R,_,_,_,S], P==Q, Q==R, R==S, nonvar(P), write('fourth column completed. '). % fourth column
  winBoard(Board) :- Board = [P,_,_,_,_,Q,_,_,_,_,R,_,_,_,_,S], P==Q, Q==R, R==S, nonvar(P), write('first diagonal completed. '). % first diagonal
  winBoard(Board) :- Board = [_,_,_,P,_,_,Q,_,_,R,_,_,S,_,_,_], P==Q, Q==R, R==S, nonvar(P), write('second diagonal completed. '). % second diagonal

win(BoardSize,BoardHole,BoardColor,BoardShape):-(winBoard(BoardSize); winBoard(BoardHole); winBoard(BoardShape); winBoard(BoardColor)).
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

isBoardFull([]).
isBoardFull([H|T]):- nonvar(H), isBoardFull(T).

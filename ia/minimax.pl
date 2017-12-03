%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                             %
% An implementation of the minimax algorithm. %
%                                             %
% minimax(+Pos, -BestNextPos, -Val)           %
%                                             %
% Rem : Need to define a number               %
% of prolog predicates in order to use it :   %
%                                             %
% - move(+Pos, -NextPos)                      %
%% - evalPos(+Pos, -Vol)                       %
%% - min_to_move(+Pos)                         %
%% - max_to_move(+Pos)                         %
%%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%:- module(minimax, [minimax/3]).
%
%iaChooseMoveMinimax(LastPiece, LastMove, SelectedPiece, BestMove, Depth):- minimax(LastPiece, LastMove, SelectedPiece, BestMove, Depth, _).
%
%% minimax(LastPiece, LastMove, SelectedPiece, BestMove, Depth, Val)
%% LastPiece is the last Piece used on the board
%% LastMove is the last move played on the board
%% SelectedPiece is the piece to during the turn
%% BestMove is the BestMove to play the piece
%% Val is the minimax value of LastPiece + LastMove
%minimax([LastPiece, LastMove, SelectedPiece], BestMove, Depth, Val) :-
%    % Legal moves in Pos produce NextPosList
%    bagof([NextPiece, NextMove], move([LastPiece, LastMove, SelectedPiece], [NextPiece, NextMove]), NextPosList),
%    best(NextPosList, BestMove, Val), !
%    ;
%    evalAllBoard(Boards, Val).     % Pos has no successors -> evaluate the positition
%
%
%
%
%best([[LastPiece, LastMove, SelectedPiece]], [LastPiece, LastMove, SelectedPiece], Val) :-
%    minimax([LastPiece, LastMove, SelectedPiece], _, Val), !.
%
%best([[LastPiece1, LastMove1, SelectedPiece1] | PosList], BestMove, BestVal) :-
%    minimax([LastPiece1, LastMove1, SelectedPiece1], _, Val1),
%    best(PosList, [LastPiece2, LastMove2, SelectedPiece2], Val2),
%    betterOf([LastPiece1, LastMove1, SelectedPiece1], Val1, [LastPiece1, LastMove1, SelectedPiece1], Val2, BestMove, BestVal).
%
%
%betterOf(Pos0, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
%    min_to_move(Pos0),                         % MIN to move in Pos0
%    Val0 > Val1, !                             % MAX prefers the greater value
%    ;
%    max_to_move(Pos0),                         % MAX to move in Pos0
%    Val0 < Val1, !.                            % MIN prefers the lesser value
%
%betterOf(_, _, Pos1, Val1, Pos1, Val1).        % Otherwise Pos1 better than Pos0
%

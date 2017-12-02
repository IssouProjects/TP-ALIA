iaChooseMoveMinimax(SelectedPiece, BestMove, Depth):-
	boardShape(BoardShape), boardSize(BoardSize), boardHole(BoardHole), boardColor(BoardColor),
 	minimax(BoardShape, BoardSize, BoardColor, BoardHole, SelectedPiece, BestMove, _, Depth).



minimax(BoardShape, BoardSize, BoardColor, BoardHole, Piece, NextMove, Eval, Depth) :-
	Depth < 5,
	NewDepth is Depth + 1,
	list_available_moves(BoardSize, ListMoves),
	best(BoardShape, BoardSize, BoardColor, BoardHole, Piece, ListMoves, NextMove, Eval, NewDepth), !.

minimax(BoardShape, BoardSize, BoardColor, BoardHole,_ , _, Eval, _) :-
  evalAllBoard(BoardSize, BoardShape, BoardHole, BoardColor, Eval), !.

best(BoardShape, BoardSize, BoardColor, BoardHole, Piece, [Move], Move, Eval, Depth) :-
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  minimax(Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor, _, Eval, Depth), !.

best(BoardShape, BoardSize, BoardColor, BoardHole, Piece, [Move|Moves], BestMove, BestEval, Depth) :-
  dechain(Move, Move1),
  playMove(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
  minimax(Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor, _, Eval, Depth),
  best(Piece, Moves, BestMove1, BestEval1, Depth),
  better_of(Piece, Move1, Eval, BestMove1, BestEval1, BestMove, BestEval, Depth).

list_available_moves(BoardSize, FinalListMoves):- list_available_moves(BoardSize, [],FinalListMoves, 0).
list_available_moves(_,FinalListMoves, FinalListMoves, 16).
list_available_moves(BoardSize, ListMoves, FinalListMoves, I):-
	N is I+1,
	nth0(I, BoardSize, Elem), var(Elem),
	append(ListMoves,I,NewListMoves),
	list_available_moves(BoardSize, NewListMoves, FinalListMoves, N).

list_available_moves(BoardSize, ListMoves,FinalListMoves, I):-
	N is I+1,
	nth0(I, BoardSize, Elem), nonvar(Elem),
	list_available_moves(BoardSize, ListMoves,FinalListMoves, N).

dechain([Move],Move).
dechain([_|Moves],Last) :- last(Moves, Last).
dechain(Move, Move).

even(Val):- 0 is mod(Val,2).

better_of(Move1, Eval1, _, Eval2, Move1, Eval1, Depth) :-
	even(Depth),
	Eval1 >= Eval2, !.
better_of(_, Eval1, Move2, Eval2, Move2, Eval2, Depth) :-
	even(Depth),
	Eval2 >= Eval1, !.

better_of(Move1, Eval1, _, Eval2, Move1, Eval1, Depth) :-
	even(Depth),
	Eval1 =< Eval2, !.
better_of(_, Eval1, Move2, Eval2, Move2, Eval2, Depth) :-
	even(Depth),
	Eval2 =< Eval1, !.

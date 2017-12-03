iaChooseMoveMinimax(SelectedPiece, BestMove, Depth):-
	boardShape(BoardShape), boardSize(BoardSize), boardHole(BoardHole), boardColor(BoardColor),
	remainingPieces(RemainingPieces),
 	minimax(BoardShape, BoardSize, BoardColor, BoardHole, RemainingPieces, SelectedPiece, BestMove, _, Depth).

minimax(BoardShape, BoardSize, BoardColor, BoardHole,RemainingPieces, Piece, NextMove, Eval, Depth) :-
	Depth < 2,
	NewDepth is Depth + 1,
	list_available_moves(BoardSize, ListMoves, RemainingPieces),
	best(BoardShape, BoardSize, BoardColor, BoardHole,RemainingPieces, Piece, ListMoves, NextMove, Eval, NewDepth), !.

minimax(BoardShape, BoardSize, BoardColor, BoardHole,_ ,_ , _, Eval, _) :-
  evalAllBoard(BoardSize, BoardShape, BoardHole, BoardColor, Eval),!.

best(BoardShape, BoardSize, BoardColor, BoardHole,RemainingPieces, Piece, [[Move|[NextPiece]]], [Move|[NextPiece]], Eval, Depth) :-
  playMove2(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
	supprime(NextPiece, RemainingPieces, NewRemainingPieces),
  minimax(NewBoardSize, NewBoardShape, NewBoardColor, NewBoardHole, NewRemainingPieces, NextPiece,  _, Eval, Depth), !.

best(BoardShape, BoardSize, BoardColor, BoardHole,RemainingPieces, Piece, [[Move|[NextPiece]]|Moves], BestMove, BestEval, Depth) :-
  playMove2(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor),
	supprime(NextPiece, RemainingPieces, NewRemainingPieces),
  minimax(NewBoardShape, NewBoardSize, NewBoardColor, NewBoardHole, NewRemainingPieces, NextPiece, _, Eval, Depth),
  best(BoardShape, BoardSize, BoardColor, BoardHole, RemainingPieces, Piece, Moves, BestMove1, BestEval1, Depth),
  better_of(Move, Eval, BestMove1, BestEval1, BestMove, BestEval, Depth).

% HELP MEEEEEEE
list_available_moves(BoardSize, FinalListMoves, RemainingPieces):- list_available_moves(BoardSize, [], RemainingPieces, FinalListMoves, 0).
list_available_moves(_,FinalListMoves, _, FinalListMoves, 16).
list_available_moves(BoardSize, ListMoves,RemainingPieces,FinalListMoves, I):-
	N is I+1,
	nth0(I, BoardSize, Elem), var(Elem),
	appendAllPieces(I,RemainingPieces, ListMoves,NewListMoves),
	list_available_moves(BoardSize, NewListMoves, RemainingPieces, FinalListMoves, N).

list_available_moves(BoardSize, ListMoves,RemainingPieces,FinalListMoves, I):-
	N is I+1,
	nth0(I, BoardSize, Elem), nonvar(Elem),
	list_available_moves(BoardSize, ListMoves,RemainingPieces,FinalListMoves, N).
% EST
appendAllPieces(_, [], ListMovesComplete, ListMovesComplete).
appendAllPieces(I, [Piece|RemainingPieces], ListMoves, ListMovesComplete):-
	append(ListMoves,[[I, Piece]],NewListMoves),
	appendAllPieces(I, RemainingPieces, NewListMoves, ListMovesComplete).

playMoveBoard2(Board,Move,Piece,NewBoard) :- duplicate_term(Board,NewBoard), nth0(Move,NewBoard,Piece).

playMove2(BoardSize, BoardShape, BoardHole, BoardColor, Move, Piece, NewBoardSize, NewBoardShape, NewBoardHole, NewBoardColor) :-
	nth0(Move, BoardSize, X),
	var(X),
  nth0(0, Piece, Size),
  nth0(1, Piece, Shape),
  nth0(2, Piece, Color),
  nth0(3, Piece, Hole),
  playMoveBoard2(BoardSize,Move,Size,NewBoardSize), % Play the move and get the result in a new Board
  playMoveBoard2(BoardShape,Move,Shape,NewBoardShape), % Play the move and get the result in a new Board
  playMoveBoard2(BoardHole,Move,Hole,NewBoardHole), % Play the move and get the result in a new Board
  playMoveBoard2(BoardColor,Move,Color,NewBoardColor). % Play the move and get the result in a new Board

dechain([Move],Move).
dechain([_|Moves],Last) :- last(Moves, Last).
dechain(Move, Move).

even(Val):- 0 is mod(Val,2).

% better_of(Move1, Eval1, Move2, Eval2, BestMoveDesDeux, BestEvalDesDeux, Depth)

better_of(Move1, Eval1, _, Eval2, Move1, Eval1, Depth) :-
	even(Depth),
	Eval1 >= Eval2, !.
better_of(_, Eval1, Move2, Eval2, Move2, Eval2, Depth) :-
	even(Depth),
	Eval2 >= Eval1, !.

better_of(Move1, Eval1, _, Eval2, Move1, Eval1, Depth) :-
	not(even(Depth)),
	Eval1 =< Eval2, !.
better_of(_, Eval1, Move2, Eval2, Move2, Eval2, Depth) :-
	not(even(Depth)),
	Eval2 =< Eval1, !.

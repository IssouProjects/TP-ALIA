% 
% Initialise le jeu
%

init :- length(BoardShape, 16), assert(boardShape(BoardShape)),
length(BoardColor, 16), assert(boardColor(BoardColor)),
length(BoardHole, 16), assert(boardHole(BoardHole)),
length(BoardSize, 16), assert(boardSize(BoardSize)),
initPieces(RemainingPieces),
assert(remainingPieces(RemainingPieces)),
play(0).

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
Piece16 = [1, 1, 1, 1],
RemainingPieces = [Piece1, Piece2, Piece3, Piece4, Piece5, Piece6, Piece7, Piece8, Piece9, Piece10, Piece11, Piece12, Piece13, Piece14, Piece15, Piece16].
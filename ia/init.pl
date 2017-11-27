%
% Initialise le jeu
%

init :- length(BoardShape, 16), assert(boardShape(BoardShape)),
length(BoardColor, 16), assert(boardColor(BoardColor)),
length(BoardHole, 16), assert(boardHole(BoardHole)),
length(BoardSize, 16), assert(boardSize(BoardSize)),
initPieces(RemainingPieces),
assert(remainingPieces(RemainingPieces)).
%displayBoard(BoardSize, BoardShape, BoardHole, BoardColor). % print it.
%atomic_list_concat(FullString, ',', Atom), atom_string(Atom, String).

initPieces(RemainingPieces) :-
Piece1 = [0, 0, 0, 0],
%atomic_list_concat(Piece1, ',', Atom1), atom_string(Atom1, String1),
Piece2 = [0, 0, 0, 1],
%atomic_list_concat(Piece2, ',', Atom2), atom_string(Atom2, String2),
Piece3 = [0, 0, 1, 0],
%atomic_list_concat(Piece3, ',', Atom3), atom_string(Atom3, String3),
Piece4 = [0, 0, 1, 1],
%atomic_list_concat(Piece4, ',', Atom4), atom_string(Atom4, String4),
Piece5 = [0, 1, 0, 0],
%atomic_list_concat(Piece5, ',', Atom5), atom_string(Atom5, String5),
Piece6 = [0, 1, 0, 1],
%atomic_list_concat(Piece6, ',', Atom6), atom_string(Atom6, String6),
Piece7 = [0, 1, 1, 0],
%atomic_list_concat(Piece7, ',', Atom7), atom_string(Atom7, String7),
Piece8 = [0, 1, 1, 1],
%atomic_list_concat(Piece8, ',', Atom8), atom_string(Atom8, String8),
Piece9 = [1, 0, 0, 0],
%atomic_list_concat(Piece9, ',', Atom9), atom_string(Atom9, String9),
Piece10 = [1, 0, 0, 1],
%atomic_list_concat(Piece10, ',', Atom10), atom_string(Atom10, String10),
Piece11 = [1, 0, 1, 0],
%atomic_list_concat(Piece11, ',', Atom11), atom_string(Atom11, String11),
Piece12 = [1, 0, 1, 1],
%atomic_list_concat(Piece12, ',', Atom12), atom_string(Atom12, String12),
Piece13 = [1, 1, 0, 0],
%atomic_list_concat(Piece13, ',', Atom13), atom_string(Atom13, String13),
Piece14 = [1, 1, 0, 1],
%atomic_list_concat(Piece14, ',', Atom14), atom_string(Atom14, String14),
Piece15 = [1, 1, 1, 0],
%atomic_list_concat(Piece15, ',', Atom15), atom_string(Atom15, String15),
Piece16 = [1, 1, 1, 1],
%atomic_list_concat(Piece16, ',', Atom16), atom_string(Atom16, String16),
%FullString = [String1, String2, String3, String4, String5, String6, String7, String8, String9, String10, String11, String12, String13, String14, String15, String16],
RemainingPieces = [Piece1, Piece2, Piece3, Piece4, Piece5, Piece6, Piece7, Piece8, Piece9, Piece10, Piece11, Piece12, Piece13, Piece14, Piece15, Piece16].

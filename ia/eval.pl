% Evalue chaque plateau, puis aditionne leurs évaluations
evalAllBoard(BoardSize, BoardShape, BoardHole, BoardColor, Value):-
  evalBoard(BoardSize, S0),
  evalBoard(BoardShape, S1),
  evalBoard(BoardHole, S2),
  evalBoard(BoardColor, S3),
  Value is S0+S1+S2+S3.

% Recupère chaque ligne de victoire potentiel, son évaluation, et aditionne le tout pour avoir celle du plateau
evalBoard(Board, Value):- Board = [X1,_,_,_,Y1,_,_,_,Z1,_,_,_,T1,_,_,_], evalLine([X1,Y1,Z1,T1], S1),
Board = [_,X2,_,_,_,Y2,_,_,_,Z2,_,_,_,T2,_,_], evalLine([X2,Y2,Z2,T2], S2),
Board = [_,_,X3,_,_,_,Y3,_,_,_,Z3,_,_,_,T3,_], evalLine([X3,Y3,Z3,T3], S3),
Board = [_,_,_,X4,_,_,_,Y4,_,_,_,Z4,_,_,_,T4], evalLine([X4,Y4,Z4,T4], S4),

Board = [X5,_,_,_,_,Y5,_,_,_,_,Z5,_,_,_,_,T5], evalLine([X5,Y5,Z5,T5], S5),
Board = [_,_,_,X6,_,_,Y6,_,_,Z6,_,_,T6,_,_,_], evalLine([X6,Y6,Z6,T6], S6),

Board = [X7,Y7,Z7,T7,_,_,_,_,_,_,_,_,_,_,_,_], evalLine([X7,Y7,Z7,T7], S7),
Board = [_,_,_,_,X8,Y8,Z8,T8,_,_,_,_,_,_,_,_], evalLine([X8,Y8,Z8,T8], S8),
Board = [_,_,_,_,_,_,_,_,X9,Y9,Z9,T9,_,_,_,_], evalLine([X9,Y9,Z9,T9], S9),
Board = [_,_,_,_,_,_,_,_,_,_,_,_,X10,Y10,Z10,T10], evalLine([X10,Y10,Z10,T10], S10),
Value is S1+S2+S3+S4+S5+S6+S7+S8+S9+S10.

% On verifie qu'il n'y ait pas plus d'une valeur différente par ligne, et on retourne cette valeur Z si elle existe
transformNulls(Line, Z):- transformNull(Line, Z, 0), transformNull(Line, Z, 1),transformNull(Line, Z, 2),transformNull(Line, Z, 3).
transformNull(Line, _, N):- nth0(N,Line,X), var(X).
transformNull(Line, Z, N):- nth0(N,Line,X), nonvar(X), Z is X.

% Fonction qui évalue la ligne en fonction du nombre de caractéristiques similaires et potentiellement gagnante sur la ligne
evalLine(Line, Value):- transformNulls(Line, Z), var(Z), Value is 0, !.
evalLine(Line, Value):- transformNulls(Line, Z), nonvar(Z), evalNbSimi(Line, Z, NbSimi), Value is NbSimi**NbSimi, !.
evalLine(_, Value):- Value is 0.

% calculate the number of similar pieces in the line
evalNbSimi([], _, 0).
evalNbSimi([X|Line], Z, NbSimi):- X == Z, evalNbSimi(Line, Z, NbSimi2), NbSimi is NbSimi2+1.
evalNbSimi([X|Line], Z, NbSimi):- var(X), evalNbSimi(Line, Z, NbSimi).

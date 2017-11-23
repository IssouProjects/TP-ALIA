%
% Affiche du jeu dans la console
%

% Display the board
displayBoard(BoardSize, BoardShape, BoardHole, BoardColor) :- write("========================="),write('\n'),
% first line
write("| "), printval(BoardSize, 0, 's', 'L'), write(' '), printval(BoardHole, 0, 'f', 'e'),
write(" | "), printval(BoardSize, 1, 's', 'L'), write(' '), printval(BoardHole, 1, 'f', 'e'),
write(" | "), printval(BoardSize, 2, 's', 'L'), write(' '), printval(BoardHole, 2, 'f', 'e'),
write(" | "), printval(BoardSize, 3, 's', 'L'), write(' '), printval(BoardHole, 3, 'f', 'e'), write(" |"), write('\n'),

%second line
write("| "), printval(BoardShape, 0, 'o', 'q'), write(' '), printval(BoardColor, 0, 'w', 'b'),
write(" | "), printval(BoardShape, 1, 'o', 'q'), write(' '), printval(BoardColor, 1, 'w', 'b'),
write(" | "), printval(BoardShape, 2, 'o', 'q'), write(' '), printval(BoardColor, 2, 'w', 'b'),
write(" | "), printval(BoardShape, 3, 'o', 'q'), write(' '), printval(BoardColor, 3, 'w', 'b'), write(" |"), write('\n'),

write("|=====|=====|=====|=====|\n"),

% first line
write("| "), printval(BoardSize, 4, 's', 'L'), write(' '), printval(BoardHole, 4, 'f', 'e'),
write(" | "), printval(BoardSize, 5, 's', 'L'), write(' '), printval(BoardHole, 5, 'f', 'e'),
write(" | "), printval(BoardSize, 6, 's', 'L'), write(' '), printval(BoardHole, 6, 'f', 'e'),
write(" | "), printval(BoardSize, 7, 's', 'L'), write(' '), printval(BoardHole, 7, 'f', 'e'), write(" |"), write('\n'),

%second line
write("| "), printval(BoardShape, 4, 'o', 'q'), write(' '), printval(BoardColor, 4, 'w', 'b'),
write(" | "), printval(BoardShape, 5, 'o', 'q'), write(' '), printval(BoardColor, 5, 'w', 'b'),
write(" | "), printval(BoardShape, 6, 'o', 'q'), write(' '), printval(BoardColor, 6, 'w', 'b'),
write(" | "), printval(BoardShape, 7, 'o', 'q'), write(' '), printval(BoardColor, 7, 'w', 'b'), write(" |"), write('\n'),

write("|=====|=====|=====|=====|\n"),

% first line
write("| "), printval(BoardSize, 8, 's', 'L'), write(' '), printval(BoardHole, 8, 'f', 'e'),
write(" | "), printval(BoardSize, 9, 's', 'L'), write(' '), printval(BoardHole, 9, 'f', 'e'),
write(" | "), printval(BoardSize, 10, 's', 'L'), write(' '), printval(BoardHole, 10, 'f', 'e'),
write(" | "), printval(BoardSize, 11, 's', 'L'), write(' '), printval(BoardHole, 11, 'f', 'e'), write(" |"), write('\n'),

%second line
write("| "), printval(BoardShape, 8, 'o', 'q'), write(' '), printval(BoardColor, 8, 'w', 'b'),
write(" | "), printval(BoardShape, 9, 'o', 'q'), write(' '), printval(BoardColor, 9, 'w', 'b'),
write(" | "), printval(BoardShape, 10, 'o', 'q'), write(' '), printval(BoardColor, 10, 'w', 'b'),
write(" | "), printval(BoardShape, 11, 'o', 'q'), write(' '), printval(BoardColor, 11, 'w', 'b'), write(" |"), write('\n'),

write("|=====|=====|=====|=====|\n"),

% first line
write("| "), printval(BoardSize, 12, 's', 'L'), write(' '), printval(BoardHole, 12, 'f', 'e'),
write(" | "), printval(BoardSize, 13, 's', 'L'), write(' '), printval(BoardHole, 13, 'f', 'e'),
write(" | "), printval(BoardSize, 14, 's', 'L'), write(' '), printval(BoardHole, 14, 'f', 'e'),
write(" | "), printval(BoardSize, 15, 's', 'L'), write(' '), printval(BoardHole, 15, 'f', 'e'), write(" |"), write('\n'),

%second line
write("| "), printval(BoardShape, 12, 'o', 'q'), write(' '), printval(BoardColor, 12, 'w', 'b'),
write(" | "), printval(BoardShape, 13, 'o', 'q'), write(' '), printval(BoardColor, 13, 'w', 'b'),
write(" | "), printval(BoardShape, 14, 'o', 'q'), write(' '), printval(BoardColor, 14, 'w', 'b'),
write(" | "), printval(BoardShape, 15, 'o', 'q'), write(' '), printval(BoardColor, 15, 'w', 'b'), write(" |"), write('\n'),

write("|=====|=====|=====|=====|"),write('\n').

printval(Board,N,_, _) :- nth0(N,Board,Val), var(Val), write('?'),!.
printval(Board,N, _, CharTrue) :- nth0(N,Board,Val), Val is 1, write(CharTrue).
printval(Board,N, CharFalse, _) :- nth0(N,Board,Val), Val is 0, write(CharFalse).
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

% noir / blanc : b / w
% full / troué : f / e
% petit / grand : s / L
% rond / carré : o / q



% piece = [Size (0 = small = s, 1 = large  = L),
%         Shape (0 = round = o, 1 = square = q),
%         Color (0 = white = w, 1 = black  = b),
%         Hole  (0 = full  = f, 1 = troue  = e)
% ]

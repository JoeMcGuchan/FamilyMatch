% Problem
% Identify which potential fathers share an ancenstry with the most matches.

% Sample Data

% child(a,d).
% child(a,e).
% child(b,d).
% child(b,e).
% child(c,g).
% child(c,h).
% child(d,g).
% child(d,h).
% child(e,j).
% child(e,k).
% child(f,j).
% child(f,k).
% child(i,l).
% child(j,l).
% child(m,c).
% child(n,c).

% potentialDescendant(k).
% potentialDescendant(h).
% potentialDescendant(n).

% match(g).
% match(l).

% load actual data

% :- pack_install(odf_sheet).
:- use_module(library(ods/sheet)).
:- ods_load('family-tree.ods').

% cell_value(:Sheet, ?X, ?Y, ?Value)

% CURRENTLY DOES NoT SUPPORT SHEETS WITH MORE THAN A MILLION VALUES

child(A,B) :- cell_value('Children',1,Y,A), cell_value('Children',2,Y,B), number(A), number(B).

potentialDescendant(A,N) :- cell_value('PotentialDescendants',1,Y,A), cell_value('PotentialDescendants',2,Y,N), number(A).

match(A,N) :- cell_value('Matches',1,Y,A), cell_value('Matches',2,Y,N), number(A).


% Code

% descendant(Higher, Lower, Degrees Seperated)

descendant(A,A,0).
descendant(A,C,N) :- child(A,B), descendant(B,C,M), N is M+1.

% ancestor(Lower, Higher, Degrees Seperated)

ancestor(A,A,0).
ancestor(A,C,N) :- child(B,A), ancestor(B,C,M), N is M+1.

% cantor counter (thank you stackOverflow)

range(Min, _, Min).
range(Min, Max, Val) :- NewMin is Min+1, Max >= NewMin, range(NewMin, Max, Val).

cantor(A,B,Lim) :-
	range(0, Lim, N),
    range(0, N, B),
    A is N - B.

% commonAncestor

% we use cantor to count up A nodes and then down B nodes and keep increasing our numbers until we find a match

% commonAncestor(PersonFrom, PersonTo, StepsUp, StepsDown, commonAncestor) 

% the cuts ensures that only the closest is picked

commonAncestor(P1,P2,Up,Down,B,Lim) :- cantor(Up,Down, Lim), ancestor(P1,B,Up), descendant(B,P2,Down), !.

% familyMatch([Person,TheirName, [Person, MatchInFamily, StepsUp, StepsDown],Lim)

familyMatch([P,PN],[[P,PN],[M,MN],U,D],Lim) :- match(M,MN), commonAncestor(P,M,U,D,_,Lim).

% allPotentialsAndMatches(X,Lim).

% X will match to every potential father and a match in their familyMatch

allPotentialsAndMatches(X,Lim) :- potentialDescendant(P,PN), familyMatch([P,PN],X,Lim).

outputAll(Z, Lim) :- findall(X, allPotentialsAndMatches(X,Lim), Z).

% Upon completion, it's become apparent this code is rubbish
% Currently, it takes every pair, and searches to it's limit for a connection between them 
% it'd be better if it took one, and searched all around it, returning whenever a match was hit
% ohwell

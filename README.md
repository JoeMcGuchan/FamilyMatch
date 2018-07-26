#WHAT IT DOES

In many cases during genology work, you may be looking for a potential ancestor of yourself. You have a number of candidates that may be your father, and you have a genetic match with a number of people, but those two groups do not overlap meaningfully. This program will output all the pairs of genetic matches and potential descentants that are in the same family as one another, along with how they are connected.

Output is a list of items, formatted

[[Potential Descedant ID, Name],[Genetic Match Id, Name], Steps up, Steps down]

Where "steps up" and "steps down" describe the path one would travel along the family tree to get from the descendant to the genetic match. (Or rather, how closely related they are).

#HOW TO USE

In this document is a file called "family-tree.ods". Replace the information in this spreadsheet with your information. Then run swipl from this folder. 

You will need to have ran :- pack_install(odf_sheet). before running the code in this document.

run

:- [potentials].
:- outputAll(X, Lim)

Where Lim is the maximum distance you will allow the search algoritm to search (the maximum depth of your family tree * 2).

X will match to a list of items formatted in the way describes above.

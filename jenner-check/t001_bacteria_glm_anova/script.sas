/*Question 1*/

/*Datalines*/
DATA Bacteria;
INPUT Strain $ Count @@;
DATALINES;
A 9 B 3 C 30 D 44
A 27 B 12 C 47 D 38
A 22 B 7 C 50 D 37
A 30 B 15 C 52 D 49
A 16 B 12 C 26 D 40
;
RUN;

PROC PRINT DATA= Bacteria;
RUN;

PROC SORT DATA= Bacteria;
BY Strain;
RUN;

PROC PRINT DATA= Bacteria;
RUN;

/*Part d*/
PROC GLM DATA= Bacteria;
CLASS Strain;
MODEL Count= Strain;
MEANS Strain / LINES TUKEY SCHEFFE;
RUN;

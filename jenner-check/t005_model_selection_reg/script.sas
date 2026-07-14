/*Context:
The "prostate.txt" data set has 97 observations and 8 predictors.
A study on 97 men with prostate cancer who were due to receive a radical prostatectomy.*/

/*Read in dataset*/
/* The original script reads prostate.txt via INFILE. That file is not part of
   the repository, so this compatibility bundle substitutes a small inline
   sample with the same columns (Obs Y X1-X8). The variable-selection logic
   below is the author's, unchanged. */
DATA prostate_rawdata;
INPUT Obs Y X1 X2 X3 X4 X5 X6 X7 X8;
DATALINES;
1 3.97 2.2 2.56 58 -0.44 0 1.77 6 75
2 3.31 0.09 3.66 42 0.79 1 -0.45 8 0
3 3.94 2.79 2.87 68 -0.07 0 -0.47 8 13
4 4.39 3.24 3.89 43 1.45 0 2.78 9 10
5 4.62 1.76 4.41 64 0.85 0 -1.2 7 98
6 3.52 0.16 2.73 58 0.37 1 -0.7 8 26
7 3.58 2.35 4.11 45 0.98 0 0.9 7 20
8 4.99 3.63 4.08 55 1.27 0 -0.42 6 40
9 4.59 1.01 2.65 77 2.02 1 -0.49 9 50
10 2.86 -0.29 2.82 76 0.7 1 2.46 9 46
11 4.06 0.1 4.79 73 0.52 0 2.3 7 80
12 5.88 1.98 3.38 79 2.48 1 2.78 6 87
13 3.8 2.6 4.07 75 1.53 1 -0.92 9 20
14 5.32 3.38 3.11 73 1.57 0 2.34 8 81
15 3.32 1.54 2.96 64 1.57 0 1.18 9 2
16 5.07 3.93 4.36 56 -1.17 0 -1.03 9 8
17 5.08 3.89 3.73 49 -0.9 1 2.67 7 33
18 6.15 3.82 4.64 53 1.38 1 2.88 8 56
19 6.02 3.5 3.54 56 -0.52 1 -1.31 7 75
20 4.51 2.16 3.03 43 1.95 0 0.81 8 85
21 4.0 1.43 3.74 77 0.85 0 1.97 9 24
22 3.22 0.77 3.45 44 1.23 0 -1.14 8 13
23 1.39 0.24 2.94 69 -0.85 0 -0.2 7 9
24 3.55 1.75 2.62 75 1.86 0 2.58 7 21
25 4.03 1.03 3.61 66 2.12 0 0.23 9 33
26 3.5 0.43 4.1 76 1.18 1 -0.73 8 27
27 6.67 3.84 3.83 75 -1.16 1 -1.15 9 64
28 2.22 -0.72 3.67 52 -1.13 0 1.5 7 51
29 2.83 -0.4 4.55 56 0.86 0 1.26 9 84
30 5.4 3.67 2.97 61 -0.47 1 -0.84 8 58
;
RUN;

PROC PRINT DATA= prostate_rawdata;
RUN;

/*Remove the Obs column*/
DATA prostate_data;
  SET prostate_rawdata (DROP= Obs);
RUN;

PROC PRINT DATA= prostate_data;
RUN;



/*Question 1*/

/*Finding best subset model using Forward Selection*/
PROC REG DATA= prostate_data;
	MODEL Y= X1 X2 X3 X4 X5 X6 X7 X8/
		SELECTION= Forward;
RUN; 


/*Finding best subset model using Backward Elimination*/
PROC REG DATA= prostate_data;
	MODEL Y= X1 X2 X3 X4 X5 X6 X7 X8 /
		SELECTION= Backward;
RUN;


/*Finding best subset model using Stepwise Regression*/
PROC REG DATA= prostate_data;
	MODEL Y= X1 X2 X3 X4 X5 X6 X7 X8 /
		SELECTION= Stepwise;
RUN;


/*Finding the best subset of the three based on Mallow's CP, adjusted R^2, AIC, BIC, and CV Error*/

PROC REG DATA=prostate_data OUTEST= EST;
	MODEL Y= X1 X2 X3 X4 X5 X6 X7 X8 / SELECTION= adjrsq SSE AIC BIC ADJRSQ CP;
		OUTPUT OUT= out p=p r=r;
RUN;
QUIT;

/*CP*/
PROC SORT DATA= EST OUT= EST_CP;
	BY _CP_;
PROC PRINT DATA= EST_CP;
RUN;

/*Adjusted R^2*/
PROC SORT DATA= EST OUT= EST_adjrsq;
	BY DESCENDING _ADJRSQ_;
PROC PRINT DATA= EST_adjrsq;
RUN;

/*AIC*/
PROC SORT DATA= EST OUT=EST_AIC;
	BY _AIC_;
PROC PRINT DATA= EST_AIC;
RUN;

/*BIC*/
PROC SORT DATA= EST OUT=EST_BIC;
	BY _BIC_;
PROC PRINT DATA= EST_BIC;
RUN;

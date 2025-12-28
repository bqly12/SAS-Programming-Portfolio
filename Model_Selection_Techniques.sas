/*Context:
The “prostate.txt” data set has 97 observations and 8 predictors.
A study on 97 men with prostate cancer who were due to receive a radical prostatectomy.*/

/*Read in dataset*/
DATA prostate_rawdata;
INFILE '/path/to/dataset.txt';
INPUT Obs Y X1 X2 X3 X4 X5 X6 X7 X8;
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

/*Best Model: Y= X2+ X3+ X5+ X6+ X7+ X8*/


/*Finding best subset model using Backward Elimination*/
PROC REG DATA= prostate_data;
	MODEL Y= X1 X2 X3 X4 X5 X6 X7 X8 /
		SELECTION= Backward;
RUN;

/*Best Model: Y= X2+ X3+ X5+ X8*/


/*Finding best subset model using Stepwise Regression*/
PROC REG DATA= prostate_data;
	MODEL Y= X1 X2 X3 X4 X5 X6 X7 X8 /
		SELECTION= Stepwise;
RUN;

/*Best Model: Y= X5+ X8*/


/*Forward selection: Y= X2+ X3+ X5+ X6+ X7+ X8
Backward elimination: Y= X2+ X3+ X5+ X8
Stepwise regression: Y= X5+ X8*/



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

/*Results*/
/*According to CP, model Y= X2+ X3+ X5+ X8 is the best (backward)*/
/*According to AdjRsq, model Y= X2+ X3+ X5+ X6+ X7+ X8 is the best (forward)*/
/*According to AIC, model Y= X2+ X3+ X5+ X8 is the best (backward)*/
/*According to BIC, model Y= X2+ X3+ X5+ X8 is the best (backward)*/



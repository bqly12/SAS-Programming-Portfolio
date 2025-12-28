/*Brianna Ly Project B*/
/*I certify that the SAS code given is my original and exclusive work*/

/*Import Dataset*/
PROC IMPORT DATAFILE= 'path/to/dataset.xlsx'
	OUT= Sleep
	DBMS= XLSX
	REPLACE;
	GETNAMES= yes;
	RANGE="Sheet1$A2:0";
RUN;

PROC PRINT DATA= work.Sleep;
RUN;

/*Adjusting Variables and Visibility*/
/*Categorize ESS scores to sections*/
DATA OSA_adj;
SET work.sleep;
LENGTH ESS_0 $10;
	IF 0<=ESS<=5
		THEN ESS_0= 'LowNorm';
	IF 6<=ESS<=10
		THEN ESS_0= 'HighNorm';
	IF 11<=ESS<=12
		THEN ESS_0= 'Mild';
	IF 13<=ESS<=15
		THEN ESS_0= 'Mod';
	IF 16<=ESS<=24
		THEN ESS_0= 'Extr';
/*New variable for regression and residual analysis*/	
	IF ESS_0= 'LowNorm'
		THEN Var_Low= 1;
		ELSE Var_Low= 0;
	IF ESS_0= 'HighNorm'
		THEN Var_High= 1;
		ELSE Var_High= 0;
	IF ESS_0= 'Mild'
		THEN Var_Mild= 1;
		ELSE Var_Mild= 0;
	IF ESS_0= 'Mod'
		THEN Var_Mod= 1;
		ELSE Var_Mod= 0;
	IF ESS_0= 'Extr'
		THEN Var_Extr= 1;
		ELSE Var_Extr= 0;
RUN;

PROC PRINT DATA= OSA_adj;
RUN;
/*Keep only needed variables*/
DATA OSA;
SET OSA_adj;
	KEEP AHI SaO2avg ESS_0 Var_Low Var_High Var_Mild Var_Mod Var_Extr;
RUN;

PROC PRINT DATA= OSA;
RUN;

/*Using set OSA*/

/*Graphical Display of Data*/
/*Relationship b/w SaO2avg and AHI for all ESS*/
PROC SGPLOT DATA= OSA;
SCATTER
	X= SaO2avg
	Y= AHI;
REG
	X= SaO2avg
	Y= AHI;
RUN;

/*Relationship between variables with different ESS*/
TITLE 'AHI by ESS Scores';
PROC SGPANEL DATA= OSA;
	PANELBY ESS_0;
	LOESS
		X= SaO2avg
		Y= AHI;
RUN;


/*ANOVA*/
/*One Way ANOVA- only categorical*/
PROC GLM DATA= OSA;
	CLASS ESS_0;
	MODEL AHI= ESS_0/ SS3;
	MEANS ESS_0/ TUKEY LINES;
RUN;
/*Not significant*/

/*Model Assumptions through residual analysis*/
PROC REG DATA= OSA;
	MODEL AHI= Var_Low Var_High Var_Mild Var_Mod Var_Extr;
RUN;

/*Regression Analysis of var
Var_Extr serves as the reference variable, the intercept is the average AHI for the extreme ESS score*/

/*Residual Analysis*/
/*Prediction plot random and has constant variance
Q-Q plot relatively linear
Plot meets requirements.*/


/*ANCOVA*/
PROC GLM DATA= OSA;
	CLASS ESS_0;
	MODEL AHI= SaO2avg|ESS_0/ SS3;
RUN;

/*ANCOVA without interaction*/
PROC GLM DATA= OSA;
	CLASS ESS_0;
	MODEL AHI= SaO2avg ESS_0/ SS3;
RUN;

/*Check residuals*/
PROC REG DATA= OSA;
	MODEL AHI= SaO2avg Var_Low Var_High Var_Mild Var_Mod Var_Extr;
RUN;

/*Residual Analysis*/
/*Prediction plot random and has constant variance
Q-Q plot relatively linear
Plot meets requirements.*/







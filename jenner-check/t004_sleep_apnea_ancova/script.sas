/*Brianna Ly Project B*/
/*I certify that the SAS code given is my original and exclusive work*/

/*Import Dataset*/
/* The original script reads a sleep-study workbook via PROC IMPORT (DBMS=XLSX).
   The workbook is not part of the repository, so this compatibility bundle
   substitutes a small inline sample with the same columns the analysis reads
   (ESS, AHI, SaO2avg). All downstream logic is the author's, unchanged. */
DATA Sleep;
	INPUT ESS AHI SaO2avg;
	DATALINES;
3 4.1 96.2
5 6.8 95.1
2 3.2 97.0
8 12.4 93.8
7 9.1 94.6
10 15.7 92.9
6 8.3 95.0
9 14.2 93.1
11 21.6 91.4
12 24.9 90.7
11 19.8 92.0
13 28.3 89.5
14 31.1 88.9
15 34.7 87.6
13 26.5 90.1
16 41.2 86.3
20 52.8 84.1
18 47.6 85.0
24 61.4 82.7
16 39.9 86.8
17 44.1 85.5
5 5.9 95.6
6 7.7 94.9
4 4.8 96.0
21 55.3 83.9
;
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

/*Model Assumptions through residual analysis*/
PROC REG DATA= OSA;
	MODEL AHI= Var_Low Var_High Var_Mild Var_Mod Var_Extr;
RUN;


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

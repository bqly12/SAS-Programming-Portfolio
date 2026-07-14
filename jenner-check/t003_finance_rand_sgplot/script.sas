/*Question 5*/

/*Part a*/
DATA Five_a;
	DO I=1 to 100;
		X= RAND('normal');
	OUTPUT;
	END;
RUN;

PROC PRINT DATA= Five_a;
RUN;

PROC SGPLOT DATA= Five_a;
HISTOGRAM X;
Density X;
RUN;


/*Part b*/
DATA Five_b;
	DO I=1 to 100;
		X= RAND('LOGNormal');
	OUTPUT;
	END;
RUN;

PROC SGPLOT DATA= Five_b;
HISTOGRAM X;
Density X;
RUN;

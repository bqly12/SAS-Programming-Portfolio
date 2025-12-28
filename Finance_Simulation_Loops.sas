Libname Orion 'path/to/data/folder';

/*Question 1*/

PROC CONTENTS DATA= Orion.order_fact;
RUN;

PROC PRINT DATA= Orion.order_fact;
RUN;

/*Part a*/
DATA work.order_fact2;
SET Orion.order_fact;
	Retain acc_total 0;
	acc_total= SUM(acc_total, Total_Retail_Price);
RUN;

/*Part b*/
Proc Print DATA= work.order_fact2;
	FORMAT acc_total dollar11.2;
RUN;


/*Question 2*/

/*Part a*/
DATA work.future_costs (DROP=i);
	Wages= 12874000;
	Retirement= 1765000;
	Medical= 649000;
	Rate_wage= 0.03;
	Rate_retire= 0.014;
	Rate_med= 0.095;
		DO i=1 TO 10;
			Wages + (Wages*Rate_wage);
			Retirement + (Retirement*Rate_retire);
			Medical + (Medical*Rate_med);
				TotalCost + (Wages+Retirement+Medical);
		OUTPUT;
		END;
RUN;

Proc PRINT DATA= work.future_costs;
RUN;

/*Part b*/
DATA work.future_costs (DROP=i);
	Wages= 12874000;
	Retirement= 1765000;
	Medical= 649000;
	Rate_wage= 0.03;
	Rate_retire= 0.014;
	Rate_med= 0.095;
	Income= 50000000;
	Rate_income= 0.01;
		DO i=1 TO 10 UNTIL (TotalCost > Income);
			Wages + (Wages*Rate_wage);
			Retirement + (Retirement*Rate_retire);
			Medical + (Medical*Rate_med);
				TotalCost + (Wages+Retirement+Medical);
				Income + (Income*Rate_income);
		OUTPUT;
		END;
RUN;

Proc PRINT DATA= work.future_costs;
RUN;


/*Question 3*/

/*Part a*/
DATA work.expenses (DROP=i);
	Income= 50000000;
	Expense= 38750000;
	Rate_income= 0.01;
	Rate_expense= 0.02;
		DO i=1 TO 100 UNTIL (Expense>Income OR i>30);
			Income + (Income*Rate_income);
			Expense + (Expense*Rate_expense);
	OUTPUT;
	END;
RUN;

/*Part b*/
PROC PRINT DATA= work.expenses;
	FORMAT Income Dollar15.2 Expense Dollar15.2;
RUN;


/*Question 4*/

PROC CONTENTS DATA= Orion.orders_midyear;
RUN;

PROC PRINT DATA= Orion.orders_midyear;
RUN;

/*Part a*/
DATA discount_sales;
SET Orion.orders_midyear;
KEEP Customer_ID Month1-Month6;
ARRAY MON{6} Month1-Month6;
	DO i=1 TO 6;
		Mon{i}=SUM(Mon{i},-(Mon{i}*0.05));
	OUTPUT;
	END;
RUN;

/*Part b*/
PROC PRINT DATA= discount_sales;
	FORMAT Month1- Month6 Dollar10.2;
RUN;


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







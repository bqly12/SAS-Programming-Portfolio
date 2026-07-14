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

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



/*Part a*/
/*Identify the Factor and Response*/

/*Factor: Strains of cultured Staphylococcus Aureus 
Response: Factor count measured by millions */



/*Part b*/
/*Give the cell means model and assumptions*/

/*Cell Means Model: Yij= 𝜇i+ 𝜀ij
Where yij is the observed value for the jth obs in the ith group and 𝜇i is the group mean for the ith
treatment group.
Assumptions: 𝜀𝑖𝑗~𝑁(0,𝜎2), 𝐼𝐼𝐷*/



/*Part c*/
/*Give the treatment effects model.*/

/*TEM: Yij = μ + τi + εi
Where τi= μi − μ.*/



/*Part d*/
/*At the 5% significance level, do the data provide sufficient evidence to conclude that a difference
exists in mean bacteria counts among the four strains? Give the hypotheses under both models, the test
statistic, P-value, and conclusion.*/

PROC GLM DATA= Bacteria;
CLASS Strain;
MODEL Count= Strain;
MEANS Strain / LINES TUKEY SCHEFFE;
RUN;

/*Cell Means:
H0= 𝜇1= 𝜇2= 𝜇3= 𝜇4 (All group means are equal)
Ha= Not all group means are equal

Treatment effects:
H0= 𝜏1= 𝜏2= 𝜏3= 𝜏4= 0
Ha= Not all are 0

F-value= 18.55
P-value= <0.0001

Conclusion: Because the p-value is less than our standard sig value, we have enough evidence to reject
the null hypothesis and conclude that some treatment means are signinificantly different and that the dif
strians affect bacteria count.*/



/*Part e*/
/*Which pairs of treatments have significantly different means, according to Tukey’s method? Does one
strain have a significantly higher mean than the others?*/

/*Accoring to Tukey's method, we see that strain A and B have significantly different means from strains
C and D. Means C and D appear to be higher than means A and B*/






/*Question 2*/

/*Datastep*/
FILENAME Fever '/path/to/dataset.txt';
DATA Fever;
INFILE Fever;
INPUT Hours A $ B $ @@;
RUN;

PROC PRINT DATA= Fever;
RUN;



/*Part a*/
/*Create an interaction plot. Does there appear to be significant interaction between the levels of
ingredient A and ingredient B? Why or why not?*/

PROC GLM DATA= Fever ORDER= DATA;
CLASS A B;
MODEL Hours= A|B;
LSMEANS A*B/ LINES ADJUST= Tukey;
RUN;

/*Yes there appears to be an interaction. From the plot, in factor B, low line appears to be relatively
parallel to the other lines. However, the Medium and High lines appear to intersect, looking like they
are almost layered on each other. From this we can assume there is an interaction.*/



/*Part b*/
/*Using the treatment effects model, perform a hypothesis test for an interaction effect between the
level of ingredient A and ingredient B. Give the hypotheses, test statistic, P-value, and conclusion.*/

/*H0= All (ab)ij= 0 (all interactions = 0)
Ha: Not all= 0
F-value= 122.23
P-value= < 0.0001
Conclusion: Because our p-value is smaller than the significance level, we have enough evidence to reject
the null hypothesis and conclude that there is a significant interaction effect.



/*Part c*/
/*Is it necessary to perform tests for the main effects of ingredient A and ingredient B? Why or why
not?*/ 

/*No, we don't need to perform a test for the main effects because we already found a significant
interaction between the two factors, which means that one factor depends on the other.*/



/*Part d*/
/*Perform the appropriate analysis according to the results in hypothesis testing: either (1) compare
the change in the mean of factor A as its level increases for each level of B, OR (2) compare the means
of the three levels separately for each ingredient. Use Tukey’s method for all comparisons*/

/*We will (1) compare the change in the mean of factor A as its level increases for each level of B. This
is because we already found a significant interaction beteween the two factors.*/
/*Using Tukey's method, we see that...*/




   /*************************************/
   /* create the input data set         */
   /*************************************/
data fitness;
   input Age Sex $ HeartRate 
         Exercise Aerobic;
datalines;
28  M  86  2   36.6
41  M  76  3   26.7
30  M  78  2   33.8
39  F  90  1   13.6
28  M  96  1   33.
26  M  74  2   42.7
 .  F  66  4   36.1
48  F  72  2   22.6
31  M  60  3   44.1
28  F  84  2   22.1
33  F  56  4   21.3
37  F  78  2   30.3
46  M  84  1   34.2
23  M  72  2   38.1
25  F  88  1   32.0
37  F  72  2   43.7
42  M  60  3   36.7
44  F  78  3   21.6
 .  F  70  1   22.8
25  F  60  3   36.1
24  F  74  2   29.9
29  F  66  4   38.9
27  M  62  4   44.0
24  M  72  3   44.2
36  F  80  1   26.2
24  M  82  2   18.7
23  M  54  3   70.6
28  F  76  1   23.8
30  F  66  2   28.9
25  M  54  3   41.3
48  F  72  2   28.9
23  F  68  1   18.9
22  F  78  2   39.0
23  F  66  3   36.1
46  F  54  3   28.9
31  F  84  1   21.6
45  M  60  2   47.8
27  M  90  2   43.1
26  M  66  2   28.9
26  F  84  2     .
24  M  72  3   50.1
32  F  72  1   15.7
29  M  54  3   44.8
48  F  66  2   28.9
36  F  66  2   33.2
;
run;

   /*************************************/
   /* create a bar chart (PROC CHART)   */
   /*************************************/
proc chart data=fitness;
   vbar age / type=mean
              sumvar=heartrate
              group=sex
              midpoints=(20 30 40 50);
   where exercise=1;
   title1 'Average Heart Rate by Age and Sex';
   title2 'for Exercise Group 1';
run;
quit;
title;

   /*************************************/
   /* create pie charts (PROC GCHART)   */
   /*************************************/
proc gchart data=fitness;
   pie sex / type=mean
             fill=solid
             sumvar=aerobic;
   pie3d exercise / type=mean
                    sumvar=heartrate 
                    group=sex
                    discrete
                    across=2 
                    fill=solid
                    ctext=blue 
                    explode=4
                    slice=arrow 
                    noheading;
run;
quit;

   /*************************************/
   /* create an interactive bar chart   */
   /* (PROC GCHART, ODS, and ActiveX)   */
   /*************************************/
ods html body='barchart.htm';
goptions device=activex;
proc gchart data=fitness;
   axis1 order=(0 to 20 by 2)         label=('Number of People')         minor=(number=1)         offset=(0,0);   axis2 label=('Age ' j=r 'Group');   hbar3d age / midpoints=(20 30 40 50)                freq                freqlabel='Total in Group'                subgroup=sex                autoref                maxis=axis2                raxis=axis1                coutline=black;   title1 'Fitness Program Participants';
run;
quit;
ods html close;

   /*************************************/
   /* clear any titles in effect        */
   /*************************************/
title;

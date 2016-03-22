/*from http://confounding.net/2011/08/19/sampling-from-a-bayesian-posterior-distribution-in-sas/ */
data work.tinkering;
do id=1 to 20000;
disroll= ranuni(68273);
yran = ranuni(102842);
if yran<= 0.333 then y = 1; else if yran >0.333 then y=0;
   pdis = exp(-2.30258+(1.0986*y));
   if disroll<= pdis then case=1; else if disroll>pdis then case=0;
   output;
end;
run;


ods graphics on;
proc genmod data=work.tinkering descending;
   model case = y / dist = binomial link = log;
   bayes nbi=2000 nmc = 10000 plots=all outpost=work.out;
run;
ods graphics off;

proc surveyselect data=work.out method=urs outhits n=1000 out=work.SampledPrior;
run;

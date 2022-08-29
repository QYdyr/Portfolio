

/*********************************** SAS data analysis ********************************/




/******************* All real data removed based on requirements of research projects ************/




/****************************** Nominal data analysis ****************************/

/** reading data into SAS **/
data WQscores;
input flock $ age $ week $ area $ id $ NC $ eyes $ gait $ FQhead $ FQneck $ FQback $ FQtail $ FQrwing $ FQlwing $ FCneck $ FCback $ FCrump $ FCbreast $ FCbackend $ footL $ footR $;
datalines;
;
run;

/** print data **/

proc print data=WQscores;
run;


/******************* Multinomial Model ***********************/

proc glimmix data=WQscores;
class week area flock;
model gait=week/ dist=mult link=clogit solution or(label);
random intercept / subject=flock; 
estimate 'week 1 vs week 2 ' week 1 -1 0, 'week 1 vs week 3' week 1 0 -1, 'week 2 vs week 3' week 0 1 -1 / or cl adjust=bon;
run;


/******************* Binary Model ***********************/

proc glimmix data=WQscores;
class week area flock;
model NC=week/ dist=binary link=logit solution or(label);
random intercept / subject=flock; 
estimate 'week 1 vs week 2 ' week 1 -1 0, 'week 1 vs week 3' week 1 0 -1, 'week 2 vs week 3' week 0 1 -1 / or cl adjust=bon;
run;



/*********************************** Least Square meand & create plots ********************************/

/** reading data into SAS **/

data scan12;
input week $ flock $ timepoint $ TOD $ location $ totalbirds totalpecking GFP SFP AGGP SELFP; 
propGFP = GFP/totalbirds;
propSFP = SFP/totalbirds;
propAGGP = AGGP/totalbirds;
propother = SFP/totalbirds + AGGP/totalbirds + SELFP/totalbirds;
propSELFP = SELFP/totalbirds;
datalines;
;
run;

/** print data **/

proc print data=scan12;
run;


/* model after dropping 3-way interaction */
proc MIXED data=scan12 plots=residualpanel plots=studentpanel;
class week location flock timepoint TOD;
model propGFP = TOD week location TOD*week TOD*location week*location; 
lsmeans TOD week location TOD*week TOD*location week*location /  pdiff=all adjust=tukey cl;
random flock;
repeated week(timepoint);
run;


/**************************************** plot lsmeans and differences results ***********************************************/

/* enabling ODS graphics */

ods graphics on;

/* save lsmeans and difference into two datasets*/

ODS OUTPUT lsmeans=lsm
           diffs=dfs;


/***************** plot lsmeans *******************/

data lsm1;
input week $ TOD $ Estimate StdErr Lower Upper; 
seu=estimate+stderr;
sel=estimate-stderr;
datalines;
;
run;

proc print data=lsm1;
run;



/* plot propGFP vs week and TOD */

ods listing style=htmlblue;
ods graphics / attrpriority=none;


proc sgplot data=lsm1;
  styleattrs datasymbols=(circlefilled trianglefilled);
  scatter x=week y=estimate / yerrorlower=sel yerrorupper=seu group=TOD filledoutlinedmarkers 
          markerfillattrs=(color=white)
          groupdisplay=cluster clusterwidth=0.5 errorbarattrs=(thickness=1);
  series  x=week y=estimate / lineattrs=(pattern=solid) group=TOD 
          groupdisplay=cluster clusterwidth=0.5 lineattrs=(thickness=2) name='s';
  yaxis label='Proportion of ducks performing gentle feather pecking behavior (LSMean ± SE)' grid min=0 max=0.02;
  xaxis label='Period';
  keylegend  / title='Time of day';
  title1;
  footnote1;
  run;

  
/* disnabling ODS graphics */

ods graphics off;



/****************************** Data transformation & GLIMMIX model & create plots ****************************/

data duckfocal;
input flock $ age $ day $ location $ bird $ week $ TOD $ GFPdur SFPdur Aggdur SELFdur PREENdur IPdur dur GFPfreq SFPfreq AGGfreq SELFfreq PREENfreq IPfreq freq;
otherdur = SFPdur + AGGdur + SELFdur;
otherfreq = SFPfreq + AGGfreq + SELFfreq;
sqrtpreen = SQRT(PREENdur);
logpreen = log(PREENdur + 1);
sqrtgfp = SQRT(GFPdur);
logGFP = log(GFPdur +1);
logother = log(SFPdur + AGGdur + SELFdur + 1);
sqrtother = SQRT(SFPdur + AGGdur + SELFdur);
preenf1 = PREENfreq + 1;
GFPf1 = GFPfreq + 1;
otherf1 = SFPfreq + AGGfreq + SELFfreq + 1;
datalines;
;
run;

proc print data=duckfocal;
run;


/* enabling ODS graphics */

ods graphics on;


*/ PREENING */;

/* PROC MIXED model*/

*/original model but removed 3-way interaction */;

PROC MIXED data=duckfocal plots=residualpanel plots=studentpanel;
	class flock day TOD location bird week;
	model PREENdur = TOD week location TOD*week TOD*location week*location;
	random flock;
	repeated week(day);
	lsmeans TOD week location TOD*week TOD*location week*location / adjust = tukey cl;
run;


*/ square root transformation would get better normality */;

PROC MIXED data=duckfocal plots=residualpanel plots=studentpanel;
	class flock day TOD location bird week;
	model sqrtpreen = TOD week location TOD*week TOD*location week*location;
	random flock;
	repeated week(day);
	lsmeans TOD week location TOD*week TOD*location week*location / adjust = tukey cl;
	ODS OUTPUT lsmeans=lsm1
           diffs=dfs1;
run;

proc print data=lsm1;
run;

proc print data=dfs1;
run;


*/ GFP duration */;


/* PROC MIXED model*/

*/original model but removed 3-way interaction */;

PROC MIXED data=duckfocal plots=residualpanel plots=studentpanel;
	class flock day TOD location bird week;
	model GFPdur = TOD week location TOD*week TOD*location week*location;
	random flock;
	repeated week(day);
	lsmeans TOD week location TOD*week TOD*location week*location / adjust = tukey cl;
run;

*/ log+1 transformation would get better normality */;

PROC MIXED data=duckfocal plots=residualpanel plots=studentpanel;
	class flock day TOD location bird week;
	model logGFP = TOD week location TOD*week TOD*location week*location;
	random flock;
	repeated week(day);
	lsmeans TOD week location TOD*week TOD*location week*location / adjust = tukey cl;
    ODS OUTPUT lsmeans=lsm2
           diffs=dfs2;
run;

proc print data=lsm2;
run;

proc print data=dfs2;
run;



/**************** GLIMMMIX model ****************/

/* enabling ODS graphics */

ods graphics on;

/** other freq**/

PROC GLIMMIX data=duckfocal plots=residualpanel plots=studentpanel;
	class flock day TOD location bird week;
	model otherf1 = TOD week location TOD*week TOD*location week*location / dist=poisson link=log;
	random flock;
	random _residual_ / subject = week(day);
	lsmeans TOD week location TOD*week TOD*location week*location / adjust = tukey cl ilink;
	ODS OUTPUT lsmeans=lsm3
           diffs=dfs3;
run;

proc print data=lsm3;
run;

proc print data=dfs3;
run;



data lsm04;
input location $ week $ Estimate StdErr; 
seu=estimate+stderr;
sel=estimate-stderr;
datalines;
;
run;

proc print data=lsm04;
run;



/* plot other vs week and loc */

ods listing style=htmlblue;
ods graphics / attrpriority=none;

proc sgplot data=lsm04;
  styleattrs datasymbols=(circlefilled trianglefilled);
  scatter x=week y=estimate / yerrorlower=sel yerrorupper=seu group=location filledoutlinedmarkers 
          markerfillattrs=(color=white)
          groupdisplay=cluster clusterwidth=0.5 errorbarattrs=(thickness=1);
  series  x=week y=estimate / lineattrs=(pattern=solid) group=location
          groupdisplay=cluster clusterwidth=0.5 lineattrs=(thickness=2) name='s';
  yaxis label='Combined frequency of severe feather pecking, aggressive pecking and forceful self-picking behavior                       (lsmean ± SE, log(x + 1) transformed)  ' grid min=0 max=1.5;
  xaxis label='Period';
  keylegend / title='Location in the barn';
  title1;
  footnote1;
  run;



/************* LOGISTIC models - overall treatment and age difference ***************/


proc logistic data=browns_combined;
   class trt age room /param=effect;
   model back = trt age room / firth noor;
   oddsratio trt;
   oddsratio age;
   contrast 'A vs S' trt 1  / estimate=exp;
   contrast '12wk vs 17wk' age 1  / estimate=exp;
   /*effectplot / at(age=all) clm noobs yrange=(0.92,1.0);*/
run;


proc logistic data=layer_combined plots(only)= (oddsratio(type=horizontalstat));
   class trt age room /param=effect;
   model comb = trt age room / firth noor;
   oddsratio trt;
   oddsratio age;
   contrast 'A vs S ' trt 1 -1  / estimate=exp;
   contrast '20wk vs 24wk' age 1 -1 / estimate=exp;
   contrast '20wk vs 28wk' age 1 0 -1 / estimate=exp;
   contrast '20wk vs 32wk' age 1 0 0 -1 / estimate=exp;
   contrast '20wk vs 36wk' age 2 1 1 1 / estimate=exp;
   contrast '24wk vs 28wk' age 0 1 -1 / estimate=exp;
   contrast '24wk vs 32wk' age 0 1 0 -1 / estimate=exp;
   contrast '24wk vs 36wk' age 1 2 1 1 / estimate=exp;
   contrast '28wk vs 32wk' age 0 0 1 -1 / estimate=exp;
   contrast '28wk vs 36wk' age 1 1 2 1 / estimate=exp;
   contrast '32wk vs 36wk' age 1 1 1 2 / estimate=exp;
   effectplot / at(age=all) clm noobs;
run;




/******* Comparisons at different ages for each treatment ***************************/


/*********** A treatment ****************/

data browns_a;
set browns_combined;
where trt in ('A');
run;


proc logistic data=browns_a plots(only)= (effect(clband) oddsratio (type=horizontalstat));
   class age room /param=effect;
   model back = age room / firth noor;
   oddsratio age;
   contrast '12wk vs 17wk' age 1 / estimate=exp;
   effectplot  / at(age=all) noobs ;
run;


/*************************** Comparison between treatments at each age ********************/



/*********** 12 wk ****************/

data browns_12;
set browns_combined;
where age=12;
run;


proc print data=browns_12;
run;

proc freq data = browns_12;
tables room*trt / crosslist;
run;


proc logistic data=browns_12 plots(only)= (effect(clbar) oddsratio (type=horizontalstat));
   class trt room /param=effect;
   model back = trt room / firth noor;
   oddsratio trt;
   contrast 'A vs S ' trt 1 -1  / estimate=exp;
   effectplot / at(trt=all) noobs;
run;

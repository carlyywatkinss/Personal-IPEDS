libname IPEDS '~/IPEDS';
libname GITHUB '~/GITHUB';
%let rc=%sysfunc(dlgcdir('~'));
options fmtsearch=(IPEDS);

proc sql;
	create table model_data as
	select gr.unitid, cohort, Rate,

	/*characteristics data*/
	iclevel, control, hloffer, locale,  
	instcat, c21enprf, cbsatype,

	/*aid data*/
	(uagrntn/scfa2) as GrantRate,
	(uagrntt/scfa2) as GrantAvg,
	(upgrntn/scfa2) as PellRate,
	(ufloann/scfa2) as LoanRate,
	(ufloant/scfa2) as LoanAvg,

	/*cost data*/
	(case when tuition1 ne tuition2 then 1 else 0 end) as InDistrictT,
	abs(tuition1 - tuition2) as InDistrictTDiff,
	(case when fee1 ne fee2 then 1 else 0 end) as InDistrictF,
	abs(fee2 - fee1) as InDistrictFDiff,
	tuition2 as InStateT, fee2 as InStateF,
	(case when tuition3 ne tuition2 then 1 else 0 end) as OutStateT,
	abs(tuition3 - tuition2) as OutStateTDiff,
	(case when fee3 ne fee2 then 1 else 0 end) as OutStateF,
	abs(fee3 - fee2) as OutStateFDiff,
	(case when room eq 2 then 0
	      when room eq 1 then 1 
	      else room end) as Housing, 
	roomcap as ScaledHousingCap,
	(case when board eq 3 then 0 
	      else board end) as board, 
	(case when board eq 3 then roomamt eq 0 
	      else roomamt end) as roomamt, 
	(case when board eq 3 then boardamt eq 0 
	      else boardamt end) as boardamt,

	/*salary data*/
	(sa09mot/sa09mct) as AvgSalary,
	(scfa2/sa09mct) as StuFacRatio

	from ipeds.gradrates as gr 
	inner join ipeds.characteristics as c on gr.unitid = c.unitid
    inner join ipeds.aid as a on gr.unitid = a.unitid
    inner join ipeds.tuitionandcosts as co on gr.unitid = co.unitid
	inner join ipeds.salaries as s on gr.unitid = s.unitid
	;
run;


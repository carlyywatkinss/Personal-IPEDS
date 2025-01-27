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
	tuition1, fee1, tuition2, fee2,
	tuition3, fee3, room, roomcap, board,
	roomamt, boardamt,

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

proc compare base=regdata
	compare=work.model_data;
run;

%include '~/Specs/Graduation Specs Generator.sas';
/** ^^ this will run the code without actually seeing the code**/
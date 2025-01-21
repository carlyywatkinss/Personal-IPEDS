proc sql;
	create table model_data as
	select unitid, cohort, Rate,

	/*characteristics data*/
	control, hloffer, locale, iclevel, 
	instcat, c21enprf, cbsatype,

	/*aid data*/
	scfa2, scfa1n, scfa11n, scfa12n,
	scfa13n, scfa14n, uagrntn, uagrntt,
	upgrntn, ufloann, ufloant, 

	/*cost data*/
	tuition1, fee1, tuition2, fee2,
	tuition3, fee3, room, roomcap, board,
	roomamt, boardamt,

	/*salary data*/
	(sa09mot/sa09mct) as AvgSalary,
	(scfa2/sa09mct) as StuFacRatio

	from ipeds.gradrates as gr 
	left join ipeds.characteristics as c on gr.unitid = c.unitid
    left join ipeds.aid as a on gr.unitid = a.unitid
    left join ipeds.tuitionandcosts as co on gr.unitid = co.unitid
	left join ipeds.salaries as s on gr.unitid = s.unitid
	;
run;

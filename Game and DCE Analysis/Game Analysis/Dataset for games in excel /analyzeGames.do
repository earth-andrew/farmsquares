clear all

import delimited "/Users/andrewbell/Documents/Project work/Nature+ Kenya/Game Analysis/group_summary.csv" 

sort group
save "/Users/andrewbell/Documents/Project work/Nature+ Kenya/Game Analysis/Dataset for games in excel /group_characteristics.dta", replace

clear all

import delimited "/Users/andrewbell/Documents/Project work/Nature+ Kenya/Game Analysis/Dataset for games in excel /gameSummary.csv", clear 
sort group

merge group using "/Users/andrewbell/Documents/Project work/Nature+ Kenya/Game Analysis/Dataset for games in excel /group_characteristics.dta" 

gen totalyield = yield_round1 + yield_round2 + yield_round3 + yield_round4 + yield_round5 + ///
	yield_round6 + yield_round7 + yield_round8 + yield_round9 + yield_round10 + ///
	yield_round11 + yield_round12 + yield_round13 + yield_round14 + yield_round15

gen totalyield3 = yield_3_round1 + yield_3_round2 + yield_3_round3 + yield_3_round4 + yield_3_round5 + ///
	yield_3_round6 + yield_3_round7 + yield_3_round8 + yield_3_round9 + yield_3_round10 + ///
	yield_3_round11 + yield_3_round12 + yield_3_round13 + yield_3_round14 + yield_round15

gen totalyield15 = yield_15_round1 + yield_15_round2 + yield_15_round3 + yield_15_round4 + yield_15_round5 + ///
	yield_15_round6 + yield_15_round7 + yield_15_round8 + yield_15_round9 + yield_15_round10 + ///
	yield_15_round11 + yield_15_round12 + yield_15_round13 + yield_15_round14 + yield_15_round15

gen totalyield32 = yield_32_round1 + yield_32_round2 + yield_32_round3 + yield_32_round4 + yield_32_round5 + ///
	yield_32_round6 + yield_32_round7 + yield_32_round8 + yield_32_round9 + yield_32_round10 + ///
	yield_32_round11 + yield_32_round12 + yield_32_round13 + yield_32_round14 + yield_32_round15
	
gen grazing_yield_share = totalyield3 / totalyield

gen mean_soil_health = (soilhealth_round1 + soilhealth_round2 + soilhealth_round3 + soilhealth_round4 + soilhealth_round5 + ///
	soilhealth_round6 + soilhealth_round7 + soilhealth_round8 + soilhealth_round9 + soilhealth_round10 + ///
	soilhealth_round11 + soilhealth_round12 + soilhealth_round13 + soilhealth_round14 + soilhealth_round15) / 15
	
gen min_soil_health = min(soilhealth_round1, soilhealth_round2, soilhealth_round3, soilhealth_round4, soilhealth_round5, ///
	soilhealth_round6, soilhealth_round7, soilhealth_round8, soilhealth_round9, soilhealth_round10, ///
	soilhealth_round11, soilhealth_round12, soilhealth_round13, soilhealth_round14, soilhealth_round15)
	
local reglist i.gender i.treatment i.site age edu land earnings bad_earnings time_self time_share cons_frac cattle shoat
//gender: 1 men; 2 women; 3 mixed
regress totalscore `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Total Score) replace 
regress varscore `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Variation in Score) 
regress totalyield `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Total yield) 
regress totalyield3 `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Grazing yield) 
regress totalyield15 `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Low-intensity yield) 
regress totalyield32 `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(High-intensity yield) 
regress grazing_yield_share `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Grazing share of yield) 
regress soilhealth_round15 `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(End of game soil health) 
regress mean_soil_health `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Average soil health along game) 
regress min_soil_health `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Lowest soil health) 
regress numgifts `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Number gifts) 
regress sumgifts `reglist'
outreg2 using games.xls, stats(coef) excel ctitle(Sum gifts) 

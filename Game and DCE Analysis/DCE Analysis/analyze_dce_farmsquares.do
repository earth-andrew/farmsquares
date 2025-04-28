clear all

import excel "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/full_survey_pre.xlsx", sheet("Questionnaire_DCE") firstrow

destring(id), replace

sort id

save "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/full_survey_pre.dta", replace


clear all

use "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/rand_coeffs_dce_pre.dta"

sort id

save "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/rand_coeffs_dce_pre.dta", replace

clear all

use "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/rand_coeffs_dce_post.dta"

sort id

save "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/rand_coeffs_dce_post.dta", replace

clear all

use "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/rand_coeffs_dce_pre.dta"

rename * *_pre
rename id_pre id

merge id using "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/rand_coeffs_dce_post.dta" 

sort id

drop _merge

merge id using "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/full_survey_pre.dta"

drop _merge

sort id

merge id using "/Users/andrewbell/Documents/Project work/Nature+ Kenya/DCE Analysis/group_gender.dta"

/////////

rename Howoldareyou age
rename Whatbestdescribesthelevelof edu 
encode edu, gen(edu_n)
drop edu
recode edu_n (4=1 "None") (5=2 "Some primary") (1=3 "Complete primary") (6=4 "Some secondary") ///
(2=5 "Complete secondary") (7=6 "Some tertiary") (3=7 "Complete tertiary"), generate(edu)

encode location, gen(site)
encode gender, gen(gender_n)
encode earnings, gen(earn_n)
encode bad_earnings, gen(bad_n)


rename Peopleshouldbeabletoraiseh belief_animals
encode belief_animals, gen(belief_animals_n)
drop belief_animals
recode belief_animals_n (3=1 "Strongly agree") (1=2 "Agree") (2=3 "Disagree") (4=4 "Strongly disagree") ///
, generate(belief_animals)


rename Ourlanduseincludingfarming belief_landuse
encode belief_landuse, gen(belief_landuse_n)
drop belief_landuse
recode belief_landuse_n (3=1 "Strongly agree") (1=2 "Agree") (2=3 "Disagree") (4=4 "Strongly disagree") ///
, generate(belief_landuse)

rename Communitymembersshouldcoopera belief_invest
encode belief_invest, gen(belief_invest_n)
drop belief_invest
recode belief_invest_n (3=1 "Strongly agree") (1=2 "Agree") (2=3 "Disagree") (4=4 "Strongly disagree") ///
, generate(belief_invest)

rename Communitymembersshouldactcol belief_manage
encode belief_manage, gen(belief_manage_n)
drop belief_manage
recode belief_manage_n (3=1 "Strongly agree") (1=2 "Agree") (2=3 "Disagree") (4=4 "Strongly disagree") ///
, generate(belief_manage)

rename BX belief_markets
encode belief_markets, gen(belief_markets_n)
drop belief_markets
recode belief_markets_n (3=1 "Strongly agree") (1=2 "Agree") (2=3 "Disagree") (4=4 "Strongly disagree") ///
, generate(belief_markets)

drop belief_*_n

gen land = Abouthowmuchlanddoyouculti
replace land = land / 2.47 if units == "acres"
replace land = land / 2.47 / 100 if units == "points"

gen diff_cons = cons_frac - cons_frac_pre
gen diff_earn = earnings_scale - earnings_scale_pre
gen diff_bad = bad_earnings_scale - bad_earnings_scale_pre
gen diff_self = time_self - time_self_pre
gen diff_share = time_share - time_self_pre

gen earn_gap = earnings_scale - bad_earnings_scale

gen ms_share_gap = time_share / earn_gap

local reg_list age edu i.gender_n i.site land belief* //Cattle earn_n bad_n

//reg earn_gap `reg_list'
//reg ms_share_gap `reg_list'

reg cons_frac_pre `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(cons_frac_pre) replace 
reg cons_frac `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(cons_frac)
reg diff_cons `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(diff_cons)

reg earnings_scale_pre `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(earn_pre) 
reg earnings_scale `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(earn)
reg diff_earn `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(diff_earn)

reg bad_earnings_scale_pre `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(bad_pre) 
reg bad_earnings_scale `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(bad)
reg diff_bad `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(diff_bad)

reg time_self_pre `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(self_pre) 
reg time_self `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(self)
reg diff_self `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(diff_self)

reg time_share_pre `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(share_pre) 
reg time_share `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(share)
reg diff_share `reg_list'
outreg2 using dce_hetero.xls, stats(coef) excel ctitle(diff_share)

clear 

use choice_data_stata

gen earnings_scale = earnings / 800000
gen bad_earnings_scale = bad_earnings / 800000

gen earnings_share = earnings_scale * time_share
gen bad_share = bad_earnings_scale * time_share
gen earnings_self = earnings_scale * time_self
gen bad_self = earnings_scale * time_self

gen earning_gap = bad_earnings_scale / earnings_scale

mixlogit choice, ///
	group(group) /// each individual choice is identified by decision_id
	id(id) /// each person is identified by id
	rand(cons_frac earnings_scale bad_earnings_scale time_self time_share earnings_share bad_share earning_gap) 

	
	
	drop if pre_post == 2
	
mixlogit choice, ///
	group(group) /// each individual choice is identified by decision_id
	id(id) /// each person is identified by id
	rand(cons_frac earnings_scale bad_earnings_scale time_self time_share earnings_share bad_share earning_gap) 

	outreg2 using dce_main_only.xls, stats(coef) excel ctitle(Pre) replace 
	
	mixlbeta cons_frac earnings_scale bad_earnings time_self time_share earnings_share bad_share, saving(rand_coeffs_dce_pre.dta) replace

	clear 

use choice_data_stata

gen earnings_scale = earnings / 800000
gen bad_earnings_scale = bad_earnings / 800000

gen earnings_share = earnings_scale * time_share
gen bad_share = bad_earnings_scale * time_share
gen earnings_self = earnings_scale * time_self
gen bad_self = earnings_scale * time_self

gen earning_gap = bad_earnings_scale / earnings_scale

drop if pre_post == 1
mixlogit choice, ///
	group(group) /// each individual choice is identified by decision_id
	id(id) /// each person is identified by id
	rand(cons_frac earnings_scale bad_earnings_scale time_self time_share earnings_share bad_share earning_gap) 
	
	outreg2 using dce_main_only.xls, stats(coef) excel ctitle(Post)
	
mixlbeta cons_frac earnings_scale bad_earnings time_self time_share earnings_share bad_share, saving(rand_coeffs_dce_post.dta) replace


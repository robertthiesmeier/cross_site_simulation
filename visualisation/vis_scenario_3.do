/*

Visualisation for Scenario 3

*/ 

cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2"


********************************************************************************
*** Scenario 3_1 ***
********************************************************************************

*** theta_1 ****
cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen tau = .
    gen mean_imp = .
    gen mean_cc = .
	gen mean_noadj = .
	gen mean_true = .
	gen se_imp = . 
	gen se_cc = . 
	gen se_noadj = . 
	gen se_true = .
}

local k = 1 
forv i = 0.1(0.1)0.6{
	qui use "data/data_sim_scenario_3_1_`i'.dta", replace
	 
	qui su b1_imp
    local mimp = r(mean)
	
	qui su b1_cc
    local mcc = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
	qui su se_b1_imp
	local se_imp = r(mean)
	
	qui su se_b1_cc
	local se_cc = r(mean)
	
	qui su se_b1_na
	local se_noadj = r(mean)
	
	qui su se_b1_true
	local se_true = r(mean)

    frame sumres {
       qui replace tau = `i' if _n == `k'
       qui replace mean_imp = `mimp' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
	   replace se_imp = `se_imp' if _n == `k'
	   replace se_cc = `se_cc' if _n == `k'
	   replace se_noadj = `se_noadj' if _n == `k'
	   replace se_true = `se_true' if _n == `k'
    }
  
	local ++k
}

// graph

frame sumres{
	
	sort tau

	gen imp_lo = mean_imp - se_imp
	gen imp_hi = mean_imp + se_imp

	gen cc_lo = mean_cc - se_cc
	gen cc_hi = mean_cc + se_cc

	gen na_lo = mean_noadj - se_noadj
	gen na_hi = mean_noadj + se_noadj

	gen true_lo = mean_true  - se_true
	gen true_hi  = mean_true  + se_true

}

frame sumres{
	twoway ///
		(line imp_lo tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line imp_hi tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line mean_imp tau, lwidth(medthick) lcolor(midblue)) ///   
		(rarea imp_lo imp_hi tau, fcolor(midblue%20) lcolor(%0)) ///
		(line cc_lo tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line cc_hi tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line mean_cc tau,  lwidth(medthick) lcolor(cranberry)) ///
		(rarea cc_lo cc_hi tau, fcolor(cranberry%20) lcolor(%0)) ///
		(line true_lo tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line true_hi tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line mean_true tau,  lwidth(medthick) lcolor(gold)) ///
		(rarea true_lo true_hi tau, fcolor(gold%20) lcolor(%0)) ///
		(line na_lo tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line na_hi tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line mean_noadj tau,  lwidth(medthick) lcolor(eltgreen)) ///
		(rarea na_lo na_hi tau, fcolor(eltgreen%20) lcolor(%0)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(11 "Ref" 7 "CCA" 15 "No adjustment" 3 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_3_1_b1", replace

*** theta_2 ****
cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen tau = .
    gen mean_imp = .
    gen mean_cc = .
	gen mean_true = .
	gen se_imp = . 
	gen se_cc = . 
	gen se_true = .
}

local k = 1 
forv i = 0.1(0.1)0.6{
	qui use "data/data_sim_scenario_3_1_`i'.dta", replace
	 
	qui su b2_imp
    local mimp = r(mean)
	
	qui su b2_cc
    local mcc = r(mean)
	
	qui su b2_true
	local mtrue = r(mean)
	
	qui su se_b2_imp
	local se_imp = r(mean)
	
	qui su se_b2_cc
	local se_cc = r(mean)
	
	qui su se_b2_true
	local se_true = r(mean)

    frame sumres {
       qui replace tau = `i' if _n == `k'
       qui replace mean_imp = `mimp' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
	   replace se_imp = `se_imp' if _n == `k'
	   replace se_cc = `se_cc' if _n == `k'
	   replace se_true = `se_true' if _n == `k'
    }
  
	local ++k
}

// graph

frame sumres{
	
	sort tau

	gen imp_lo = mean_imp - se_imp
	gen imp_hi = mean_imp + se_imp

	gen cc_lo = mean_cc - se_cc
	gen cc_hi = mean_cc + se_cc

	gen true_lo = mean_true  - se_true
	gen true_hi  = mean_true  + se_true

}

frame sumres{
	twoway ///
		(line imp_lo tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line imp_hi tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line mean_imp tau, lwidth(medthick) lcolor(midblue) msymbol(O) mcolor(blue)) ///   
		(rarea imp_lo imp_hi tau, fcolor(midblue%20) lcolor(%0)) ///
		(line cc_lo tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line cc_hi tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line mean_cc tau,  lwidth(medthick) lcolor(cranberry) msymbol(^) mcolor(red)) ///
		(rarea cc_lo cc_hi tau, fcolor(cranberry%20) lcolor(%0)) ///
		(line true_lo tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line true_hi tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line mean_true tau,  lwidth(medthick) lcolor(gold) msymbol(p) mcolor(yellow)) ///
		(rarea true_lo true_hi tau, fcolor(gold%20) lcolor(%0)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("{&pi}{sub:{&pi}{sub:{&Beta}}}", size(small)) ///
		ytitle("{&theta}{sub:2}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(11 "Ref" 7 "CCA" 3 "MI") ///
			   pos(6) ring(0) cols(3) size(small)) ///
		title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b2, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_3_1_b2", replace

*****************
*** Coverage *** 
*****************

*** theta 1 ***
tempname H
tempfile covdata
postfile `H' double tau double coverage str10 beta using "`covdata'", replace

forval i = 0.1(0.1)0.6 {
    qui use "data/data_sim_scenario_3_1_`i'.dta", replace     
    
	local list "b1_imp b1_cc b1_na b1_true"
    foreach k of local list {
        gen cov`k' = (abs(`k'-1) <= 1.96*se_`k')
        qui su cov`k'
        local cov = r(mean)*100 
        drop cov`k'

        post `H' (`i') (`cov') ("`k'")
    }
	
}
postclose `H'

use "`covdata'", clear
label var tau "tau"
label var coverage "Coverage (%)"

sort beta tau

twoway ///
    (scatter coverage tau if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage tau if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage tau if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage tau if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage tau if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage tau if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage tau if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage tau if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.2f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white))  name(cov_b1, replace)

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_het_scenario_3_1_b1", replace

*** theta 2 ***
tempname H
tempfile covdata
postfile `H' double tau double coverage str10 beta using "`covdata'", replace

forval i = 0.1(0.1)0.6 {
    qui use "data/data_sim_scenario_3_1_`i'.dta", replace     
    
	local list "b2_imp b2_cc b2_true"
    foreach k of local list {
        gen cov`k' = (abs(`k'-1) <= 1.96*se_`k')
        qui su cov`k'
        local cov = r(mean)*100 
        drop cov`k'

        post `H' (`i') (`cov') ("`k'")
    }
	
}
postclose `H'

use "`covdata'", clear
label var tau "tau"
label var coverage "Coverage (%)"

sort beta tau

twoway ///
    (scatter coverage tau if beta=="b2_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage tau if beta=="b2_cc", lcolor(cranberry)) ///
    (scatter coverage tau if beta=="b2_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage tau if beta=="b2_imp", lcolor(midblue)) ///
    (scatter coverage tau if beta=="b2_true", msymbol(t) mcolor(gold)) ///
    (line coverage tau if beta=="b2_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.2f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(5 "Ref" 1 "CCA" 3 "MI") ///
    pos(6) ring(0) cols(3) size(small)) ///
    title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white))  name(cov_b2, replace)

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_het_scenario_3_1_b2", replace
 
********************************************************************************
*** Scenario 3_2 ***
********************************************************************************

*** theta_1 ****
cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen tau = .
    gen mean_imp = .
    gen mean_cc = .
	gen mean_noadj = .
	gen mean_true = .
	gen se_imp = . 
	gen se_cc = . 
	gen se_noadj = . 
	gen se_true = .
}

local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_3_2_`i'.dta", replace
	 
	qui su b1_imp
    local mimp = r(mean)
	
	qui su b1_cc
    local mcc = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
	qui su se_b1_imp
	local se_imp = r(mean)
	
	qui su se_b1_cc
	local se_cc = r(mean)
	
	qui su se_b1_na
	local se_noadj = r(mean)
	
	qui su se_b1_true
	local se_true = r(mean)

    frame sumres {
       qui replace tau = `i' if _n == `k'
       qui replace mean_imp = `mimp' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
	   replace se_imp = `se_imp' if _n == `k'
	   replace se_cc = `se_cc' if _n == `k'
	   replace se_noadj = `se_noadj' if _n == `k'
	   replace se_true = `se_true' if _n == `k'
    }
  
	local ++k
}

// graph

frame sumres{
	
	sort tau

	gen imp_lo = mean_imp - se_imp
	gen imp_hi = mean_imp + se_imp

	gen cc_lo = mean_cc - se_cc
	gen cc_hi = mean_cc + se_cc

	gen na_lo = mean_noadj - se_noadj
	gen na_hi = mean_noadj + se_noadj

	gen true_lo = mean_true  - se_true
	gen true_hi  = mean_true  + se_true

}

frame sumres{
	twoway ///
		(line imp_lo tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line imp_hi tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line mean_imp tau, lwidth(medthick) lcolor(midblue) msymbol(O) mcolor(blue)) ///   
		(rarea imp_lo imp_hi tau, fcolor(midblue%20) lcolor(%0)) ///
		(line cc_lo tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line cc_hi tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line mean_cc tau,  lwidth(medthick) lcolor(cranberry) msymbol(^) mcolor(red)) ///
		(rarea cc_lo cc_hi tau, fcolor(cranberry%20) lcolor(%0)) ///
		(line true_lo tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line true_hi tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line mean_true tau,  lwidth(medthick) lcolor(gold) msymbol(p) mcolor(yellow)) ///
		(rarea true_lo true_hi tau, fcolor(gold%20) lcolor(%0)) ///
		(line na_lo tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line na_hi tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line mean_noadj tau,  lwidth(medthick) lcolor(eltgreen) msymbol(p) mcolor(yellow)) ///
		(rarea na_lo na_hi tau, fcolor(eltgreen%20) lcolor(%0)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("a{sub:{&Beta}} ", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(11 "Ref" 7 "CCA" 15 "No adjustment" 3 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Confounding path (a{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white))  name(bias_b1, replace)
}


graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_3_2_b1", replace

*** theta_2 ****
cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen tau = .
    gen mean_imp = .
    gen mean_cc = .
	gen mean_true = .
	gen se_imp = . 
	gen se_cc = . 
	gen se_true = .
}

local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_3_2_`i'.dta", replace
	 
	qui su b2_imp
    local mimp = r(mean)
	
	qui su b2_cc
    local mcc = r(mean)
	
	qui su b2_true
	local mtrue = r(mean)
	
	qui su se_b2_imp
	local se_imp = r(mean)
	
	qui su se_b2_cc
	local se_cc = r(mean)
	
	qui su se_b2_true
	local se_true = r(mean)

    frame sumres {
       qui replace tau = `i' if _n == `k'
       qui replace mean_imp = `mimp' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
	   replace se_imp = `se_imp' if _n == `k'
	   replace se_cc = `se_cc' if _n == `k'
	   replace se_true = `se_true' if _n == `k'
    }
  
	local ++k
}

// graph

frame sumres{
	
	sort tau

	gen imp_lo = mean_imp - se_imp
	gen imp_hi = mean_imp + se_imp

	gen cc_lo = mean_cc - se_cc
	gen cc_hi = mean_cc + se_cc

	gen true_lo = mean_true  - se_true
	gen true_hi  = mean_true  + se_true

}

frame sumres{
	twoway ///
		(line imp_lo tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line imp_hi tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line mean_imp tau, lwidth(medthick) lcolor(midblue) msymbol(O) mcolor(blue)) ///   
		(rarea imp_lo imp_hi tau, fcolor(midblue%20) lcolor(%0)) ///
		(line cc_lo tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line cc_hi tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line mean_cc tau,  lwidth(medthick) lcolor(cranberry) msymbol(^) mcolor(red)) ///
		(rarea cc_lo cc_hi tau, fcolor(cranberry%20) lcolor(%0)) ///
		(line true_lo tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line true_hi tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line mean_true tau,  lwidth(medthick) lcolor(gold) msymbol(p) mcolor(yellow)) ///
		(rarea true_lo true_hi tau, fcolor(gold%20) lcolor(%0)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("a{sub:{&Beta}} ", size(small)) ///
		ytitle("{&theta}{sub:2}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(11 "Ref" 7 "CCA" 3 "MI") ///
			   pos(6) ring(0) cols(3) size(small)) ///
		title("{bf:Confounding path (a{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b2, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_3_2_b2", replace


******************
*** Coverage *** 
******************

*** theta 1 ***
tempname H
tempfile covdata
postfile `H' double tau double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_3_2_`i'.dta", replace     
    
	local list "b1_imp b1_cc b1_na b1_true"
    foreach k of local list {
        gen cov`k' = (abs(`k'-1) <= 1.96*se_`k')
        qui su cov`k'
        local cov = r(mean)*100 
        drop cov`k'

        post `H' (`i') (`cov') ("`k'")
    }
	
}
postclose `H'

use "`covdata'", clear
label var tau "tau"
label var coverage "Coverage (%)"

sort beta tau

twoway ///
    (scatter coverage tau if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage tau if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage tau if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage tau if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage tau if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage tau if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage tau if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage tau if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("a{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.2f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path (a{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(cov_b1, replace)

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_het_scenario_3_2_b1", replace

*** theta 2 ***
tempname H
tempfile covdata
postfile `H' double tau double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_3_2_`i'.dta", replace     
    
	local list "b2_imp b2_cc b2_true"
    foreach k of local list {
        gen cov`k' = (abs(`k'-1) <= 1.96*se_`k')
        qui su cov`k'
        local cov = r(mean)*100 
        drop cov`k'

        post `H' (`i') (`cov') ("`k'")
    }
	
}
postclose `H'

use "`covdata'", clear
label var tau "tau"
label var coverage "Coverage (%)"

sort beta tau

twoway ///
    (scatter coverage tau if beta=="b2_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage tau if beta=="b2_cc", lcolor(cranberry)) ///
    (scatter coverage tau if beta=="b2_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage tau if beta=="b2_imp", lcolor(midblue)) ///
    (scatter coverage tau if beta=="b2_true", msymbol(t) mcolor(gold)) ///
    (line coverage tau if beta=="b2_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("a{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.2f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(5 "Ref" 1 "CCA" 3 "MI") ///
    pos(6) ring(0) cols(3) size(small)) ///
    title("{bf:Confounding path (a{sub:{&Beta}}))}", size(medium) color(black)) ///
    graphregion(color(white)) name(cov_b2, replace)

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_het_scenario_3_2_b2", replace

********************************************************************************
*** Scenario 3.3 ***
********************************************************************************

*** theta_1 ****
cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen tau = .
    gen mean_imp = .
    gen mean_cc = .
	gen mean_noadj = .
	gen mean_true = .
	gen se_imp = . 
	gen se_cc = . 
	gen se_noadj = . 
	gen se_true = .
}

local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_3_3_`i'.dta", replace
	 
	qui su b1_imp
    local mimp = r(mean)
	
	qui su b1_cc
    local mcc = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
	qui su se_b1_imp
	local se_imp = r(mean)
	
	qui su se_b1_cc
	local se_cc = r(mean)
	
	qui su se_b1_na
	local se_noadj = r(mean)
	
	qui su se_b1_true
	local se_true = r(mean)

    frame sumres {
       qui replace tau = `i' if _n == `k'
       qui replace mean_imp = `mimp' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
	   replace se_imp = `se_imp' if _n == `k'
	   replace se_cc = `se_cc' if _n == `k'
	   replace se_noadj = `se_noadj' if _n == `k'
	   replace se_true = `se_true' if _n == `k'
    }
  
	local ++k
}

// graph

frame sumres{
	
	sort tau

	gen imp_lo = mean_imp - se_imp
	gen imp_hi = mean_imp + se_imp

	gen cc_lo = mean_cc - se_cc
	gen cc_hi = mean_cc + se_cc

	gen na_lo = mean_noadj - se_noadj
	gen na_hi = mean_noadj + se_noadj

	gen true_lo = mean_true  - se_true
	gen true_hi  = mean_true  + se_true

}

frame sumres{
	twoway ///
		(line imp_lo tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line imp_hi tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line mean_imp tau, lwidth(medthick) lcolor(midblue) msymbol(O) mcolor(blue)) ///   
		(rarea imp_lo imp_hi tau, fcolor(midblue%20) lcolor(%0)) ///
		(line cc_lo tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line cc_hi tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line mean_cc tau,  lwidth(medthick) lcolor(cranberry) msymbol(^) mcolor(red)) ///
		(rarea cc_lo cc_hi tau, fcolor(cranberry%20) lcolor(%0)) ///
		(line true_lo tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line true_hi tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line mean_true tau,  lwidth(medthick) lcolor(gold) msymbol(p) mcolor(yellow)) ///
		(rarea true_lo true_hi tau, fcolor(gold%20) lcolor(%0)) ///
		(line na_lo tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line na_hi tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line mean_noadj tau,  lwidth(medthick) lcolor(eltgreen) msymbol(p) mcolor(yellow)) ///
		(rarea na_lo na_hi tau, fcolor(eltgreen%20) lcolor(%0)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("c{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(11 "Ref" 7 "CCA" 15 "No adjustment" 3 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Confounding path shift (c{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white))  name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_3_3_b1", replace

***** Coverage *****

*** theta 1 ***
tempname H
tempfile covdata
postfile `H' double tau double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_3_3_`i'.dta", replace     
    
	local list "b1_imp b1_cc b1_na b1_true"
    foreach k of local list {
        gen cov`k' = (abs(`k'-1) <= 1.96*se_`k')
        qui su cov`k'
        local cov = r(mean)*100 
        drop cov`k'

        post `H' (`i') (`cov') ("`k'")
    }
	
}
postclose `H'

use "`covdata'", clear
label var tau "tau"
label var coverage "Coverage (%)"

sort beta tau

twoway ///
    (scatter coverage tau if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage tau if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage tau if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage tau if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage tau if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage tau if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage tau if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage tau if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("c{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.2f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path shift (c{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white))  name(cov_b1, replace)

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_het_scenario_3_3_b1", replace

********************************************************************************
*** Scenario 3.4 ***
********************************************************************************

*** theta_1 ****
cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen tau = .
    gen mean_imp = .
    gen mean_cc = .
	gen mean_noadj = .
	gen mean_true = .
	gen se_imp = . 
	gen se_cc = . 
	gen se_noadj = . 
	gen se_true = .
}

local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_3_4_`i'.dta", replace
	 
	qui su b1_imp
    local mimp = r(mean)
	
	qui su b1_cc
    local mcc = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
	qui su se_b1_imp
	local se_imp = r(mean)
	
	qui su se_b1_cc
	local se_cc = r(mean)
	
	qui su se_b1_na
	local se_noadj = r(mean)
	
	qui su se_b1_true
	local se_true = r(mean)

    frame sumres {
       qui replace tau = `i' if _n == `k'
       qui replace mean_imp = `mimp' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
	   replace se_imp = `se_imp' if _n == `k'
	   replace se_cc = `se_cc' if _n == `k'
	   replace se_noadj = `se_noadj' if _n == `k'
	   replace se_true = `se_true' if _n == `k'
    }
  
	local ++k
}

// graph

frame sumres{
	
	sort tau

	gen imp_lo = mean_imp - se_imp
	gen imp_hi = mean_imp + se_imp

	gen cc_lo = mean_cc - se_cc
	gen cc_hi = mean_cc + se_cc

	gen na_lo = mean_noadj - se_noadj
	gen na_hi = mean_noadj + se_noadj

	gen true_lo = mean_true  - se_true
	gen true_hi  = mean_true  + se_true

}

frame sumres{
	twoway ///
		(line imp_lo tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line imp_hi tau, lwidth(medium) lcolor(midblue) lpattern(dash)) ///
		(line mean_imp tau, lwidth(medthick) lcolor(midblue) msymbol(O) mcolor(blue)) ///   
		(rarea imp_lo imp_hi tau, fcolor(midblue%20) lcolor(%0)) ///
		(line cc_lo tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line cc_hi tau, lcolor(cranberry) lwidth(medium) lpattern(dash)) ///
		(line mean_cc tau,  lwidth(medthick) lcolor(cranberry) msymbol(^) mcolor(red)) ///
		(rarea cc_lo cc_hi tau, fcolor(cranberry%20) lcolor(%0)) ///
		(line true_lo tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line true_hi tau, lcolor(gold) lwidth(medium) lpattern(dash)) ///
		(line mean_true tau,  lwidth(medthick) lcolor(gold) msymbol(p) mcolor(yellow)) ///
		(rarea true_lo true_hi tau, fcolor(gold%20) lcolor(%0)) ///
		(line na_lo tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line na_hi tau, lcolor(eltgreen) lwidth(medium) lpattern(dash)) ///
		(line mean_noadj tau,  lwidth(medthick) lcolor(eltgreen) msymbol(p) mcolor(yellow)) ///
		(rarea na_lo na_hi tau, fcolor(eltgreen%20) lcolor(%0)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("a{sub:{&Beta}} & c{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(11 "Ref" 7 "CCA" 15 "No adjustment" 3 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Confounding path shift (a{sub:{&Beta}} and c{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white))  name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_3_4_b1", replace

***** Coverage *****

*** theta 1 ***
tempname H
tempfile covdata
postfile `H' double tau double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_3_4_`i'.dta", replace     
    
	local list "b1_imp b1_cc b1_na b1_true"
    foreach k of local list {
        gen cov`k' = (abs(`k'-1) <= 1.96*se_`k')
        qui su cov`k'
        local cov = r(mean)*100 
        drop cov`k'

        post `H' (`i') (`cov') ("`k'")
    }
	
}
postclose `H'

use "`covdata'", clear
label var tau "tau"
label var coverage "Coverage (%)"

sort beta tau

twoway ///
    (scatter coverage tau if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage tau if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage tau if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage tau if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage tau if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage tau if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage tau if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage tau if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("a{sub:{&Beta}} & c{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.2f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path shift (a{sub:{&Beta}} and c{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white))  name(cov_b1, replace)

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_het_scenario_3_4_b1", replace

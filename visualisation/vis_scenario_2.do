/*

Visualisations for Scenario 2

*/ 

clear all 
cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2"

********************************************************************************
*** Scenario 2.1 ***
********************************************************************************

***************
*** Bias *** 
***************

cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 6
    gen pi1 = .
    gen mean_cc = .
	gen mean_imp = .
	gen mean_noadj = .
	gen mean_true = . 
}

// for b1 
local k = 1 
forv i = .1(.1).6{
	qui use "data/data_sim_scenario_2_1_`i'.dta", replace
	
    qui su b1_cc
    local mcc  = r(mean)
	
	qui su b1_imp
    local mmeta  = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
    frame sumres {
       qui replace pi1 = `i' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
       qui replace mean_imp = `mmeta'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
    }
    
	local ++k
}


frame sumres{
	twoway ///
		(scatter mean_imp pi1, msymbol(d) mcolor(midblue)) /// 
		(scatter mean_cc pi1, msymbol(s) mcolor(cranberry)) /// 
		(scatter mean_noadj pi1, msymbol(o) mcolor(eltgreen)) /// 
		(scatter mean_true pi1, msymbol(t) mcolor(gold)) /// 
		(line mean_imp pi1, lwidth(medthick) lcolor(midblue)) ///   
		(line mean_cc pi1, lwidth(medthick) lcolor(cranberry)) ///
		(line mean_true pi1, lwidth(medthick) lcolor(gold)) ///
		(line mean_noadj pi1, lwidth(medthick) lcolor(eltgreen)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(7 "Ref" 6 "CCA" 8 "No adjustment" 5 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_2_1_b1", replace

// for b2
local k = 1 
forv i = .1(.1).6{
	qui use "data/data_sim_scenario_2_1_`i'.dta", replace
	
    qui su b2_cc
    local mcc  = r(mean)
	
	qui su b2_imp
    local mmeta  = r(mean)
	
	qui su b2_true
	local mtrue = r(mean)
	
    frame sumres {
       qui replace pi1 = `i' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
       qui replace mean_imp = `mmeta'  if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
    }
    
	local ++k
}


frame sumres{
	twoway ///
		(scatter mean_imp pi1, msymbol(d) mcolor(midblue)) /// 
		(scatter mean_cc pi1, msymbol(s) mcolor(cranberry)) /// 
		(scatter mean_true pi1, msymbol(t) mcolor(gold)) /// 
		(line mean_imp pi1, lwidth(medthick) lcolor(midblue)) ///   
		(line mean_cc pi1,  lwidth(medthick) lcolor(cranberry)) ///
		(line mean_true pi1,  lwidth(medthick) lcolor(gold)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:2}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(6 "Ref" 5 "CCA" 4 "MI") ///
			   pos(6) ring(0) cols(3) size(small)) ///
		title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b2, replace)
}
graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_2_1_b2", replace
 
********************************************************************************
*** Coverage *** 
********************************************************************************

// b1
tempname H
tempfile covdata
postfile `H' double pi1 double coverage str10 beta using "`covdata'", replace

forval i = 0.1(0.1)0.6 {
    qui use "data/data_sim_scenario_2_1_`i'.dta", clear
    
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
label var pi1 "pi1"
label var coverage "Coverage (%)"

sort beta pi1

twoway ///
    (scatter coverage pi1 if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage pi1 if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage pi1 if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage pi1 if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage pi1 if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage pi1 if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage pi1 if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage pi1 if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.1f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(covb1, replace)
	

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_scenario_2_1_b1"	, replace

// b2 
tempname H
tempfile covdata
postfile `H' double pi1 double coverage str10 beta using "`covdata'", replace

forval i = 0.1(0.1)0.6 {
    qui use "data/data_sim_scenario_2_1_`i'.dta", clear
    
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
label var pi1 "pi1"
label var coverage "Coverage (%)"

sort beta pi1

twoway ///
    (scatter coverage pi1 if beta=="b2_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage pi1 if beta=="b2_cc", lcolor(cranberry)) ///
    (scatter coverage pi1 if beta=="b2_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage pi1 if beta=="b2_imp", lcolor(midblue)) ///
    (scatter coverage pi1 if beta=="b2_true", msymbol(t) mcolor(gold)) ///
    (line coverage pi1 if beta=="b2_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("{&pi}{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.1f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(5 "Ref" 1 "CCA" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Prevalence shift ({&pi}{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(covb2, replace)
	
graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_scenario_2_1_b2", replace

********************************************************************************
*** Scenario 2.2 ***
********************************************************************************

**************
*** Bias *** 
**************

cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen a1 = .
    gen mean_cc = .
	gen mean_imp = .
	gen mean_noadj = .
	gen mean_true = . 
}

// for b1 
local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_2_2_`i'.dta", replace
	
    qui su b1_cc
    local mcc  = r(mean)
	
	qui su b1_imp
    local mmeta  = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
    frame sumres {
       qui replace a1 = `i' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
       qui replace mean_imp = `mmeta'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
    }
    
	local ++k
}


frame sumres{
	twoway ///
		(scatter mean_imp a1, msymbol(d) mcolor(midblue)) /// 
		(scatter mean_cc a1, msymbol(s) mcolor(cranberry)) /// 
		(scatter mean_noadj a1, msymbol(o) mcolor(eltgreen)) /// 
		(scatter mean_true a1, msymbol(t) mcolor(gold)) /// 
		(line mean_imp a1, lwidth(medthick) lcolor(midblue)) ///   
		(line mean_cc a1, lwidth(medthick) lcolor(cranberry)) ///
		(line mean_true a1, lwidth(medthick) lcolor(gold)) ///
		(line mean_noadj a1, lwidth(medthick) lcolor(eltgreen)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("a{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(7 "Ref" 6 "CCA" 8 "No adjustment" 5 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Confounding path shift (a{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_2_2_b1", replace

// for b2
local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_2_2_`i'.dta", replace
	
    qui su b2_cc
    local mcc  = r(mean)
	
	qui su b2_imp
    local mmeta  = r(mean)
	
	qui su b2_true
	local mtrue = r(mean)
	
    frame sumres {
       qui replace a1 = `i' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
       qui replace mean_imp = `mmeta'  if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
    }
    
	local ++k
}


frame sumres{
	twoway ///
		(scatter mean_imp a1, msymbol(d) mcolor(midblue)) /// 
		(scatter mean_cc a1, msymbol(s) mcolor(cranberry)) /// 
		(scatter mean_true a1, msymbol(t) mcolor(gold)) /// 
		(line mean_imp a1, lwidth(medthick) lcolor(midblue)) ///   
		(line mean_cc a1,  lwidth(medthick) lcolor(cranberry)) ///
		(line mean_true a1,  lwidth(medthick) lcolor(gold)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("a{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:2}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(6 "Ref" 5 "CCA" 4 "MI") ///
			   pos(6) ring(0) cols(3) size(small)) ///
		title("{bf:Confounding path shift (a{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b2, replace)
}
graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_2_2_b2", replace
 
*****************
*** Coverage *** 
******************

// b1
tempname H
tempfile covdata
postfile `H' double a1 double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_2_2_`i'.dta", clear
    
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
label var a1 "a1"
label var coverage "Coverage (%)"

sort beta a1

twoway ///
    (scatter coverage a1 if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage a1 if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage a1 if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage a1 if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage a1 if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage a1 if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage a1 if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage a1 if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("a{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.1f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path shift (a{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(covb1, replace)
	

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_scenario_2_2_b1"	, replace

// b2 
tempname H
tempfile covdata
postfile `H' double a1 double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_2_2_`i'.dta", clear
    
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
label var a1 "a1"
label var coverage "Coverage (%)"

sort beta a1

twoway ///
    (scatter coverage a1 if beta=="b2_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage a1 if beta=="b2_cc", lcolor(cranberry)) ///
    (scatter coverage a1 if beta=="b2_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage a1 if beta=="b2_imp", lcolor(midblue)) ///
    (scatter coverage a1 if beta=="b2_true", msymbol(t) mcolor(gold)) ///
    (line coverage a1 if beta=="b2_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("a{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.1f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(5 "Ref" 1 "CCA" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path shift (a{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(covb2, replace)
	
graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_scenario_2_2_b2", replace


********************************************************************************
*** Scenario 2.3 ***
********************************************************************************

**************
*** Bias *** 
**************

cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen a1 = .
    gen mean_cc = .
	gen mean_imp = .
	gen mean_noadj = .
	gen mean_true = . 
}

// for b1 
local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_2_3_`i'.dta", replace
	
    qui su b1_cc
    local mcc  = r(mean)
	
	qui su b1_imp
    local mmeta  = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
    frame sumres {
       qui replace a1 = `i' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
       qui replace mean_imp = `mmeta'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
    }
    
	local ++k
}


frame sumres{
	twoway ///
		(scatter mean_imp a1, msymbol(d) mcolor(midblue)) /// 
		(scatter mean_cc a1, msymbol(s) mcolor(cranberry)) /// 
		(scatter mean_noadj a1, msymbol(o) mcolor(eltgreen)) /// 
		(scatter mean_true a1, msymbol(t) mcolor(gold)) /// 
		(line mean_imp a1, lwidth(medthick) lcolor(midblue)) ///   
		(line mean_cc a1, lwidth(medthick) lcolor(cranberry)) ///
		(line mean_true a1, lwidth(medthick) lcolor(gold)) ///
		(line mean_noadj a1, lwidth(medthick) lcolor(eltgreen)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("c{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(7 "Ref" 6 "CCA" 8 "No adjustment" 5 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Confounding path shift (c{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_2_3_b1", replace

******************
*** Coverage *** 
******************
// b1
tempname H
tempfile covdata
postfile `H' double a1 double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_2_3_`i'.dta", clear
    
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
label var a1 "a1"
label var coverage "Coverage (%)"

sort beta a1

twoway ///
    (scatter coverage a1 if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage a1 if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage a1 if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage a1 if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage a1 if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage a1 if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage a1 if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage a1 if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("c{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.1f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path shift (c{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(covb1, replace)
	

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_scenario_2_3_b1"	, replace

********************************************************************************
*** Scenario 2.4 ***
********************************************************************************

*************
*** Bias *** 
*************

cap frame drop sumres
frame create sumres
frame sumres {
    clear
    set obs 7
    gen a1 = .
    gen mean_cc = .
	gen mean_imp = .
	gen mean_noadj = .
	gen mean_true = . 
}

// for b1 
local k = 1 
forv i = 0(0.5)3{
	qui use "data/data_sim_scenario_2_4_`i'.dta", replace
	
    qui su b1_cc
    local mcc  = r(mean)
	
	qui su b1_imp
    local mmeta  = r(mean)
	
	qui su b1_na
	local mna = r(mean)
	
	qui su b1_true
	local mtrue = r(mean)
	
    frame sumres {
       qui replace a1 = `i' if _n == `k'
       qui replace mean_cc = `mcc'  if _n == `k'
       qui replace mean_imp = `mmeta'  if _n == `k'
	   qui replace mean_noadj = `mna' if _n == `k'
	   qui replace mean_true = `mtrue' if _n == `k'
    }
    
	local ++k
}


frame sumres{
	twoway ///
		(scatter mean_imp a1, msymbol(d) mcolor(midblue)) /// 
		(scatter mean_cc a1, msymbol(s) mcolor(cranberry)) /// 
		(scatter mean_noadj a1, msymbol(o) mcolor(eltgreen)) /// 
		(scatter mean_true a1, msymbol(t) mcolor(gold)) /// 
		(line mean_imp a1, lwidth(medthick) lcolor(midblue)) ///   
		(line mean_cc a1, lwidth(medthick) lcolor(cranberry)) ///
		(line mean_true a1, lwidth(medthick) lcolor(gold)) ///
		(line mean_noadj a1, lwidth(medthick) lcolor(eltgreen)) ///
		, ///
		yline(1, lcolor(black) lpattern(dash)) ///
		xtitle("a{sub:{&Beta}} & c{sub:{&Beta}}", size(small)) ///
		ytitle("{&theta}{sub:1}", size(small)) ///
		ylabel(, labsize(small) format(%3.2f) nogrid) ///
		xlabel(#6, labsize(small) nogrid format(%3.2f)) ///
		legend(order(7 "Ref" 6 "CCA" 8 "No adjustment" 5 "MI") ///
			   pos(6) ring(0) cols(4) size(small)) ///
		title("{bf:Confounding path shift (a{sub:{&Beta}} & c{sub:{&Beta}})}", size(med)) ///
		graphregion(color(white)) name(bias_b1, replace)
}

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/scenario_2_4_b1", replace

*****************
*** Coverage *** 
*****************

// b1
tempname H
tempfile covdata
postfile `H' double a1 double coverage str10 beta using "`covdata'", replace

forval i = 0(0.5)3 {
    qui use "data/data_sim_scenario_2_4_`i'.dta", clear
    
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
label var a1 "a1"
label var coverage "Coverage (%)"

sort beta a1

twoway ///
    (scatter coverage a1 if beta=="b1_cc",  msymbol(s) mcolor(cranberry)) ///
    (line coverage a1 if beta=="b1_cc", lcolor(cranberry)) ///
    (scatter coverage a1 if beta=="b1_imp", msymbol(d) mcolor(midblue)) ///
    (line coverage a1 if beta=="b1_imp", lcolor(midblue)) ///
    (scatter coverage a1 if beta=="b1_na", msymbol(o) mcolor(eltgreen)) ///
    (line coverage a1 if beta=="b1_na", lcolor(eltgreen)) ///
    (scatter coverage a1 if beta=="b1_true", msymbol(t) mcolor(gold)) ///
    (line coverage a1 if beta=="b1_true", lcolor(gold)) ///
    , ///
    ytitle("Coverage (%)", size(small )) xtitle("a{sub:{&Beta}} & c{sub:{&Beta}}", size(small)) ///
	yscale(range(0 105)) ylabel(0(10)100, labsize(small) nogrid) ///
	xlab(#6, labsize(small) nogrid format(%3.1f)) ///
    yline(95, lpattern(dash) lwidth(thin) lcolor(gs8)) ///
    legend(order(7 "Ref" 1 "CCA" 5 "No adjustment" 3 "MI") ///
    pos(6) ring(0) cols(4) size(small)) ///
    title("{bf:Confounding path shift (a{sub:{&Beta}} & c{sub:{&Beta}})}", size(medium) color(black)) ///
    graphregion(color(white)) name(covb1, replace)
	

graph save "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures/coverage_scenario_2_4_b1"	, replace

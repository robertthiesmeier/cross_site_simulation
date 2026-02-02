*** Methods ****

// characterization of descriptive statistics, when study bias can be expected or is large

clear all 
cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2"
run "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2/scenarios_uvma/dgm_final.do"

cap frame drop meta
frame create meta
frame meta{
	set obs 10
	gen effect = .
	gen se = .
	gen study = .
}

cap frame drop crude
frame create crude
frame crude{
	set obs 10
	gen effect = .
	gen se = .
	gen study = .
}


set seed 5875
********************************************************************************
// Applied example 1: no bias, but heterogeneity
********************************************************************************
dgm, nstud(10) n(1000) tau_alpha(0.6) tau_b(0.6) tau_pi(0.6) tau_a(0.6) tau_c(0.6) 

preserve
keep if s < 6 
tab s 
tabstat y , stats(mean sd) format(%3.2f)
tabstat x , by(s) stats(mean sd) format(%3.2f)
restore 

preserve
keep if s > 5 
tab s 
tabstat y , stats(mean sd) format(%3.2f)
tabstat x , by(s) stats(mean sd) format(%3.2f)
restore 

// crude effect in source
forv k = 1/5{
	
	reg y x if s == `k'
	
	frame crude{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}

frame crude: meta set effect se
frame crude: meta summarize,  random(reml)

// crude effect in target
forv k = 6/10{
	
	reg y x if s == `k'
	
	frame crude{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}


frame crude: drop if study < 6
frame crude: li 

frame crude: meta set effect se
frame crude: meta summarize,  random(reml)

** run the analyses ***
// reference
forv k = 1/10{
	
	reg y x z if s == `k'
	
	frame meta{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}

frame meta: meta set effect se
frame meta: meta summarize,  random(reml)
		
scalar b1_ref = r(theta)
scalar b1_ref_se = r(se)

// no adjustment
forv k = 6/10 {
	reg y x if s == `k'
	
	frame meta: replace effect = _b[x] if _n == `k'
	frame meta: replace se = _se[x] if _n == `k'

}
	
frame meta: meta set effect se
frame meta: meta summarize, random(reml)
	
scalar b1_na = r(theta)
scalar b1_na_se = r(se)

// set to missing
forv k = 6/10{
	replace z = . if s == `k'
	
	frame meta: replace effect = . if _n == `k'
	frame meta: replace se = . if _n == `k'
} 
		
// complete case 
frame meta: meta set effect se
frame meta: meta summarize, random(reml)

scalar b1_cc = r(theta)
scalar b1_cc_se = r(se)

forv k = 1/5 {
		
	logit z y x if s == `k'
	
	mat get_b_`k' = e(b)
	mat get_v_`k' = e(V)
		
}
	
cap frame drop random_impmodel  
frame create random_impmodel study y1 y2 y3 v11 v12 v13 v22 v23 v33

forv t = 1/5 {
    
	mat b = get_b_`t'
	mat V = get_v_`t'

	qui frame post random_impmodel ///
		(`t') (b[1,1]) (b[1,2]) (b[1,3]) ///
		(V[1,1]) (V[1,2]) (V[1,3]) (V[2,2]) (V[2,3]) (V[3,3])
}
	 
frame random_impmodel: meta mvregress y* , ///
	wcovvariables(v*) random(reml, covariance(independent))

// mi impute from
mat ib = e(b)[1, 1..3]
mat colnames ib = y x _cons
mat iV = e(V)[1..3, 1..3]
mat colnames iV = y x _cons
mat rownames iV = y x _cons
		 
forv k = 6/10 {
	
	preserve
		keep if s == `k'
		mi set wide
		mi register imputed z
			
		mi impute from z , b(ib) v(iV) add(10) imodel(logit)
		mi estimate, post: reg y x z
	
		frame meta: replace effect = _b[x] if _n == `k'
		frame meta: replace se = _se[x] if _n == `k'

	restore
}


frame meta: meta set effect se
frame meta: meta summarize, random(reml) 
	
scalar b1_imp = r(theta)
scalar b1_imp_se =  r(se) 

 
********************************************************************************
// No heterogeneity but systematic shifts
********************************************************************************
dgm, nstud(10) n(1000) a1(3) c1(3)

cap frame drop crude
frame create crude
frame crude{
	set obs 10
	gen effect = .
	gen se = .
	gen study = .
}

preserve
keep if s < 6 
tab s 
tabstat y , stats(mean sd) format(%3.2f)
tabstat x , by(s) stats(mean sd) format(%3.2f)
restore 

preserve
keep if s > 5 
tab s 
tabstat y , stats(mean sd) format(%3.2f)
tabstat x , by(s) stats(mean sd) format(%3.2f)
restore 

// crude effect in source
forv k = 1/5{
	
	reg y x if s == `k'
	
	frame crude{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}

frame crude: li
frame crude: meta set effect se
frame crude: meta summarize,  random(reml)

// crude effect in target
forv k = 6/10{
	
	reg y x if s == `k'
	
	frame crude{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}


frame crude: drop if study < 6
frame crude: li 

frame crude: meta set effect se
frame crude: meta summarize,  random(reml)

*** run the analyses ***
// reference
forv k = 1/10{
	
	reg y x z if s == `k'
	
	frame meta{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}

frame meta: meta set effect se
frame meta: meta summarize,  random(reml)
		
scalar b2_ref = r(theta)
scalar b2_ref_se = r(se)

// no adjustment
forv k = 6/10 {
	reg y x if s == `k'
	
	frame meta: replace effect = _b[x] if _n == `k'
	frame meta: replace se = _se[x] if _n == `k'

}
	
frame meta: meta set effect se
frame meta: meta summarize, random(reml)
	
scalar b2_na = r(theta)
scalar b2_na_se = r(se)

// set to missing
forv k = 6/10{
	replace z = . if s == `k'
	
	frame meta: replace effect = . if _n == `k'
	frame meta: replace se = . if _n == `k'
} 
		
// complete case 
frame meta: meta set effect se
frame meta: meta summarize, random(reml)
	
scalar b2_cc = r(theta)
scalar b2_cc_se = r(se)

forv k = 1/5 {
		
	logit z y x if s == `k'
	
	mat get_b_`k' = e(b)
	mat get_v_`k' = e(V)
		
}
	
cap frame drop random_impmodel  
frame create random_impmodel study y1 y2 y3 v11 v12 v13 v22 v23 v33

forv t = 1/5 {
    
	mat b = get_b_`t'
	mat V = get_v_`t'

	qui frame post random_impmodel ///
		(`t') (b[1,1]) (b[1,2]) (b[1,3]) ///
		(V[1,1]) (V[1,2]) (V[1,3]) (V[2,2]) (V[2,3]) (V[3,3])
}
	 
frame random_impmodel: meta mvregress y* , ///
	wcovvariables(v*) random(reml, covariance(unstructured))

// mi impute from
mat ib = e(b)[1, 1..3]
mat colnames ib = y x _cons
mat iV = e(V)[1..3, 1..3]
mat colnames iV = y x _cons
mat rownames iV = y x _cons
		 
forv k = 6/10 {
	
	preserve
		keep if s == `k'
		mi set wide
		mi register imputed z
			
		mi impute from z , b(ib) v(iV) add(10) imodel(logit)
		mi estimate, post: reg y x z
	
		frame meta: replace effect = _b[x] if _n == `k'
		frame meta: replace se = _se[x] if _n == `k'

	restore
}
		
frame meta: meta set effect se
frame meta: meta summarize, random(reml) 
	
scalar b2_imp = r(theta)
scalar b2_imp_se = r(se) 

********************************************************************************
// systematic shifts and heterogeneity
********************************************************************************
dgm, nstud(10) n(1000) a1(3) c1(3) tau_alpha(0.6) tau_b(0.6) tau_pi(0.6) tau_a(0.6) tau_c(0.6)

cap frame drop crude
frame create crude
frame crude{
	set obs 10
	gen effect = .
	gen se = .
	gen study = .
}

preserve
keep if s < 6 
tab s 
tabstat y , stats(mean sd) format(%3.2f)
tabstat x , by(s) stats(mean sd) format(%3.2f)
restore 

preserve
keep if s > 5 
tab s 
tabstat y , stats(mean sd) format(%3.2f)
tabstat x , by(s) stats(mean sd) format(%3.2f)
restore 

// crude effect in source
forv k = 1/5{
	
	reg y x if s == `k'
	
	frame crude{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}

frame crude: li
frame crude: meta set effect se
frame crude: meta summarize,  random(reml)


// crude effect in target
forv k = 6/10{
	
	reg y x if s == `k'
	
	frame crude{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}


frame crude: drop if study < 6
frame crude: li 

frame crude: meta set effect se
frame crude: meta summarize,  random(reml)

*** run the analyses ***
// reference
forv k = 1/10{
	
	reg y x z if s == `k'
	
	frame meta{
		replace effect = _b[x] if _n == `k'
		replace se = _se[x] if _n == `k'
		replace study = `k' if _n == `k'
	}
}

frame meta: meta set effect se
frame meta: meta summarize,  random(reml)
		
scalar b3_ref = r(theta)
scalar b3_ref_se = r(se)

// no adjustment
forv k = 6/10 {
	reg y x if s == `k'
	
	frame meta: replace effect = _b[x] if _n == `k'
	frame meta: replace se = _se[x] if _n == `k'

}
	
frame meta: meta set effect se
frame meta: meta summarize, random(reml)
	
scalar b3_na = r(theta)
scalar b3_na_se = r(se)

// set to missing
forv k = 6/10{
	replace z = . if s == `k'
	
	frame meta: replace effect = . if _n == `k'
	frame meta: replace se = . if _n == `k'
} 
		
// complete case 
frame meta: meta set effect se
frame meta: meta summarize, random(reml)
	
scalar b3_cc = r(theta)
scalar b3_cc_se = r(se)

forv k = 1/5 {
		
	logit z y x if s == `k'
	
	mat get_b_`k' = e(b)
	mat get_v_`k' = e(V)
		
}
	
cap frame drop random_impmodel  
frame create random_impmodel study y1 y2 y3 v11 v12 v13 v22 v23 v33

forv t = 1/5 {
    
	mat b = get_b_`t'
	mat V = get_v_`t'

	qui frame post random_impmodel ///
		(`t') (b[1,1]) (b[1,2]) (b[1,3]) ///
		(V[1,1]) (V[1,2]) (V[1,3]) (V[2,2]) (V[2,3]) (V[3,3])
}
	 
frame random_impmodel: meta mvregress y* , ///
	wcovvariables(v*) random(reml, covariance(unstructured))

// mi impute from
mat ib = e(b)[1, 1..3]
mat colnames ib = y x _cons
mat iV = e(V)[1..3, 1..3]
mat colnames iV = y x _cons
mat rownames iV = y x _cons
		 
forv k = 6/10 {
	
	preserve
		keep if s == `k'
		mi set wide
		mi register imputed z
			
		mi impute from z , b(ib) v(iV) add(10) imodel(logit)
		mi estimate, post: reg y x z
	
		frame meta: replace effect = _b[x] if _n == `k'
		frame meta: replace se = _se[x] if _n == `k'

	restore
}
		
frame meta: meta set effect se
frame meta: meta summarize, random(reml) 
	
scalar b3_imp = r(theta)
scalar b3_imp_se =  r(se) 

********************************************************************************
*** visualisation ***
********************************************************************************
frame create vis 
frame change vis

mat b1 = (b1_ref, b1_cc, b1_na, b1_imp) 
mat b2 = (b2_ref, b2_cc, b2_na, b2_imp) 
mat b3 = (b3_ref, b3_cc, b3_na, b3_imp) 

mat se1 = (b1_ref_se, b1_cc_se, b1_na_se, b1_imp_se) 
mat se2 = (b2_ref_se, b2_cc_se, b2_na_se, b2_imp_se)
mat se3 = (b3_ref_se, b3_cc_se, b3_na_se, b3_imp_se)

mat b = b1\b2\b3
mat se = se1 \ se2 \ se3

mat colnames b = Ref CCA NA MI
mat rownames b = Sce1 Sce2 Sce3 

svmat double b   
svmat double se 

gen scenario = _n
label define scen 1 "Sce1" 2 "Sce2" 3 "Sce3"
label values scenario scen

reshape long b se, i(scenario) j(method) string

gen met = real(method)
drop method

gen ll = b - invnormal(.975)*se
gen ul = b + invnormal(.975)*se


forv k = 1/3{
	tw /// 
		(scatter met b if scenario == `k' & met== 1, color(gold) msize(large) msymbol(t)) /// 
		(rcap ll ul met if scenario == `k' & met == 1,  horizontal color(gold)) /// 
		(scatter met b if scenario == `k' & met== 2, color(cranberry) msize(large) msymbol(s)) /// 
		(rcap ll ul met if scenario == `k' & met ==2,  horizontal color(cranberry)) /// 
		(scatter met b if scenario == `k' & met== 3, color(eltgreen) msymbol(o) msize(large)) /// 
		(rcap ll ul met if scenario == `k' & met == 3,  horizontal color(eltgreen)) /// 
		(scatter met b if scenario == `k' & met== 4, color(midblue) msize(large) msymbol(d)) /// 
		(rcap ll ul met if scenario == `k' & met == 4,  horizontal color(midblue)), /// 
		xline(1, lpattern(solid) lwidth(medthick)) /// 
		ytitle("") ylab(1 "Ref" 2 "CCA" 3 "NA" 4 "MI", noticks nogrid labsize(small)) /// 
		xlab(, nogrid labsize(small)) title("{bf: Example `k'}", size(medium)) /// 
		xtitle("{&theta}{sub:1}", size(medium)) /// 
		legend(off) name(fig`k', replace) aspect(0.8) yscale(reverse)
}

graph combine fig1 fig2 fig3, xcommon col(3)
cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures"
graph export fig_applied_example.png, replace width(4000)

exit 
******************************************/

cap program drop sim_characteristics
program define sim_characteristics, rclass 
		
	syntax[ , a1(real 1) c1(real 1) alpha1(real 0) ///
		tau_b(real 0) tau_pi(real 0) tau_a(real 0) tau_c(real 0) tau_alpha(real 0)]
	
	
	drop _all 
	
	dgm, nstud(2) n(500) a1(`a1') c1(`c1') alpha1(`alpha1') ///
		tau_b(`tau_b') tau_pi(`tau_pi') tau_a(`tau_a') tau_c(`tau_c') tau_alpha(`tau_alpha')
	
	su y if s == 1 
	ret scalar ymean1 = r(mean)
	ret scalar ysd1 = r(sd)
	
	su y if s == 2 
	ret scalar ymean2 = r(mean)
	ret scalar ysd2 = r(sd)
	
	reg y x if s == 1
	ret scalar y1beta = _b[x]
	
	reg y x if s == 2
	ret scalar y2beta = _b[x]
	
	ranksum x , by(s) porder
	ret scalar auc = 1-r(porder)
	
end 

// Applied example 1: no bias, but heterogeneity
simulate /// 
	ymean1 = r(ymean1) ymean2 = r(ymean2) /// 
	ysd1 = r(ysd1) ysd2 = r(ysd2) /// 
	y1beta = r(y1beta) y2beta = r(y2beta), /// 
	reps(1000): sim_characteristics , tau_alpha(0.3) tau_b(0.3) tau_pi(0.3) tau_a(0.3) tau_c(0.3)  
	
violinplot ymean1 ymean2, overlay left title("Mean of Y") name(meany, replace)
violinplot ysd1 ysd2, overlay left name(sdy, replace)
violinplot y1beta y2beta, overlay left name(betay, replace)

 
// No heterogeneity but systematic shifts
simulate /// 
	ymean1 = r(ymean1) ymean2 = r(ymean2) /// 
	ysd1 = r(ysd1) ysd2 = r(ysd2) /// 
	y1beta = r(y1beta) y2beta = r(y2beta), /// 
	reps(1000): sim_characteristics , a1(3) c1(3) 
	
violinplot ymean1 ymean2, overlay left title("Mean of Y") name(meany, replace)
violinplot ysd1 ysd2, overlay left name(sdy, replace)
violinplot y1beta y2beta, overlay left name(betay, replace)


*******************************************************
// Scenarios: Effect heterogenity
*******************************************************

*** 1. Between study heterogenity (tau_b)
	
*cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation"

cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2"

run "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2/scenarios_uvma/dgm_final.do"

cap program drop het_scenario 
program define het_scenario, rclass
	
	syntax [, tau_b(real 0) ]
	
	drop _all 
	
	cap frame drop meta
	frame create meta
	frame meta{
		set obs 10
		gen effect = .
		gen se = .
		gen study = .
	}
	
	cap frame drop metaz
	frame create metaz
	frame metaz{
		set obs 10
		gen effect = .
		gen se = .
		gen study = .
	}
	
	dgm, tau_b(`tau_b')
	
	****************************************************************************
	*** Reference *** 
	forv k = 1/10{
		
		reg y x z if s == `k'
		
		frame meta{
			replace effect = _b[x] if _n == `k'
			replace se = _se[x] if _n == `k'
			replace study = `k' if _n == `k'
		}
	
		frame metaz{
			replace effect = _b[z] if _n == `k'
			replace se = _se[z] if _n == `k'
			replace study = `k' if _n == `k'
		}
	}

	
	frame meta: meta set effect se
	frame meta: meta summarize,  random(reml)
		
	ret scalar b1_true = r(theta)
	ret scalar se_b1_true = r(se)
	
	frame metaz: meta set effect se
	frame metaz: meta summarize,  random(reml)
		
	ret scalar b2_true = r(theta)
	ret scalar se_b2_true = r(se)
	
	****************************************************************************
	*** no adjustment ***
	
	forv k = 6/10 {
		reg y x if s == `k'
		
		frame meta: replace effect = _b[x] if _n == `k'
		frame meta: replace se = _se[x] if _n == `k'

	}
	
	frame meta: meta set effect se
	frame meta: meta summarize, random(reml)
	
	ret scalar b1_na = r(theta)
	ret scalar se_b1_na = r(se)
	
	****************************************************************************
	*** set to missing ***	
	forv k = 6/10{
		replace z = . if s == `k'
		
		frame meta: replace effect = . if study == `k'
		frame meta: replace se = . if study == `k'
		
		frame metaz: replace effect = . if study == `k'
		frame metaz: replace se = . if study == `k'
	}
	
	****************************************************************************
	*** complete case ***		
	frame meta: meta set effect se
	frame meta: meta summarize, random(reml)
	
	ret scalar b1_cc = r(theta)
	ret scalar se_b1_cc = r(se)
	
	frame metaz: meta set effect se
	frame metaz: meta summarize, random(reml)
	
	ret scalar b2_cc = r(theta)
	ret scalar se_b2_cc = r(se)
	
	****************************************************************************
	*** imputation *** 
	
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
			
			frame metaz: replace effect = _b[z] if _n == `k'
			frame metaz: replace se = _se[z] if _n == `k'
		restore
	}
	
	frame meta: meta set effect se
	frame meta: meta summarize, random(reml) 
	
	ret scalar b1_imp = r(theta)
	ret scalar se_b1_imp =  r(se) 
	
	frame metaz: meta set effect se
	frame metaz: meta summarize, random(reml) 
	
	ret scalar b2_imp = r(theta)
	ret scalar se_b2_imp =  r(se) 
	
end 
 
forv k = 0(0.1)0.6{
	simulate ///
		b1_true = r(b1_true) se_b1_true = r(se_b1_true) ///
		b1_cc = r(b1_cc) se_b1_cc = r(se_b1_cc) ///
		b1_imp = r(b1_imp) se_b1_imp = r(se_b1_imp) ///
		b1_na = r(b1_na) se_b1_na = r(se_b1_na) ///
		b2_true = r(b2_true) se_b2_true = r(se_b2_true) /// 
		b2_cc = r(b2_cc) se_b2_cc = r(se_b2_cc) /// 
		b2_imp = r(b2_imp) se_b2_imp = r(se_b2_imp) /// 
		,reps($nsim  ): het_scenario, tau_b(`k')
	
	save "data/het_scenario_1_3_`k'.dta", replace
}


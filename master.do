/*

Master file

Simulation study

*/ 

clear all

global nsim = 1000
global imp = 10

********************************************************************************
****** simulations ******
********************************************************************************

*** Heterogenity ***
forv k = 1/4{
	do "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2/scenarios_uvma/scenario_1_`k'.do"
}
 

*** Parameter shift ***
forv k = 1/4{
	do "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2/scenarios_uvma/scenario_2_`k'.do"
}


*** Parameter shifts + heterogenity ***
forv k = 1/4{
	do "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2/scenarios_uvma/scenario_3_`k'.do"
}

********************************************************************************
*** Summary visualisation ***
********************************************************************************


forv k = 1/3 {
	run "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/mi_impute_from_v2/scenarios_uvma/vis_scenario_`k'.do"

}


cd "/Users/robert/Library/CloudStorage/OneDrive-KarolinskaInstitutet/PhD/Research/Cross_site_imputation/SIM_study/simulation/figures"

********************************************************************************
*** SCENARIO 1 ****
********************************************************************************

*** bias
graph combine "scenario_1_1_b1" "scenario_1_2_b1" "scenario_1_3_b1" "scenario_1_4_b1", ///
	ycommon  iscale(*.8) name(bias_sce1_b1, replace) title("{bf:Bias in {&theta}{sub:1}}")

graph export bias_sce1_b1.png, replace width(4000)

graph combine "scenario_1_1_b2" "scenario_1_2_b2" "scenario_1_3_b2" "scenario_1_4_b2", ///
	ycommon  iscale(*.8) name(bias_sce1_b2, replace) title("{bf:Bias in {&theta}{sub:2}}")

graph export bias_sce1_b2.png, replace width(4000)

*** coverage 
graph combine "coverage_het_scenario_1_1_b1" "coverage_het_scenario_1_2_b1" "coverage_het_scenario_1_3_b1" "coverage_het_scenario_1_4_b1", ///
	ycommon  iscale(*.8) name(cov_sce1_b1, replace) title("{bf:Coverage for {&theta}{sub:1}}")
	
graph export cov_sce1_b1.png, replace width(4000)

graph combine "coverage_het_scenario_1_1_b2" "coverage_het_scenario_1_2_b2" "coverage_het_scenario_1_3_b2" "coverage_het_scenario_1_4_b2", ///
	ycommon  iscale(*.8) name(cov_sce1_b2, replace) title("{bf:Coverage for {&theta}{sub:2}}")
	
graph export cov_sce1_b2.png, replace width(4000)

********************************************************************************
*** SCENARIO 2 ****
********************************************************************************


*** bias
graph combine "scenario_2_1_b1" "scenario_2_2_b1" "scenario_2_3_b1" "scenario_2_4_b1", /// 
	ycommon  iscale(*.8) name(bias_sce2_b1, replace) title("{bf:Bias in {&theta}{sub:1}}")

graph export bias_sce2_b1.png, replace width(4000)

graph combine "scenario_2_1_b2" "scenario_2_2_b2", ///
	ycommon  iscale(*.8) name(bias_sce2_b2, replace) title("{bf:Bias in {&theta}{sub:2}}")

graph export bias_sce2_b2.png, replace width(4000)

*** coverage 
graph combine "coverage_scenario_2_1_b1" "coverage_scenario_2_2_b1" "coverage_scenario_2_3_b1" "coverage_scenario_2_4_b1", /// 
	ycommon  iscale(*.8) name(cov_sce2_b1, replace) title("{bf:Coverage for {&theta}{sub:1}}")
	
graph export cov_sce2_b1.png, replace width(4000)

graph combine "coverage_scenario_2_1_b2" "coverage_scenario_2_2_b2", ///
	ycommon  iscale(*.8) name(cov_sce2_b2, replace) title("{bf:Coverage for {&theta}{sub:2}}")
	
graph export cov_sce2_b2.png, replace width(4000)

********************************************************************************
*** SCENARIO 3 ****
********************************************************************************

*** bias
graph combine "scenario_3_1_b1" "scenario_3_2_b1" "scenario_3_3_b1" "scenario_3_4_b1", /// 
	ycommon  iscale(*.8) name(bias_sce3_b1, replace) title("{bf:Bias in {&theta}{sub:1}}")

graph export bias_sce3_b1.png, replace width(4000)

graph combine "scenario_3_1_b2" "scenario_3_2_b2", ///
	ycommon  iscale(*.8) name(bias_sce3_b2, replace) title("{bf:Bias in {&theta}{sub:2}}")

graph export bias_sce3_b2.png, replace width(4000)

*** coverage 
graph combine "coverage_het_scenario_3_1_b1" "coverage_het_scenario_3_2_b1" "coverage_het_scenario_3_3_b1" "coverage_het_scenario_3_4_b1", /// 
	ycommon  iscale(*.8) name(cov_sce3_b1, replace) title("{bf:Coverage for {&theta}{sub:1}}")
	
graph export cov_sce3_b1.png, replace width(4000)

graph combine "coverage_het_scenario_3_1_b2" "coverage_het_scenario_3_2_b2", ///
	ycommon  iscale(*.8) name(cov_sce3_b2, replace) title("{bf:Coverage for {&theta}{sub:2}}")
	
graph export cov_sce3_b2.png, replace width(4000)


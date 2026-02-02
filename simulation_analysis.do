/*

Simualtion analysis (performance measures)

*/ 

clear all 
*** define cd with final datasets in dta format

********************************************************************************
********************************************************************************

********************* Scenario 1.1 *********************
forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_1_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_1_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse cover   
}

********************* Scenario 1.2 *********************
forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_2_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover
}

forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_2_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse  cover 
}

********************* Scenario 1.3 *********************
forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_3_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_3_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse cover 
}


********************* Scenario 1.4 *********************
forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_4_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover
}

forv i = 0(0.1)0.6{ 
	qui use "data/het_scenario_1_4_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp)  true(1) format(%4.3f)  bias empse cover
}

********************************************************************************
********************************************************************************

********************* Scenario 2.1 *********************
forv i = 0.1(0.1)0.6{ 
	qui use "data/data_sim_scenario_2_1_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

forv i = 0.1(0.1)0.6{ 
	qui use "data/data_sim_scenario_2_1_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse cover 
}

********************* Scenario 2.2 *********************
forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_2_2_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_2_2_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse cover 
}

********************* Scenario 2.3 *********************
forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_2_3_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

********************* Scenario 2.4 *********************
forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_2_4_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover
}

********************************************************************************
********************************************************************************

********************* Scenario 3.1 *********************
forv i = 0.1(0.1)0.6{ 
	qui use "data/data_sim_scenario_3_1_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

forv i = 0.1(0.1)0.6{ 
	qui use "data/data_sim_scenario_3_1_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse cover 
}

********************* Scenario 3.2 *********************
forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_3_2_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_3_2_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b2_true b2_cc b2_imp, se(se_b2_true se_b2_cc se_b2_imp) true(1) format(%4.3f) bias empse cover 
}

********************* Scenario 3.3 *********************
forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_3_3_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover 
}

********************* Scenario 3.4 *********************
forv i = 0(0.5)3{ 
	qui use "data/data_sim_scenario_3_4_`i'.dta", replace 
	di in red "Scenario: " `i' 
	simsum b1_true b1_cc b1_na b1_imp, se(se_b1_true se_b1_cc se_b1_na se_b1_imp) true(1) format(%4.3f) bias empse cover
}

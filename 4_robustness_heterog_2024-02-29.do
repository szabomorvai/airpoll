*************************************************************
******* AIR POLLUTION & FERTILITY****************************
*************************************************************
*******       REGRESSIONS       *****************************
*******       ROBUSTNESS, HETEROGENEITY**********************
*************************************************************

if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"
	global latex "C:\Users\szabomorvai.agnes\Dropbox\Apps\Overleaf\Airpoll_EU\NewTables"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\regs"
global do = "${workdir}\Do\Analysis"

/*clear
clear matrix
clear mata
set maxvar 8000, perm*/
* Original regression
global model robust

use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear
cap erase "$out/ALL_$model.xls"
cap erase "$out/ALL_$model.txt"
rename NOX_as_NO2_mean NOX_mean

lab var birth_rate "Birth rate"
lab var PM10_mean "PM\textsubscript{10}"
lab var PM2_mean "PM\textsubscript{2.5}"
lab var CO_mean  "CO"
lab var SO2_mean "SO\textsubscript{2}"
lab var NO2_mean  "NO\textsubscript{2}"
lab var NOX_mean "NO\textsubscript{X}"
lab var O3_mean "O\textsubscript{3}"
lab var WS_mean "Wind speed"
lab var HDD "Heating degree days"
lab var gdp_pps "GDP"



* Instruments
global varlist3 l.gdp_pps  
 global factor F


* IV - without warm temperature + Highesr Wind speed days
global iv_list1_nwwsd l1.WS_mean l1.WS_mean_sq l1.WS_mean_cu   l1.HDD  l1.HDD_sq l1.HDD_cu l1.HDDXWS  l1.WS_sqXHDD l1.WSXHDD_sq l1.WS_cuXHDD l1.WSXHDD_cu l1.WS_8plus l1.WS_7plus l1.WS_6plus l1.WS_5plus l1.WS_4plus l1.WS_8plus_sq l1.WS_7plus_sq l1.WS_6plus_sq l1.WS_5plus_sq l1.WS_4plus_sq
global iv_list2_nwwsd l2.WS_mean l2.WS_mean_sq l2.WS_mean_cu   l2.HDD  l2.HDD_sq l2.HDD_cu l2.HDDXWS   l2.WS_sqXHDD l2.WSXHDD_sq l2.WS_cuXHDD l2.WSXHDD_cu l2.WS_8plus l2.WS_7plus l2.WS_6plus l2.WS_5plus l2.WS_4plus l2.WS_8plus_sq l2.WS_7plus_sq l2.WS_6plus_sq l2.WS_5plus_sq l2.WS_4plus_sq

global ivlist ${iv_list1_nwwsd} ${iv_list2_nwwsd}  // ezzel az I8 és I6 működik 


******************
* Robustness 2SLS Regressions - with standardized pollution values
* I6 // D10 // mean 
******************
global table tab_reg_all
******************
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global factor F
est clear 


foreach indicator in I6 D10 mean {
preserve
	rename z_PM2_PM10_CO_${factor}_`indicator' PM2_PM10_CO_reg				// rename variables so that each regression coef appears in the same line
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_`indicator' SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_${factor}_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l2.PM2_PM10_CO_reg  l.NO2_NOX_O3_reg  l2.NO2_NOX_O3_reg  
	global varlist2  l.SO2_reg l2.SO2_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)	


	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
restore

}


	rename z_PM2_PM10_CO_F_I6 PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_I6 SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_F_I6 NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP

	
	
	
esttab, ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) /// 
	mtitles("ACS: 125\%"  "D10" "Mean" ) ///
	scalar( "p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3)  ///
	title("Instrumental variables estimates for various measures of ambient pollution \label{tab:reg:all}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. ACS: European air quality standard." "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2.5}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)." "Robust standard errors clustered at the NUTS-3 region level." )

 
esttab using "$latex/$table.tex", replace  ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) ///     
	mtitles("ACS: 125\%"  "D10" "Mean" ) ///
	scalars("p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3) ///
	title("Instrumental variables estimates for various measures of ambient pollution \label{tab:reg:all}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. ACS: European air quality standard." "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2.5}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)."  "Robust standard errors clustered at the NUTS-3 region level.")

	rename PM2_PM10_CO_reg z_PM2_PM10_CO_F_I6 
	rename SO2_reg z_SO2_I6 
	rename NO2_NOX_O3_reg z_NO2_NOX_O3_F_I6 

	
******************
* Robustness 2SLS Regressions - with standardized pollution values
* I8 --> SO2_I8 is zero for all observations, so it cannot be included in the variable list  
* The final table is put together manually in latex.
******************
global table tab_reg_all2
******************
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global factor F
est clear 


foreach indicator in I8 {
preserve
	rename z_PM2_PM10_CO_${factor}_`indicator' PM2_PM10_CO_reg				// rename variables so that each regression coef appears in the same line
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_`indicator' SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_${factor}_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l2.PM2_PM10_CO_reg  l.NO2_NOX_O3_reg  l2.NO2_NOX_O3_reg  
*	global varlist2  l.SO2_reg l2.SO2_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1  = $ivlist) $varlist2 $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)	


	ivreghdfe log_birth_rate ($varlist1  = $ivlist) $varlist2 $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
restore

}
	rename z_PM2_PM10_CO_F_I6 PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_I6 SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_F_I6 NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP


esttab, ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg ) /// 
	mtitles("ACS: 175\%" ) ///
	scalar( "p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3)  ///
	title("Instrumental variables estimates for various measures of ambient pollution \label{tab:reg:all}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. ACS: European air quality standard." "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2.5}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)." "Robust standard errors clustered at the NUTS-3 region level." )

 
esttab using "$latex/$table.tex", replace  ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg ) /// 
	mtitles("ACS: 175\%" ) ///
	scalar( "p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3)  ///
	title("Instrumental variables estimates for various measures of ambient pollution \label{tab:reg:all}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. ACS: European air quality standard." "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2.5}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)." "Robust standard errors clustered at the NUTS-3 region level." )


	rename PM2_PM10_CO_reg z_PM2_PM10_CO_F_I6 
	rename SO2_reg z_SO2_I6 
	rename NO2_NOX_O3_reg z_NO2_NOX_O3_F_I6 


	
	
	
	
******************
* Robustness 2SLS Regressions - with standardized pollution values
* Factorizing
******************

******************
global table tab_reg_factors
******************
*set maxvar 10000
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

est clear 

foreach factor in F PCF IPF ML   {

local indicator I6

preserve
	rename z_PM2_PM10_CO_`factor'_`indicator' PM2_PM10_CO_reg				// rename variables so that each regression coef appears in the same line
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_`indicator' SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_`factor'_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l2.PM2_PM10_CO_reg  l.NO2_NOX_O3_reg  l2.NO2_NOX_O3_reg  
	global varlist2  l.SO2_reg l2.SO2_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)	


	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
	estadd local clusters "197"
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
restore

}
	rename z_PM2_PM10_CO_F_I6 PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_I6 SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_F_I6 NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP


esttab, ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) /// 
	mtitles("PF" "PCF" "IPF" "ML"  ) ///
	scalar( "p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3)  ///
	title("Instrumental variables estimates for various methods of factorizing \label{tab:reg:factor}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. " "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2.5}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3}" "Methods of variable reduction in the Factor variables(1) Principal factor method" "(2) Principal-component factor method" "(3) Iterated principal-factor method (4) Maximum-likelihood factor method" "Air pollution measure: number of days when the concentrations exceeded the 125\% of the air quality standards." "Robust standard errors clustered at the NUTS-3 region level.")

 
esttab using "$latex/$table.tex", replace  ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) ///     
	mtitles("PF" "PCF" "IPF" "ML"  ) ///
	scalars("p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3) ///
	title("Instrumental variables estimates for various methods of factorizing \label{tab:reg:factor}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. " "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2.5}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3}" "Methods of variable reduction in the Factor variables(1) Principal factor method" "(2) Principal-component factor method" "(3) Iterated principal-factor method (4) Maximum-likelihood factor method" "Air pollution measure: number of days when the concentrations exceeded the 125\% of the air quality standards." "Robust standard errors clustered at the NUTS-3 region level.")

	rename PM2_PM10_CO_reg z_PM2_PM10_CO_F_I6 
	rename SO2_reg z_SO2_I6 
	rename NO2_NOX_O3_reg z_NO2_NOX_O3_F_I6 



	
	
******************
* Heterogeneity 
*High / low GDP
*High / low PM 
******************
global table tab_heterogeneity
******************
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global factor F
est clear 
egen GDP_median = median(gdp_pps), by(nuts3_code)
egen GDP_mean = mean(gdp_pps), by(nuts3_code)
egen GDP_median_all = median(gdp_pps)
gen GDP_low = GDP_mean < GDP_median_all
egen PM_median = median(PM2_PM10_CO_F_mean), by(nuts3_code)
egen PM_mean = mean(PM2_PM10_CO_F_mean), by(nuts3_code)
*egen PM_median_all = median(PM2_PM10_CO_F_I6)
egen PM_median_all = median(PM_mean)
gen PM_low = PM_mean < PM_median_all



local indicator mean  
preserve
	rename z_PM2_PM10_CO_${factor}_`indicator' PM2_PM10_CO_reg				// rename variables so that each regression coef appears in the same line
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_`indicator' SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_${factor}_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l2.PM2_PM10_CO_reg  l.NO2_NOX_O3_reg  l2.NO2_NOX_O3_reg  
	global varlist2  l.SO2_reg l2.SO2_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)	

	forval j = 0/1 {
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 & PM_low == `j'  $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
	estadd local clusters "197"
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
	}

	forval j = 0/1 {
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 & GDP_low == `j'  $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
	estadd local clusters "197"
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
	}
	

	restore


	rename z_PM2_PM10_CO_F_I6 PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_I6 SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_F_I6 NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP


esttab, ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) ///     
	mtitles("High PM\textsubscript{10}" "Low PM\textsubscript{10}"  "High GDP" "Low GDP") ///
	scalars("p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3) ///
	title("Heterogeneity by PM\textsubscript{10} and GDP (2SLS) \label{tab:reg:het}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. Pollution measure: mean." "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)."  "Robust standard errors clustered at the NUTS-3 region level.")

 
esttab using "$latex/$table.tex", replace  ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01)  ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) ///     
	mtitles("High PM\textsubscript{10}" "Low PM\textsubscript{10}"  "High GDP" "Low GDP") ///
	scalars("p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3) ///
	title("Heterogeneity by PM\textsubscript{10} and GDP (2SLS) \label{tab:reg:het}")   ///
	addnotes("\textbf{Notes}: Dependent variable : log birth rate. Pollution measure: mean." "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)."  "Robust standard errors clustered at the NUTS-3 region level.")

	rename PM2_PM10_CO_reg z_PM2_PM10_CO_F_I6 
	rename SO2_reg z_SO2_I6 
	rename NO2_NOX_O3_reg z_NO2_NOX_O3_F_I6 
	

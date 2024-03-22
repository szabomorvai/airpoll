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

cap drop country_name 
gen country_name = countrycode
replace country_name = "Andorra" if country_name == "AD"
replace country_name = "Albania" if country_name == "AL"
replace country_name = "Austria" if country_name == "AT"
replace country_name = "Belgium" if country_name == "BE"
replace country_name = "Bulgaria" if country_name == "BG"
replace country_name = "Switzerland" if country_name == "CH"
replace country_name = "Cyprus" if country_name == "CY"
replace country_name = "Czechia" if country_name == "CZ"
replace country_name = "Germany" if country_name == "DE"
replace country_name = "Denmark" if country_name == "DK"
replace country_name = "Estonia" if country_name == "EE"
replace country_name = "Spain" if country_name == "ES"
replace country_name = "Finland" if country_name == "FI"
replace country_name = "France" if country_name == "FR"
replace country_name = "United Kingdom" if country_name == "GB"
replace country_name = "Greece" if country_name == "GR"
replace country_name = "Croatia" if country_name == "HR"
replace country_name = "Hungary" if country_name == "HU"
replace country_name = "Ireland" if country_name == "IE"
replace country_name = "Iceland" if country_name == "IS"
replace country_name = "Italy" if country_name == "IT"
replace country_name = "Lithuania" if country_name == "LT"
replace country_name = "Luxembourg" if country_name == "LU"
replace country_name = "Latvia" if country_name == "LV"
replace country_name = "Montenegro" if country_name == "ME"
replace country_name = "North Macedonia" if country_name == "MK"
replace country_name = "Malta" if country_name == "MT"
replace country_name = "Netherlands" if country_name == "NL"
replace country_name = "Norway" if country_name == "NO"
replace country_name = "Poland" if country_name == "PL"
replace country_name = "Portugal" if country_name == "PT"
replace country_name = "Romania" if country_name == "RO"
replace country_name = "Serbia" if country_name == "RS"
replace country_name = "Sweden" if country_name == "SE"
replace country_name = "Slovenia" if country_name == "SI"
replace country_name = "Slovakia" if country_name == "SK"
replace country_name = "Turkey" if country_name == "TR"
replace country_name = "Kosovo" if country_name == "XK"

* Instruments
global varlist3 l.gdp_pps  
 global factor F


* IV - without warm temperature + Highesr Wind speed days
global iv_list1_nwwsd l1.WS_mean l1.WS_mean_sq l1.WS_mean_cu   l1.HDD  l1.HDD_sq l1.HDD_cu l1.HDDXWS  l1.WS_sqXHDD l1.WSXHDD_sq l1.WS_cuXHDD l1.WSXHDD_cu l1.WS_8plus l1.WS_7plus l1.WS_6plus l1.WS_5plus l1.WS_4plus l1.WS_8plus_sq l1.WS_7plus_sq l1.WS_6plus_sq l1.WS_5plus_sq l1.WS_4plus_sq
global iv_list2_nwwsd l2.WS_mean l2.WS_mean_sq l2.WS_mean_cu   l2.HDD  l2.HDD_sq l2.HDD_cu l2.HDDXWS   l2.WS_sqXHDD l2.WSXHDD_sq l2.WS_cuXHDD l2.WSXHDD_cu l2.WS_8plus l2.WS_7plus l2.WS_6plus l2.WS_5plus l2.WS_4plus l2.WS_8plus_sq l2.WS_7plus_sq l2.WS_6plus_sq l2.WS_5plus_sq l2.WS_4plus_sq

global ivlist ${iv_list1_nwwsd} ${iv_list2_nwwsd}  // ezzel az I8 és I6 működik 

* https://medium.com/the-stata-guide/the-stata-to-latex-guide-6e7ed5622856 -- how to make tables directly to latex

******************
* Summary stats
******************
global table tab_sum
******************

est clear  // clear the stored estimates
estpost tabstat birth_rate PM10_mean PM2_mean CO_mean  SO2_mean NO2_mean  NOX_mean O3_mean WS_mean HDD gdp_pps , c(stat) stat(mean sd min max n)

*ereturn list // list the stored locals

esttab , ////
   cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max(fmt(%6.2fc))      count(fmt(%6.0fc))") nonumber ///
   nomtitle nonote noobs label booktabs ///
   title("Summary statistics \label{tab:sum}")   ///
   collabels("Mean" "SD" "Min" "Max" "N")
    addnotes("\textbf{Notes}: Unit of measurement: Birth rate: number of births per 1000 women of age 15 to 44" "CO - mg/m\textsuperscript{3}; other pollutants - \textmu g/m\textsuperscript{3}; wind speed - km/h; heating degree days - none")


esttab using "$latex/tab_sum.tex", replace ////
   cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max(fmt(%6.2fc))      count(fmt(%6.0fc))") nonumber ///
   nomtitle nonote noobs label booktabs ///
   title("Summary statistics \label{tab:sum}")   ///
   collabels("Mean" "SD" "Min" "Max" "N")
   	addnotes("\textbf{Notes}: Unit of measurement: Birth rate: number of births per 1000 women of age 15 to 44" "CO - mg/m\textsuperscript{3}; other pollutants - \textmu g/m\textsuperscript{3}; wind speed - km/h; heating degree days - none")
   
   
******************
* Correlation table
******************
global table tab_corr
******************
* https://thedatahall.com/reporting-publication-style-correlation-tables-in-stata/


corr PM10_mean PM2_mean CO_mean SO2_mean NO2_mean  NOX_mean  O3_mean 
estpost correlate PM10_mean PM2_mean CO_mean SO2_mean NO2_mean  NOX_mean  O3_mean, matrix listwise
esttab using "$latex/tab_corr.tex", replace unstack not noobs nostar nonote nonumbers nomtitle compress b(2)  label ///
	title("Correlation matrix of the pollution variables  \label{tab:corr}")  

******************
* OLS - 2SLS Regressions - with standardized pollution values
******************
global table tab_reg_basics
******************
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global factor F
est clear 

*foreach indicator in  I6   {
local indicator I6	
preserve
	rename z_PM2_PM10_CO_${factor}_`indicator' PM2_PM10_CO_reg				// rename variables so that each regression coef appears in the same line
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_`indicator' SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_${factor}_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l.SO2_reg l.NO2_NOX_O3_reg   
	global varlist2 l2.PM2_PM10_CO_reg l2.SO2_reg l2.NO2_NOX_O3_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)	

	reghdfe  log_birth_rate $varlist1 if sample == 1 $weights, vce(cluster nuts3_code) absorb(i.nuts3_code##c.t   t i.nuts3_code)
	eststo
	estadd local clusters "197"
	estadd local regression "OLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "No"

	reghdfe  log_birth_rate $varlist1 $varlist2 if sample == 1 $weights, vce(cluster nuts3_code) absorb(i.nuts3_code##c.t   t i.nuts3_code)
	eststo
	estadd local clusters "197"
	estadd local regression "OLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "No"


	reghdfe  log_birth_rate $varlist1 $varlist2 $varlist3 if sample == 1 $weights, vce(cluster nuts3_code) absorb(i.nuts3_code##c.t   t i.nuts3_code)
	eststo
	estadd local clusters "197"
	estadd local regression "OLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"

	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
	estadd local clusters "197"
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
restore
*}
	rename z_PM2_PM10_CO_F_I6 PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_I6 SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_F_I6 NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP


esttab, ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) nomtitle ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) ///      
	scalar( "p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3)  ///
	title("OLS and 2SLS regression estimates  \label{tab:reg:basics}")   ///
	addnotes("\textbf{Notes}: Regressions based on Eq. \ref{eq:1}, \ref{eq:2}, \ref{eq:3} and 2SLS." "Dependent variable : log birth rate." "Air quality measure: number of days when the pollution concentrations" "exceeded 125\% of the European air quality standards, standardized" "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)." "Robust standard errors clustered at the NUTS-3 region level.")

 
esttab using "$latex/$table.tex", replace  ///
	b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) nomtitle ///
	keep(L.PM2_PM10_CO_reg L2.PM2_PM10_CO_reg L.NO2_NOX_O3_reg L2.NO2_NOX_O3_reg L.SO2_reg L2.SO2_reg) ///     
	scalars("p Prob $>$ F" "N_clust Clusters" "regression Model" "RFE NUTS-3 FE" "YFE Year FE" "trend NUTS-3 linear trend" "controls Other controls") sfmt(3) ///
	title("OLS and 2SLS regression estimates \label{tab:reg:basics}")   ///
	addnotes("\textbf{Notes}: Regressions based on Eq. \ref{eq:1}, \ref{eq:2}, \ref{eq:3} and 2SLS." "Dependent variable : log birth rate." "Air quality measure: number of days when the pollution concentrations" "exceeded 125\% of the European air quality standards, standardized" "L.: first lagged values; L2.: second lagged values." "PM Factor: PM\textsubscript{10}, PM\textsubscript{2}, CO; NO Factor: NO\textsubscript{2}, NO\textsubscript{X}, O\textsubscript{3} (Principal factor method)." "Robust standard errors clustered at the NUTS-3 region level.")

	rename PM2_PM10_CO_reg z_PM2_PM10_CO_F_I6 
	rename SO2_reg z_SO2_I6 
	rename NO2_NOX_O3_reg z_NO2_NOX_O3_F_I6 

	
******************
* First stage - MANUALLY!
******************
global table tab_first
******************
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global factor F
est clear 

*foreach indicator in  I6   {
local indicator I6 
preserve
	rename z_PM2_PM10_CO_${factor}_`indicator' PM2_PM10_CO_reg				// rename variables so that each regression coef appears in the same line
	lab var PM2_PM10_CO_reg "PM Factor"
	rename z_SO2_`indicator' SO2_reg
	lab var SO2_reg "SO\textsubscript{2}"
	rename z_NO2_NOX_O3_${factor}_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l.SO2_reg l.NO2_NOX_O3_reg   
	global varlist2 l2.PM2_PM10_CO_reg l2.SO2_reg l2.NO2_NOX_O3_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)	

	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) first savefirst
	eststo
	estadd local clusters "197"
	estadd local regression "2SLS"
	estadd local RFE  "Yes"
	estadd local YFE  "Yes"
	estadd local trend  "Yes"
	estadd local controls  "Yes"
restore
*}
esttab, ///
	b(3) se(3)  
   


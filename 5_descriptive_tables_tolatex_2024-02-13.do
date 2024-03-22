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
	global latex "C:\Users\szabomorvai.agnes\Dropbox\Apps\Overleaf\Airpoll_EU\Tables"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\regs"
global do = "${workdir}\Do\Analysis"


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
lab var NOX_mean "NOx"
lab var O3_mean "O\textsubscript{3}"
lab var WS_mean "Wind speed"
lab var HDD "Heating Degree Days"


* tab_summary
est clear  // clear the stored estimates
estpost tabstat birth_rate PM10_mean PM2_mean CO_mean  SO2_mean NO2_mean  NOX_mean O3_mean WS_mean HDD , c(stat) stat(mean sd min max n)

*ereturn list // list the stored locals


esttab using "$latex/tab_summary.tex", replace ////
   cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max      count(fmt(%6.0fc))") nonumber ///
   nomtitle nonote noobs label booktabs ///
   title("Summary statistics \label{tab:summary}")   ///
   collabels("Mean" "SD" "Min" "Max" "N") ///
	addnotes("Unit of measurement: Birth rate: numre of births per 1000 women of age 15 to 44" "CO - mg/m\textsuperscript{3}; other pollutants - \textmu g/m\textsuperscript{3}; Wind speed - km/h; Heating Degree Days - none")
   
   
   
   
* tab_corr

corr PM10_mean PM2_mean CO_mean SO2_mean NO2_mean  NOX_mean  O3_mean 
ereturn list 
   
esttab using "$latex/tab_corr.tex", replace ////
   cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max      count(fmt(%6.0fc))") nonumber ///
   nomtitle nonote noobs label booktabs ///
   collabels("Mean" "SD" "Min" "Max" "N")
   
* Regression
lab var log_birth_rate  "Log birth rate"
lab var PM10_mean "PM10"
lab var PM2_mean "PM2"

est clear 
reg log_birth_rate PM10_mean  
eststo
reg log_birth_rate PM10_mean PM2_mean 
eststo

* IV - with cooling days
global iv_list1 l1.WS_mean l1.WS_mean_sq  l1.temp_mean 	l1.temp_mean_sq l1.HDD  l1.CDD  l1.tempXWS l1.HDDXtemp l1.HDDXWS l1.HDDXCDD l1.CDDXWS l1.CDDXtemp 
global iv_list2 l2.WS_mean l2.WS_mean_sq  l2.temp_mean  l2.temp_mean_sq l2.HDD  l2.CDD  l2.tempXWS l2.HDDXtemp l2.HDDXWS l2.HDDXCDD l2.CDDXWS l2.CDDXtemp
global iv_list3 l3.WS_mean l3.WS_mean_sq  l3.temp_mean  l3.temp_mean_sq l3.HDD  l3.CDD  l3.tempXWS l3.HDDXtemp l3.HDDXWS l3.HDDXCDD l3.CDDXWS l3.CDDXtemp
global iv_list4 l4.WS_mean l4.WS_mean_sq  l4.temp_mean  l4.temp_mean_sq l4.HDD  l4.CDD  l4.tempXWS l4.HDDXtemp l4.HDDXWS l4.HDDXCDD l4.CDDXWS l4.CDDXtemp
global ivlist ${iv_list1} ${iv_list2}

global factor F
est clear 

foreach indicator in mean  D10 D9 I8 I6 {
preserve
	rename PM2_PM10_CO_${factor}_`indicator' PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename SO2_`indicator' SO2_reg
	lab var SO2_reg "SO2"
	rename NO2_NOX_O3_${factor}_`indicator' NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP
	
	global varlist1 l.PM2_PM10_CO_reg l.SO2_reg l.NO2_NOX_O3_reg   
	global varlist2 l2.PM2_PM10_CO_reg l2.SO2_reg l2.NO2_NOX_O3_reg    
	global varlist3 l.gdp_pps  
	cap drop sample
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	gen sample = e(sample)
	ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
	eststo
restore
}
	rename PM2_PM10_CO_F_mean PM2_PM10_CO_reg
	lab var PM2_PM10_CO_reg "PM Factor"
	rename SO2_mean SO2_reg
	lab var SO2_reg "SO2"
	rename NO2_NOX_O3_F_mean NO2_NOX_O3_reg
	lab var NO2_NOX_O3_reg "NO Factor"
	lab var gdp_pps GDP


esttab, b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) drop(SO2_reg) ///
 title("Baseline regressions \label{reg1}")   ///
 addnotes("Data: " "Robust standard errors clustered at the NUTS-3 region level")


	rename PM2_PM10_CO_reg PM2_PM10_CO_F_mean 
	rename SO2_reg SO2_mean 
	rename NO2_NOX_O3_reg NO2_NOX_O3_F_mean 

esttab using "$latex/tab_reg.tex", replace  ///
 b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs  ///
 title("Baseline regressions \label{reg1}")   ///
 addnotes("Data: " "Robust standard errors clustered at the NUTS-3 region level")


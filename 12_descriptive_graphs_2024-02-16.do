

* Airpoll descriptive graphs
set scheme cleanplots
if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"
	global latexgraph "C:\Users\szabomorvai.agnes\Dropbox\Apps\Overleaf\Airpoll_EU\Graphs"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\regs"
global graphs = "${workdir}\Results\graphs\Scatter_br_poll"
global do = "${workdir}\Do\Analysis"
global regress "do "$do\regs_for_indices_2023-06-07.do""
global robust "do "$do\robustness_heterog_2023-06-09.do""
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global iv_list1_nwwsd l1.WS_mean l1.WS_mean_sq l1.WS_mean_cu   l1.HDD  l1.HDD_sq l1.HDD_cu l1.HDDXWS  l1.WS_sqXHDD l1.WSXHDD_sq l1.WS_cuXHDD l1.WSXHDD_cu l1.WS_8plus l1.WS_7plus l1.WS_6plus l1.WS_5plus l1.WS_4plus l1.WS_8plus_sq l1.WS_7plus_sq l1.WS_6plus_sq l1.WS_5plus_sq l1.WS_4plus_sq
global iv_list2_nwwsd l2.WS_mean l2.WS_mean_sq l2.WS_mean_cu   l2.HDD  l2.HDD_sq l2.HDD_cu l2.HDDXWS   l2.WS_sqXHDD l2.WSXHDD_sq l2.WS_cuXHDD l2.WSXHDD_cu l2.WS_8plus l2.WS_7plus l2.WS_6plus l2.WS_5plus l2.WS_4plus l2.WS_8plus_sq l2.WS_7plus_sq l2.WS_6plus_sq l2.WS_5plus_sq l2.WS_4plus_sq

global ivlist ${iv_list1_nwwsd} ${iv_list2_nwwsd}  // ezzel az I8 és I6 működik 

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

tab sample

**************************************
* Log birth rate vs pollutants
**************************************
*https://www.stata.com/bookstore/pdf/g_text.pdf

lab var NOX_as_NO2_mean "NOx mean (t)"
lab var PM2_mean "PM{subscript:2.5} mean (t)"
lab var PM10_mean "PM{subscript:10} mean (t)"
lab var SO2_mean "SO{subscript:2} mean (t)"
lab var O3_mean "O{subscript:3} mean (t)"
lab var NO2_mean "NO{subscript:2} mean (t)"
lab var CO_mean "CO mean (t)"


foreach pol in PM10 SO2 O3 NO2  NOX_as_NO2 CO PM2 {
	foreach indicator in mean  /*D10 D9 I8 I6*/ {
		tw scatter log_birth_rate `pol'_`indicator'    if sample == 1, ytitle("Log birth rate (t+1)", size(medium)) xtitle(, size(medium)) msiz(tiny) mc(gs5) || lowess log_birth_rate `pol'_`indicator'  if sample == 1 , legend(off) lc(red)
		graph export "${graphs}\G_`pol'_`indicator'.pdf", as(pdf) replace
		graph export "${graphs}\Temp\G_`pol'_`indicator'.png", as(png) replace
		graph save "${graphs}\Temp\G_`pol'_`indicator'.gph", replace

		}
}

graph combine "${graphs}\Temp\G_PM10_mean.gph" "${graphs}\Temp\G_PM2_mean.gph" "${graphs}\Temp\G_CO_mean.gph" "${graphs}\Temp\G_SO2_mean.gph"
		graph export "${graphs}\Scatter_birth_poll_1.pdf", as(pdf) replace
		graph export "${latexgraph}\Scatter_birth_poll_1.pdf", as(pdf) replace
graph combine "${graphs}\Temp\G_NO2_mean.gph" "${graphs}\Temp\G_NOX_as_NO2_mean.gph" "${graphs}\Temp\G_O3_mean.gph" 
		graph export "${graphs}\Scatter_birth_poll_2.pdf", as(pdf) replace
		graph export "${latexgraph}\Scatter_birth_poll_2.pdf", as(pdf) replace



**************************************
* Instruments vs pollutants
**************************************
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

global varlist1 l.PM2_PM10_CO_F_I8 l.SO2_I8 l.NO2_NOX_O3_F_I8   
global varlist2 l2.PM2_PM10_CO_F_I8 l2.SO2_I8 l2.NO2_NOX_O3_F_I8    
cap drop sample
ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
gen sample = e(sample)	

lab var WS_mean "Wind speed"
lab var HDD "Heating degree days"
lab var NOX_as_NO2_mean "NOx"
lab var PM2_mean "PM{subscript:2.5}"
lab var PM10_mean "PM{subscript:10}"
lab var SO2_mean "SO{subscript:2}"
lab var O3_mean "O{subscript:3}"
lab var NO2_mean "NO{subscript:2}"
lab var CO_mean "CO"


foreach pol in PM10 PM2 CO  SO2 NO2  NOX_as_NO2 O3  {
	foreach indicator in mean   {
		foreach instrument in WS_mean  HDD {  
			local x : variable label `pol'_`indicator'
		tw scatter `pol'_`indicator' `instrument'     if sample == 1, ytitle(`x') msiz(tiny) mc(gs5) || lowess `pol'_`indicator' `instrument'   if sample == 1 , legend(off) lc(red)
		graph export "${graphs}\Temp\G_`instrument'_`pol'_`indicator'.png", as(png) replace
		graph save "${graphs}\Temp\G_`instrument'_`pol'_`indicator'.gph", replace
		}
		}
}

graph combine "${graphs}\Temp\G_WS_mean_PM10_mean.gph"  "${graphs}\Temp\G_HDD_PM10_mean.gph"  "${graphs}\Temp\G_WS_mean_PM2_mean.gph"  "${graphs}\Temp\G_HDD_PM2_mean.gph"  "${graphs}\Temp\G_WS_mean_CO_mean.gph"  "${graphs}\Temp\G_HDD_CO_mean.gph" "${graphs}\Temp\G_WS_mean_NO2_mean.gph"  "${graphs}\Temp\G_HDD_NO2_mean.gph" "${graphs}\Temp\G_WS_mean_NOX_as_NO2_mean.gph"  "${graphs}\Temp\G_HDD_NOX_as_NO2_mean.gph"  "${graphs}\Temp\G_WS_mean_O3_mean.gph"  "${graphs}\Temp\G_HDD_O3_mean.gph"  "${graphs}\Temp\G_WS_mean_SO2_mean.gph" "${graphs}\Temp\G_HDD_SO2_mean.gph" , cols(4)
		graph export "$latexgraph\Scatter_inst_poll_1.pdf", as(pdf) replace

		




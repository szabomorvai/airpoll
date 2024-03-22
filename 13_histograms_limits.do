
* Airpoll histograms with air pollution limits
set scheme cleanplots
if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"
	global latexgraph "C:\Users\szabomorvai.agnes\Dropbox\Apps\Overleaf\Airpoll_EU\Graphs"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\graphs\Pollution histograms with limits"
cd "${workdir}\Results\graphs\Pollution histograms with limits"
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear


global varlist1 l.PM2_PM10_CO_F_I8 l.SO2_I8 l.NO2_NOX_O3_F_I8   
global varlist2 l2.PM2_PM10_CO_F_I8 l2.SO2_I8 l2.NO2_NOX_O3_F_I8    
cap drop sample
ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
gen sample = e(sample)	

*pollutants: 	1 	5 		7 	8 	9 	10 	20 		38 	5012 		6001
*pollutants:	SO2	PM10	O3	NO2	NOX	CO	C6H6	NO	Pb_in_PM10	PM2

foreach pol in 1 5 7 8  10 20  5012 6001 {
	local limit = 0
	if `pol' == 1 {
		local limit = 125
		local var = "SO2"
	}	
	if `pol' == 5 {
		local limit = 40
		local var = "PM10"
	}	
	if `pol' == 7 {
		local limit = 120
		local var = "O3"
	}	
	if `pol' == 8 {
		local limit = 40
		local var = "NO2"
		
	}	
	if `pol' == 10 {
		local limit = 10
		local var = "CO"

	}	
	if `pol' == 20 {
		local limit = 5
		local var = "C6H6"
		
	}	
	if `pol' == 5012 {
		local limit = 0.5
		local var = "Pb_in_PM10"
		
	}
	if `pol' == 6001 {
		local limit = 20
		local var = "PM2"

	}
	
	local tick = `limit'/5
	local tick2 = `limit'/2
	local to = `limit'*3
    local unit = "{&mu}"
	if `pol' == 10 {
	    local unit = "m"
	}
	local x : variable label `var'_mean
	hist `var'_mean if `var'_mean < 3*`limit', color(gray) ///
	xtitle("`x' concentration (`unit'g/m{sup:3})") ///
	legend(off) xlabel(0(`tick')`to', angle(90) labsize(small)) xlabel(`limit' "Limit: `limit'", add custom labsize(normal) angle(90) labcolor(red)) saving(`var', replace) 
	graph export "${out}\pollution_histogram_`var'.png", as(png) name("Graph") width(3000) replace

}
	
 gr combine PM10.gph PM2.gph CO.gph	NO2.gph 
 graph export "${out}\pollution_histograms_ALL1.png", as(png) name("Graph") width(3000) replace	
graph export "$latexgraph\pollution_histograms_ALL1.pdf", as(pdf) replace

 gr combine O3.gph SO2.gph	C6H6.gph Pb_in_PM10.gph 
 graph export "${out}\pollution_histograms_ALL2.png", as(png) name("Graph") width(3000) replace	
		graph export "$latexgraph\pollution_histograms_ALL2.pdf", as(pdf) replace


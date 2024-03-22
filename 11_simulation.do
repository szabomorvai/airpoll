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
	global latex "C:\Users\szabomorvai.agnes\Dropbox\Apps\Overleaf\Airpoll_EU\Graphs"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\regs"
global do = "${workdir}\Do\Analysis"


use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear

* Simulation: PM Factor (standardized) = -0.71, which allows PM10 to exceed ACS 125% 2 times a year and PM2.5 3 times a year. See for example: AT332 in 2020. We set NO Factor and SO2 to the same value as originally. 

* replace PM Factor (st) values with -0.71 if it is larger than that. 
gen PM_factor_sim = min(z_PM2_PM10_CO_F_I6, -0.71 )
gen L_PM_factor_sim = L.PM_factor_sim
gen L2_PM_factor_sim = L2.PM_factor_sim
gen L_z_PM2_PM10_CO_F_I6 = L.z_PM2_PM10_CO_F_I6
gen L2_z_PM2_PM10_CO_F_I6 = L2.z_PM2_PM10_CO_F_I6

gen diff_L = L_PM_factor_sim - L_z_PM2_PM10_CO_F_I6
replace diff_L = -1 if diff_L < -1						// PM pollution decrease maximum 1 SD
*hist diff_L

gen diff_L2 = L2_PM_factor_sim - L2_z_PM2_PM10_CO_F_I6
replace diff_L2 = -1 if diff_L2 < -1
*hist diff_L2

gen log_birt_rate_diff = -.0509125*diff_L -  .0592864*diff_L2
gen lbrd_perc = log_birt_rate_diff * 100
*hist lbrd_perc if year == 2020


*keep if year == 2020


set scheme white_tableau, perm

*deleting Canary Island observations 
drop if NUTS_ID=="ES701" | NUTS_ID=="ES702"


merge m:1 NUTS3_code using "${workdir}\Data\Map\nuts3map.dta"
drop if LEVL_CODE > 0 & _m == 2


*birth_rate map
	preserve
	collapse (mean) lbrd_perc = lbrd_perc (firstnm) _ID _CX _CY  countrycode, by(NUTS3_code) 
	sort _ID
	format %6.2f lbrd_perc
	
*	https://repec.sowi.unibe.ch/stata/palettes/help-colorpalette.html
	colorpalette viridis, n(12) nograph reverse
	local colors `r(p)'
	spmap lbrd_perc using "${workdir}\Data\Map\nuts3map_shp.dta", ///
	id(_ID) fcolor("`colors'") cln(20) legend(pos(9) size(2.5)) legstyle(2) ///
	ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.03 ..) ndlabel("No data") 
*	graph export "${out}\graphs\nuts3_simul_viridis.png", as(png) name("Graph") width(3000) replace
	graph export "$latex/nuts3_simul_viridis.png", as(png) name("Graph") width(3000) replace
	restore




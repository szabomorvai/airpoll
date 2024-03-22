*This do file creates graphs 

if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"
	global latex "C:\Users\szabomorvai.agnes\Dropbox\Apps\Overleaf\Airpoll_EU\Graphs"

}

global out = "${workdir}\Results"

****************
* MAPS
***************
* https://www.jamelsaadaoui.com/drawing-maps-with-stata-for-the-nuts-regions/

*Packages for maps and colors:
*	ssc install spmap, replace
*	ssc install geo2xy, replace    
*	ssc install palettes, replace        
*	ssc install colrspace, replace
*	ssc install schemepack, replace

set scheme white_tableau, perm

use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear
*deleting Canary Island observations 
drop if NUTS_ID=="ES701" | NUTS_ID=="ES702"


merge m:1 NUTS3_code using "${workdir}\Data\Map\nuts3map.dta"
drop if LEVL_CODE > 0 & _m == 2


*birth_rate map
	preserve
	collapse (mean) birth_rate = birth_rate (firstnm) _ID _CX _CY  countrycode, by(NUTS3_code) 
	sort _ID
	format %6.1f birth_rate
	
*	https://repec.sowi.unibe.ch/stata/palettes/help-colorpalette.html
	colorpalette viridis, n(10) nograph reverse 
	local colors `r(p)'
	spmap birth_rate using "${workdir}\Data\Map\nuts3map_shp.dta", ///
	id(_ID) fcolor("`colors'") cln(10) legend(pos(9) size(2.5)) legstyle(2) ///
	ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.03 ..) ndlabel("No data") 
*	title("{fontface Arial Bold:Average birth rate by NUTS 3 regions}", size(medsmall)) 
	graph export "${out}\graphs\nuts3_birthrate_viridis.png", as(png) name("Graph") width(3000) replace
	graph export "$latex/nuts3_birthrate_viridis.png", as(png) name("Graph") width(3000) replace
	restore



*Maps for average C6H6 CO NO2 NOX_as_NO2 NO O3 PM10 PM2 Pb_in_PM10 SO2
foreach pol in C6H6 CO NO2 NOX_as_NO2 NO O3 PM10 PM2 Pb_in_PM10 SO2 { 
	preserve
	drop if `pol'_mean == . & LEVL_CODE != 0
	collapse (mean) `pol'_mean = `pol'_mean  (firstnm) _ID _CX _CY  countrycode, by(NUTS3_code) 
	sort _ID
	format %3.1f `pol'_mean
	
	colorpalette viridis, n(10) nograph reverse 
	local colors `r(p)'
	spmap `pol'_mean using "${workdir}\Data\Map\nuts3map_shp.dta", id(_ID) fcolor("`colors'") cln(10) legend(pos(9) size(2.5)) legstyle(2) ///
	ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.03 ..) ndlabel("No data")
*	title("{fontface Arial Bold:Average `pol' pollution by NUTS 3 regions}", size(medsmall)) 
	graph export "${out}\graphs\nuts3_`pol'_viridis.png", as(png) name("Graph") width(3000) replace
	graph export "$latex/nuts3_`pol'_viridis.png", as(png) name("Graph") width(3000) replace		
	restore
}


*Map for high / low gdp
	preserve
egen GDP_median = median(gdp_pps), by(nuts3_code)
egen GDP_mean = mean(gdp_pps), by(nuts3_code)
egen GDP_median_all = median(gdp_pps)
gen GDP_low = GDP_mean < GDP_median_all

	collapse (mean) GDP_low  (firstnm) _ID _CX _CY  countrycode, by(NUTS3_code) 
	sort _ID
	
	colorpalette viridis, n(6) nograph reverse 
	local colors `r(p)'
	spmap GDP_low using "${workdir}\Data\Map\nuts3map_shp.dta", id(_ID) fcolor("`colors'") cln(10) legend(pos(9) size(2.5)) legstyle(2) ///
	ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.03 ..) ndlabel("No data") ///
	legend(order( 2 "High GDP" 3 "Low GDP"))
*	title("{fontface Arial Bold:Average `pol' pollution by NUTS 3 regions}", size(medsmall)) 
	graph export "${out}\graphs\nuts3_gdp_viridis.png", as(png) name("Graph") width(3000) replace
	graph export "$latex/nuts3_gdp_viridis.png", as(png) name("Graph") width(3000) replace		
	restore



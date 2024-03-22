*********
*Merge the yearly data set

if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"

}

*pollution data
use "${workdir}\Data\Other\nuts3_year_all.dta", clear
gen NUTS3_code = NUTS_ID
encode NUTS_ID, gen(nuts3)

*after using tsfill, the NUTS_ID is missing for the new observations
*we create a data with all the panel ids (nuts3) and the NUTS3_code and NUTS_ID variables
preserve
keep NUTS_ID NUTS3_code nuts3 countrycode
duplicates drop NUTS_ID NUTS3_code nuts3 countrycode, force
drop if nuts3==.
save "${workdir}\Data\Other\nuts3code_id.dta", replace
restore

*creating a balanced panel
xtset nuts3 year 
tsfill, full

*updating the missing NUTS_ID and NUTS3_code variables
merge m:1 nuts3 using "${workdir}\Data\Other\nuts3code_id.dta", update
drop _m


*share variables
foreach pol in PM10 SO2 O3 NO2 NOX_as_NO2 CO C6H6 NO Pb_in_PM10 PM2 {
	gen `pol'_numofdays = 0
	forvalues k = 1/10 {
		display "replace `pol'_numofdays = `pol'_numofdays + `pol'_d`k'"
		replace `pol'_numofdays = `pol'_numofdays + `pol'_d`k' 
	}
	forvalues k = 1/10 {
		display "`pol'_d`k'_share = `pol'_d`k' / `pol'_numofdays"
		gen `pol'_d`k'_share = `pol'_d`k' / `pol'_numofdays 
	}
}

	
*gdp
	merge m:1 NUTS3_code year using "${workdir}\Data\Other\econdata\gdp_nuts3.dta"
	drop if _m == 2
	drop _m
	label variable gdp_euro "Euro per inhabitant"
	label variable gdp_pps "Purchasing power standard (PPS, EU27 from 2020), per inhabitant"


*area
	merge m:1 NUTS3_code using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\area_nuts3.dta"
	*area nincs andorrára, néhány spanyol, szerb és koszovói régióra	
	drop if _m==2
	drop _m

*deaths
	merge m:1 NUTS3_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\deaths_nuts3_year.dta"
	drop if _m==2
	drop _m


*employment by sector
	merge m:1 NUTS3_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\emplyed_by_sector_nuts3_year.dta"
	drop if _m==2
	drop _m

*gva by sector
	merge m:1 NUTS3_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\gva_by_sector_nuts3_year.dta"
	drop if _m==2
	drop _m

*heating cooling days
merge m:1 NUTS3_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\heating_cooling_nuts3_year.dta"
drop if _m==2
drop _m

*population structure
	merge m:1 NUTS3_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\population_byagesex_nuts3_year.dta"
	drop if _m==2
	drop _m

*births
	merge m:1 NUTS3_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\births_nuts3_year.dta"
	drop if _m==2
	drop _m

*brent_year
	merge m:1 year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\econdata\brent_year.dta"
	drop if _merge == 2
	drop _merge


save "${workdir}\Data\RegData\airpollution_fertility_year.dta", replace
	
use "${workdir}\Data\RegData\airpollution_fertility_year.dta", clear

*temperature
	gen NUTS2_code = substr(NUTS_ID, 1, 4)
	merge m:1 NUTS2_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\copernicus wind speed temperature\temp_nuts2_year.dta"
	drop if _m == 2
	drop _m
		
*wind speed
	merge m:1 NUTS2_code year using "C:\Users\stump\Dropbox\MakroFertilityPollution\Data\Other\copernicus wind speed temperature\windspeed_nuts2_year.dta"
	drop if _m == 2
	drop _m
		
save "${workdir}\Data\RegData\airpollution_fertility_year.dta", replace
	
	
	

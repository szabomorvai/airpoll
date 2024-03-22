**************
*air pollution aggregation - mean, maximum, days in highest deciles, factorization
**************

if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results"

********************************************************************************




************************
*** ÉVES
************************



use "${data}\airpollution_fertility_year.dta", clear
cap gen fpop = fpop_Y40_44 +fpop_Y35_39 +fpop_Y30_34 +fpop_Y25_29 +fpop_Y20_24 +fpop_Y15_19
gen birth_rate = birth/fpop*1000
lab var birth_rate "Births per 1000 women of age 15-44"
rename *_con_* *_*
egen nuts3_code = group(NUTS3_code)
xtset nuts3_code year

drop if NUTS3_code == ""
*van egy nagyon furcsa NO érték.
replace NO_mean = . if NO_mean != . & NO_mean > 100000


***átlagok, maximumok
* Orszgos átlag a `pol'_mean; `pol'_max; `pol'_d1 stb értékekre. 
	***országos
	replace countrycode = "UK" if countrycode == "GB"
	replace countrycode = "EL" if countrycode == "GR"
	gen NUTS3_str2 = substr(NUTS_ID,1,2)
	replace countrycode = NUTS3_str2 if countrycode == ""	


xtset nuts3_code year
gen log_birth_rate = log(birth_rate)
egen t = group(year)
gen t_2 = t^2
gen log_fpop = log(fpop)
gen WS_mean_sq = WS_mean * WS_mean
gen WS_mean_cu = WS_mean * WS_mean * WS_mean
gen temp_mean_sq = temp_mean * temp_mean
gen HDD_sq = HDD * HDD
gen HDD_cu = HDD * HDD  * HDD
gen WS_sqXHDD = WS_mean_sq  * HDD
gen WSXHDD_sq = WS_mean  * HDD_sq
gen WS_cuXHDD = WS_mean_cu  * HDD
gen WSXHDD_cu = WS_mean  * HDD_cu
gen WS_7plus = WS_7_8 + WS_8plus
gen WS_6plus = WS_6_7 + WS_7plus
gen WS_5plus = WS_5_6 + WS_6plus
gen WS_4plus = WS_4_5 + WS_5plus
gen WS_8plus_sq = WS_8plus * WS_8plus 
gen WS_7plus_sq = WS_7plus * WS_7plus 
gen WS_6plus_sq = WS_6plus * WS_6plus 
gen WS_5plus_sq = WS_5plus * WS_5plus 
gen WS_4plus_sq = WS_4plus * WS_4plus 

gen tempXWS = temp_mean * WS_mean
gen HDDXtemp = HDD * temp_mean
gen HDDXWS = HDD * WS_mean
gen CDDXtemp = CDD * temp_mean
gen CDDXWS = CDD * WS_mean
gen HDDXCDD = HDD * CDD
gen t_sq = t^2


corr PM10_mean PM2_mean CO_mean SO2_mean NO2_mean  NOX_as_NO2_mean  O3_mean 
* Low nr of obs: C6H6; Pb
corr PM10_mean SO2_mean O3_mean NO2_mean  NOX_as_NO2_mean NO_mean CO_mean PM2_mean 
* High corr: NOX, O3, PM2
corr PM10_mean SO2_mean NO2_mean  NO_mean CO_mean 




* Days in highest X deciles
foreach pol in PM10 SO2 O3 NO2  NOX_as_NO2 NO CO C6H6 PM2 Pb_in_PM10 {
	gen `pol'_D10 = `pol'_d10 
	gen `pol'_D9 = `pol'_D10 + `pol'_d9 
	gen `pol'_D8 = `pol'_D9 + `pol'_d8 
	gen `pol'_D7 = `pol'_D8 + `pol'_d7 
	gen `pol'_D6 = `pol'_D7 + `pol'_d6 
	gen `pol'_D5 = `pol'_D6 + `pol'_d5
	gen `pol'_D4 = `pol'_D5 + `pol'_d4
	gen `pol'_D3 = `pol'_D4 + `pol'_d3
	gen `pol'_D2 = `pol'_D3 + `pol'_d2
	gen `pol'_D1 = `pol'_D2 + `pol'_d1
	lab var `pol'_D10 "Number of days in highest decile"
	lab var `pol'_D9 "Number of days in highest 2 deciles"
	lab var `pol'_D8 "Number of days in highest 3 deciles"
	lab var `pol'_D7 "Number of days in highest 4 deciles"
	lab var `pol'_D6 "Number of days in highest 5 deciles"
	lab var `pol'_D5 "Number of days in highest 6 deciles"
	lab var `pol'_D4 "Number of days in highest 7 deciles"
	lab var `pol'_D3 "Number of days in highest 8 deciles"
	lab var `pol'_D2 "Number of days in highest 9 deciles"
	lab var `pol'_D1 "Number of days in highest 10 deciles"

	gen `pol'_I8 = `pol'_i7 
	gen `pol'_I7 = `pol'_I8 + `pol'_i6 
	gen `pol'_I6 = `pol'_I7 + `pol'_i5 
	gen `pol'_I5 = `pol'_I6 + `pol'_i4 
	gen `pol'_I4 = `pol'_I5 + `pol'_i3 
	gen `pol'_I3 = `pol'_I4 + `pol'_i2 
	gen `pol'_I2 = `pol'_I3 + `pol'_i1 
	lab var `pol'_I8 "Number of days in highest interval"
	lab var `pol'_I7 "Number of days in highest 2 intervals"
	lab var `pol'_I6 "Number of days in highest 3 intervals"
	lab var `pol'_I5 "Number of days in highest 4 intervals"
	lab var `pol'_I4 "Number of days in highest 5 intervals"
	lab var `pol'_I3 "Number of days in highest 6 intervals"
	lab var `pol'_I2 "Number of days in highest 7 intervals"
}



* factorizing highly correlated pollution variables
foreach i in  mean max d1  d2 d3 d4 d5 d6 d7 d8 d9 d10 D10 D9 D8 D7 D6 D5 D4 D3 D2 I8 I7 I6 I5 I4 I3 I2  {
* Principal factor 
		factor PM10_`i' PM2_`i' CO_`i' [aw=fpop_TOTAL]
			predict PM2_PM10_CO_F_`i'
			label var PM2_PM10_CO_F_`i' PM2_PM10_CO_factor_`i'
		factor NO2_`i'  NOX_as_NO2_`i' O3_`i' [aw=fpop_TOTAL]
			predict NO2_NOX_O3_F_`i'
			label var NO2_NOX_O3_F_`i' NO2_NOX_O3_factor_`i'
}


* Principal component factor		
foreach i in  mean max d1  d2 d3 d4 d5 d6 d7 d8 d9 d10 D10 D9 D8 D7 D6 D5 D4 D3 D2  I8 I7 I6 I5 I4 I3 I2  {
		factor PM10_`i' PM2_`i' CO_`i' [aw=fpop_TOTAL], pcf
			predict PM2_PM10_CO_PCF_`i'
			label var PM2_PM10_CO_PCF_`i' PM2_PM10_CO_PCfactor_`i'
		factor NO2_`i'  NOX_as_NO2_`i' O3_`i' [aw=fpop_TOTAL], pcf
			predict NO2_NOX_O3_PCF_`i'
			label var NO2_NOX_O3_PCF_`i' NO2_NOX_O3_PCfactor_`i'
}


* iterated principal-factor method 		
foreach i in  mean max d1  d2 d3 d4 d5 d6 d7 d8 d9 d10 D10 D9 D8 D7 D6 D5 D4 D3 D2  I8 I7 I6 I5 I4 I3 I2  {
		factor PM10_`i' PM2_`i' CO_`i' [aw=fpop_TOTAL], ipf
			predict PM2_PM10_CO_IPF_`i'
			label var PM2_PM10_CO_IPF_`i' PM2_PM10_CO_IPfactor_`i'
		factor NO2_`i'  NOX_as_NO2_`i' O3_`i' [aw=fpop_TOTAL], ipf
			predict NO2_NOX_O3_IPF_`i'
			label var NO2_NOX_O3_IPF_`i' NO2_NOX_O3_IPfactor_`i'
}

* maximum-likelihood factor method 		
foreach i in  mean max d1  d2 d3 d4 d5 d6 d7 d8 d9 d10 D10 D9 D8 D7 D6 D5 D4 D3 D2  I8 I7 I6 I5 I4 I3 I2  {
		factor PM10_`i' PM2_`i' CO_`i' [aw=fpop_TOTAL], ml
			predict PM2_PM10_CO_ML_`i'
			label var PM2_PM10_CO_ML_`i' PM2_PM10_CO_ML_`i'
		factor NO2_`i'  NOX_as_NO2_`i' O3_`i' [aw=fpop_TOTAL], ml
			predict NO2_NOX_O3_ML_`i'
			label var NO2_NOX_O3_ML_`i' NO2_NOX_O3_ML_`i'
}



foreach i in  mean max d1  d2 d3 d4 d5 d6 d7 d8 d9 d10 D10 D9 D8 D7 D6 D5 D4 D3 D2  I8 I7 I6 I5 I4 I3 I2  {
* simple mean:
		egen PM2_PM10_CO_SM_`i' = rowmean(PM10_`i' PM2_`i' CO_`i')  if PM10_`i'!=. & PM2_`i'!=. & CO_`i'!=.
		egen NO2_NOX_O3_SM_`i' = rowmean(NO2_`i'  NOX_as_NO2_`i' O3_`i') if NO2_`i'!=.  & NOX_as_NO2_`i'!=. & O3_`i'!=. 
}

global poll PM10 SO2 O3 NO2  NOX_as_NO2 NO CO C6H6 PM2 Pb_in_PM10 PM2_PM10_CO_F NO2_NOX_O3_F PM2_PM10_CO_PCF NO2_NOX_O3_PCF PM2_PM10_CO_IPF NO2_NOX_O3_IPF PM2_PM10_CO_ML NO2_NOX_O3_ML
sort nuts3_code year


* Generate lagged variables
foreach var in $poll {
	foreach i in mean max D10 D9 D8 D7 D6 D5 D4 D3 D2 I8 I7 I6 I5 I4 I3 I2  {
		
		recode `var'_`i' (.=0)
		gen `var'_`i'_sq = `var'_`i'^2
		gen `var'_`i'_cu = `var'_`i'^3
		gen `var'_`i'_L1 = L1.`var'_`i'
		gen `var'_`i'_L1sq = L1.`var'_`i'_sq
		gen `var'_`i'_L1cu = L1.`var'_`i'_cu
		gen `var'_`i'_L2 = L2.`var'_`i'
		gen `var'_`i'_L2sq = L2.`var'_`i'_sq
		gen `var'_`i'_L2cu = L2.`var'_`i'_cu
		gen `var'_`i'_L3 = L3.`var'_`i'
		gen `var'_`i'_L3sq = L3.`var'_`i'_sq
		gen `var'_`i'_L3cu = L3.`var'_`i'_cu
	} 
}

* Standardize the variables for LASSO estimation 
foreach var in $poll {
	foreach i in mean max D10 D9 D8 D7 D6 D5 D4 D3 D2 I8 I7 I6 I5 I4 I3 I2  {
		egen z_`var'_`i' = std(`var'_`i')
		egen z_`var'_`i'_sq = std(`var'_`i'_sq)
		egen z_`var'_`i'_cu = std(`var'_`i'_cu)

		egen z_`var'_`i'_L1 = std(`var'_`i'_L1)
		egen z_`var'_`i'_L1sq = std(`var'_`i'_L1sq)
		egen z_`var'_`i'_L1cu = std(`var'_`i'_L1cu)

		egen z_`var'_`i'_L2 = std(`var'_`i'_L2)
		egen z_`var'_`i'_L2sq = std(`var'_`i'_L2sq)
		egen z_`var'_`i'_L2cu = std(`var'_`i'_L2cu)

		egen z_`var'_`i'_L3 = std(`var'_`i'_L3)
		egen z_`var'_`i'_L3sq = std(`var'_`i'_L3sq)
		egen z_`var'_`i'_L3cu = std(`var'_`i'_L3cu)
	}
}

egen country_num = group(countrycode)


lab var WS_mean "Wind speed"
lab var HDD "Heating degree days"
lab var NOX_as_NO2_mean "NOx"
lab var PM2_mean "PM{subscript:2.5}"
lab var PM10_mean "PM{subscript:10}"
lab var SO2_mean "SO{subscript:2}"
lab var O3_mean "O{subscript:3}"
lab var NO2_mean "NO{subscript:2}"
lab var CO_mean "CO"
lab var Pb_in_PM10_mean "Pb"
lab var C6H6_mean "C{subscript:6}H{subscript:6}"



save "${data}\airpollution_fertility_year_regdata_noimp.dta", replace



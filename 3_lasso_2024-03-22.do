*************************************************************
******* AIR POLLUTION & FERTILITY****************************
*************************************************************
*******       LASSO       *****************************
*************************************************************


if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\regs"
global do = "${workdir}\Do\Analysis"
global regress "do "$do\regs_for_indices_2023-06-02.do""
global model Lasso
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear


* Lasso
* https://www.stata.com/features/lasso/
* https://www.stata.com/manuals/lassolassoexamples.pdf




************************************
global pollist_mean z_PM10_mean_L1 z_SO2_mean_L1 z_O3_mean_L1 z_NO2_mean_L1 z_NO_mean_L1 z_CO_mean_L1 z_PM2_mean_L1 z_PM10_mean_L2 z_SO2_mean_L2 z_O3_mean_L2 z_NO2_mean_L2 z_NO_mean_L2 z_CO_mean_L2 z_PM2_mean_L2 z_NOX_as_NO2_mean_L1 z_NOX_as_NO2_mean_L2 
global pollist_mean2  z_C6H6_mean_L1 z_C6H6_mean_L2  z_Pb_in_PM10_mean_L1 z_Pb_in_PM10_mean_L2 

global pollist_D10 z_PM10_D10_L1 z_SO2_D10_L1 z_O3_D10_L1 z_NO2_D10_L1 z_NO_D10_L1 z_CO_D10_L1 z_PM2_D10_L1 z_PM10_D10_L2 z_SO2_D10_L2 z_O3_D10_L2 z_NO2_D10_L2 z_NO_D10_L2 z_CO_D10_L2 z_PM2_D10_L2 z_NOX_as_NO2_D10_L1 z_NOX_as_NO2_D10_L2 
global pollist_D102  z_C6H6_D10_L1 z_C6H6_D10_L2  z_Pb_in_PM10_D10_L1 z_Pb_in_PM10_D10_L2 

global pollist_D9 z_PM10_D9_L1 z_SO2_D9_L1 z_O3_D9_L1 z_NO2_D9_L1 z_NO_D9_L1 z_CO_D9_L1 z_PM2_D9_L1 z_PM10_D9_L2 z_SO2_D9_L2 z_O3_D9_L2 z_NO2_D9_L2 z_NO_D9_L2 z_CO_D9_L2 z_PM2_D9_L2 z_NOX_as_NO2_D9_L1 z_NOX_as_NO2_D9_L2 
global pollist_D92  z_C6H6_D9_L1 z_C6H6_D9_L2  z_Pb_in_PM10_D9_L1 z_Pb_in_PM10_D9_L2 


global pollist_D7 z_PM10_D7_L1 z_SO2_D7_L1 z_O3_D7_L1 z_NO2_D7_L1 z_NO_D7_L1 z_CO_D7_L1 z_PM2_D7_L1 z_PM10_D7_L2 z_SO2_D7_L2 z_O3_D7_L2 z_NO2_D7_L2 z_NO_D7_L2 z_CO_D7_L2 z_PM2_D7_L2 z_NOX_as_NO2_D7_L1 z_NOX_as_NO2_D7_L2 
global pollist_D72  z_C6H6_D7_L1 z_C6H6_D7_L2  z_Pb_in_PM10_D7_L1 z_Pb_in_PM10_D7_L2 

global pollist_I8 z_PM10_I8_L1 z_SO2_I8_L1 z_O3_I8_L1 z_NO2_I8_L1 z_NO_I8_L1 z_CO_I8_L1 z_PM2_I8_L1 z_PM10_I8_L2 z_SO2_I8_L2 z_O3_I8_L2 z_NO2_I8_L2 z_NO_I8_L2 z_CO_I8_L2 z_PM2_I8_L2 z_NOX_as_NO2_I8_L1 z_NOX_as_NO2_I8_L2 
global pollist_I82  z_C6H6_I8_L1 z_C6H6_I8_L2  z_Pb_in_PM10_I8_L1 z_Pb_in_PM10_I8_L2 

global pollist_I6 z_PM10_I6_L1 z_SO2_I6_L1 z_O3_I6_L1 z_NO2_I6_L1 z_NO_I6_L1 z_CO_I6_L1 z_PM2_I6_L1 z_PM10_I6_L2 z_SO2_I6_L2 z_O3_I6_L2 z_NO2_I6_L2 z_NO_I6_L2 z_CO_I6_L2 z_PM2_I6_L2 z_NOX_as_NO2_I6_L1 z_NOX_as_NO2_I6_L2 
global pollist_I62  z_C6H6_I6_L1 z_C6H6_I6_L2  z_Pb_in_PM10_I6_L1 z_Pb_in_PM10_I6_L2 

global pollist_I5 z_PM10_I5_L1 z_SO2_I5_L1 z_O3_I5_L1 z_NO2_I5_L1 z_NO_I5_L1 z_CO_I5_L1 z_PM2_I5_L1 z_PM10_I5_L2 z_SO2_I5_L2 z_O3_I5_L2 z_NO2_I5_L2 z_NO_I5_L2 z_CO_I5_L2 z_PM2_I5_L2 z_NOX_as_NO2_I5_L1 z_NOX_as_NO2_I5_L2 
global pollist_I52  z_C6H6_I5_L1 z_C6H6_I5_L2  z_Pb_in_PM10_I5_L1 z_Pb_in_PM10_I5_L2 



global pollist_max z_PM10_max_L1 z_SO2_max_L1 z_O3_max_L1 z_NO2_max_L1 z_NO_max_L1 z_CO_max_L1 z_PM2_max_L1 z_PM10_max_L2 z_SO2_max_L2 z_O3_max_L2 z_NO2_max_L2 z_NO_max_L2 z_CO_max_L2 z_PM2_max_L2 z_NOX_as_NO2_max_L1 z_NOX_as_NO2_max_L2 
global pollist_max2  z_C6H6_max_L1 z_C6H6_max_L2  z_Pb_in_PM10_max_L1 z_Pb_in_PM10_max_L2 
 
* 
*Lasso versions
**********
global seed 1234 // 1234 3456 87 567345
global grid 10000
*global grid 1000

* selection: CV
*global sel  cv //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  cv // ad_ridge ad_steps bic cv

* selection: CV SE-rule - recommended by Hastie, T., R. Tibshirani, and M. Wainwright. 2015.  Statistical Learning with Sparsity: The Lasso and Generalizations.  Boca Raton, FL: CRC Press.
*global sel  "cv, serule" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  cv_ser // ad_ridge ad_steps bic cv


* selection: adaptive, ridge
*global sel  "adaptive, ridge" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  ad_ridge // ad_ridge ad_steps bic cv

* selection: adaptive, steps
*global sel  "adaptive, steps(10)" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  ad_steps10 // ad_ridge ad_steps bic cv

* selection: adaptive, steps
*global sel  "adaptive, steps(100)" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  ad_steps100 // ad_ridge ad_steps bic cv

* selection: adaptive, power
*global sel  "adaptive, power(1.5)" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  ad_pow15 // ad_ridge ad_steps bic cv


* selection: BIC
*global sel  "bic" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
*global selname  bic // ad_ridge ad_steps bic cv

* selection: BIC
global sel  "bic, alllambdas" //  "adaptive, ridge" "adaptive, steps(10)"  "bic" cv
global selname  bic_alll // ad_ridge ad_steps bic cv


cap est drop *


lasso linear log_birth_rate  t i.country_num i.country_num##c.t  $pollist_I6 $pollist_I62, rseed($seed) selection($sel) grid($grid) cluster(nuts3_code)
est sto L_I6_$selname

lasso linear log_birth_rate  t i.country_num i.country_num##c.t  $pollist_I8 $pollist_I82, rseed($seed) selection($sel) grid($grid) cluster(nuts3_code)
est sto L_I8_$selname

lasso linear log_birth_rate  t i.country_num i.country_num##c.t  $pollist_D10 $pollist_D102, rseed($seed) selection($sel) grid($grid) cluster(nuts3_code)
est sto L_D10_$selname
 
lasso linear log_birth_rate  t i.country_num i.country_num##c.t  $pollist_mean $pollist_mean2 , rseed($seed) selection($sel) grid($grid) cluster(nuts3_code)
est sto L_mean_$selname


cap erase "$out/ALL_Lasso_${selname}_${seed}_grid${grid}.xls"
lassocoef  L_*_$selname, sort(coef, standardized) display(coef, format(%9.3g))
*mat list r(coef)
putexcel set "$out/ALL_Lasso_${selname}_${seed}_grid${grid}.xls", replace 
putexcel A1=matrix(r(coef)), names 




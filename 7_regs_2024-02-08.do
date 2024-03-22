*************************************************************
******* AIR POLLUTION & FERTILITY****************************
*************************************************************
*******       REGRESSIONS       *****************************
*************************************************************
*log 

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
global regress "do "$do\regs_for_indices_2024-02-08.do""
global robust "do "$do\robustness_heterog_2023-06-09.do""

*global model OLS_nowarm
global model OLS_nowarm_2wcl
*global model OLS_SM
global varlist3 l.gdp_pps  //gdp_pps  l2.gdp_pps  // if we include t-2 gdp data, we loose a lot of observations!!

 global factor F // Principal factor
* global factor PCF // Principal component factor
* global factor CORR  // Simple correlation matrix 
* global factor SM  //Simple mean


* IV - without warm temperature + Highest Wind speed days
global iv_list1_nwwsd l1.WS_mean l1.WS_mean_sq l1.WS_mean_cu   l1.HDD  l1.HDD_sq l1.HDD_cu l1.HDDXWS  l1.WS_sqXHDD l1.WSXHDD_sq l1.WS_cuXHDD l1.WSXHDD_cu l1.WS_8plus l1.WS_7plus l1.WS_6plus l1.WS_5plus l1.WS_4plus l1.WS_8plus_sq l1.WS_7plus_sq l1.WS_6plus_sq l1.WS_5plus_sq l1.WS_4plus_sq
global iv_list2_nwwsd l2.WS_mean l2.WS_mean_sq l2.WS_mean_cu   l2.HDD  l2.HDD_sq l2.HDD_cu l2.HDDXWS   l2.WS_sqXHDD l2.WSXHDD_sq l2.WS_cuXHDD l2.WSXHDD_cu l2.WS_8plus l2.WS_7plus l2.WS_6plus l2.WS_5plus l2.WS_4plus l2.WS_8plus_sq l2.WS_7plus_sq l2.WS_6plus_sq l2.WS_5plus_sq l2.WS_4plus_sq


global ivlist ${iv_list1_nwwsd} ${iv_list2_nwwsd}  // ezzel az I8 és I6 működik 

 
use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear
cap erase "$out/ALL_$model.xls"
cap erase "$out/ALL_$model.txt"


* Regressions: PM2_PM10_CO_F SO2  NO2_NOX_O3_F  
foreach indicator in I8 I6 D10 D9 mean  {
	global varlist1 l.PM2_PM10_CO_${factor}_`indicator' l.SO2_`indicator' l.NO2_NOX_O3_${factor}_`indicator'   
	global varlist2 l2.PM2_PM10_CO_${factor}_`indicator' l2.SO2_`indicator' l2.NO2_NOX_O3_${factor}_`indicator'    
	global version 1_`indicator'
	$regress	
}


 
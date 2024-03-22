*************************************************************
******* AIR POLLUTION & FERTILITY****************************
*************************************************************
*******       ONE-BY-ONE REGRESSIONS       *****************************
*************************************************************
*log 

if "`c(username)'" == "stump" {
	global workdir "C:\Users\stump\Dropbox\MakroFertilityPollution"
}

if "`c(username)'" == "szabomorvai.agnes" {
	global workdir "C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro"

}

global data = "${workdir}\Data\RegData"
global out = "${workdir}\Results\regs"
global do = "${workdir}\Do\Analysis"
global regress "do "$do\regs_for_indices_2023-06-07.do""
global robust "do "$do\robustness_heterog_2023-06-09.do""


global varlist3 l.gdp_pps  gdp_pps  l2.gdp_pps  
global factor F // Principal factor
 
 
 * IV - with cooling days
global iv_list1 l1.WS_mean l1.WS_mean_sq  l1.temp_mean 	l1.temp_mean_sq l1.HDD  l1.CDD  l1.tempXWS l1.HDDXtemp l1.HDDXWS l1.HDDXCDD l1.CDDXWS l1.CDDXtemp 
global iv_list2 l2.WS_mean l2.WS_mean_sq  l2.temp_mean  l2.temp_mean_sq l2.HDD  l2.CDD  l2.tempXWS l2.HDDXtemp l2.HDDXWS l2.HDDXCDD l2.CDDXWS l2.CDDXtemp
global iv_list3 l3.WS_mean l3.WS_mean_sq  l3.temp_mean  l3.temp_mean_sq l3.HDD  l3.CDD  l3.tempXWS l3.HDDXtemp l3.HDDXWS l3.HDDXCDD l3.CDDXWS l3.CDDXtemp
global iv_list4 l4.WS_mean l4.WS_mean_sq  l4.temp_mean  l4.temp_mean_sq l4.HDD  l4.CDD  l4.tempXWS l4.HDDXtemp l4.HDDXWS l4.HDDXCDD l4.CDDXWS l4.CDDXtemp
* IV - without cooling days
global iv_list1_nocool l1.WS_mean l1.WS_mean_sq  l1.temp_mean 	l1.temp_mean_sq l1.HDD  l1.tempXWS l1.HDDXtemp l1.HDDXWS 
global iv_list2_nocool l2.WS_mean l2.WS_mean_sq  l2.temp_mean 	l2.temp_mean_sq l2.HDD  l2.tempXWS l2.HDDXtemp l2.HDDXWS 

* IV - ver3 
global iv_list1_v3 l1.WS_mean l1.WS_mean_sq  l1.temp_mean 	l1.temp_mean_sq 
global iv_list2_v3 l2.WS_mean l2.WS_mean_sq  l2.temp_mean 	l2.temp_mean_sq 


global ivlist ${iv_list1} ${iv_list2}


use "${data}\airpollution_fertility_year_regdata_noimp.dta", clear
cap erase "$out/ALL_$model.xls"
cap erase "$out/ALL_$model.txt"

global model OneByOne
* Regressions one-by-one  
foreach pol in PM10 PM2 CO  SO2 O3 NO2  NOX_as_NO2 {
	global varlist1 l.`pol'_mean    
	global varlist2 l2.`pol'_mean     
	global version onebyone
	$regress	
}


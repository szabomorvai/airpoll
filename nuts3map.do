*This do file creates a file for drawing maps in STATA
global workdir = "F:\Airpoll"
cd "${workdir}\map"

*EU shapefiles: https://gisco-services.ec.europa.eu/distribution/v2/nuts/shp/NUTS_RG_01M_2016_4326.shp.zip
spshape2dta "${workdir}\map\NUTS_RG_01M_2016_4326", replace
*Andorra: https://stacks.stanford.edu/file/druid:ny306fn1401/data.zip
spshape2dta "${workdir}\map\AD\AND_adm0", replace

use "${workdir}\map\AND_adm0.dta", clear
gen FID = "AD001"
keep _ID _CX _CY FID
save, replace

use "${workdir}\map\NUTS_RG_01M_2016_4326.dta", clear
append using "${workdir}\map\AND_adm0.dta"
replace _ID = _N if FID == "AD001"
rename FID NUTS3_code
save "${workdir}\map\nuts3map.dta", replace

*appending andorra to the _shp
use "F:\Airpoll\map\AND_adm0_shp.dta", clear
replace _ID = 2017
save, replace

use "${workdir}\map\NUTS_RG_01M_2016_4326_shp.dta", clear
append using "${workdir}\map\AND_adm0_shp.dta"
keep if _X > -25 & _Y >34 // get rid of the small islands
sort _ID
save  "${workdir}\map\nuts3map_shp.dta", replace

*Canary Islands provincias are not the same as nuts3s. 
* Santa Cruz de Tenerife (ES701): El Hierro ES703, La Palma ES707, La Gomera ES706, Tenerfie ES709
* Las Palmas(ES702): Gran Canaria ES705, Fuerteventura ES704, Lanzarote ES708



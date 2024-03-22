* Regressions to run
* On different pollution indices

* Sample
* IV
* weights
global weights [pweight = fpop_TOTAL]

cap drop sample
sort nuts3_code year 
ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
gen sample = e(sample)


reghdfe  log_birth_rate $varlist1 if sample == 1 $weights, vce(cluster nuts3_code) absorb(i.nuts3_code##c.t   t i.nuts3_code)
outreg2 using "$out/airpoll_$version.xls", coefastr bracket replace  dec(3) fmt(fc)   addstat(F test, e(p)) keep( $varlist1 $varlist2 $varlist3 ) ctitle(Model 1) 

reghdfe  log_birth_rate $varlist1 $varlist2 if sample == 1 $weights, vce(cluster nuts3_code) absorb(i.nuts3_code##c.t   t i.nuts3_code)
outreg2 using "$out/airpoll_$version.xls", coefastr bracket append  dec(3) fmt(fc) addstat(F test, e(p))keep( $varlist1 $varlist2 $varlist3 ) ctitle(Model 2)

reghdfe  log_birth_rate $varlist1 $varlist2 $varlist3 if sample == 1 $weights, vce(cluster nuts3_code) absorb(i.nuts3_code##c.t   t i.nuts3_code)
outreg2 using "$out/airpoll_$version.xls", coefastr bracket append  dec(3) fmt(fc)   keep( $varlist1 $varlist2 $varlist3 ) ctitle(Model 3)
outreg2 using "$out/ALL_$model.xls", coefastr bracket append  dec(3) fmt(fc) addstat(F test, e(p))  keep( $varlist1 $varlist2 $varlist3 ) ctitle(OLS_$version) 


* IV
ivreghdfe log_birth_rate ($varlist1 $varlist2 = $ivlist)  $varlist3 if sample == 1 $weights, absorb(i.nuts3_code##c.t t i.nuts3_code) cluster(nuts3_code) 
outreg2 using "$out/airpoll_$version.xls", coefastr bracket append  dec(3) fmt(fc) keep( $varlist1 $varlist2 $varlist3 ) ctitle(Model 4)
outreg2 using "$out/ALL_$model.xls", coefastr bracket append  dec(3)  fmt(fc) addstat(F test, e(p)) keep( $varlist1 $varlist2 $varlist3 ) ctitle(IV_$version) 




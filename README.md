# airpoll
Air pollution in the EU

The data files of this project can be requested from the authors. 
Email to: szabomorvai.agnes@krtk.hun-ren.hu 

************************************************
* Map
************************************************

nuts3map.do
	Generates files necessary for making maps.
	Shape files downloaded from: https://gisco-services.ec.europa.eu/distribution/v2/nuts/shp/NUTS_RG_01M_2016_4326.shp.zip
	--> nuts3map_shp.dta

************************************************
* Data for regressions
************************************************


merge_year.do
	nuts3_year_all.dta --> airpollution_fertility_year.dta

stats.do
	airpollution_fertility_year.dta --> airpollution_fertility_year_regdata_noimp.dta


************************************************
* Data analysis
************************************************


regs_2023-06-24.do
regs_for_indices_2023-06-07.do
lasso_2023-06-28.do
descriptives_graphs.do


*************************************************************
* Tables and graphs
*************************************************************
Tables
******

Table 1: Summary statistics 
	descriptive_tables_tolatex.do


Table 2: OLS and 2SLS regression estimates
	tables_tolatex.do

Table 3: LASSO results
	lasso_2023-06-28.do

Table 4: Heterogeneity by PM10 and GDP 
	robustness_heterog.do


Table A.9: Correlation matrix
	descriptive_tables_tolatex.do


Table A.10: Factor loadings of PM Factor and NO Factor
	stats.do

Table A.11: Mean pollution concentrations by year
	tables_to_latex_obs_by_country.do

Table A.12: First stage results 
	regs_for_indices_2024-02-08.do

Table A.13: First stage results (Eq.4) with PM Factor (t-1) as the dependent variable
	regs_for_indices_2024-02-08.do
	
Table A.14: OLS and 2SLS regression results: including only one pollutant at a time
	regs_onebyone_2023-06-21.do

Table A.15: LASSO results with λ selection methods of cross-validation and BIC
	lasso_2023-06-28.do

Table A.16: LASSO results with adaptive λ selection methods
	lasso_2023-06-28.do

Table A.17: LASSO results summary
	lasso_2023-06-28.do
	"C:\Users\szabomorvai.agnes\Dropbox\Research\AirPollutionFertility_Makro\Results\Input tables\LASSO.xlsx"


Table A.18: Instrumental variables estimates for various measures of ambient pollution 
	robustness_heterog_2023-06-22.do


Table A.19: Instrumental variables estimates for various methods of factorizing
	robustness_heterog_2023-06-22.do

Table A.19: Number of NUTS-3 - year observations by country in the regressions
	regs_2024-02-08.do	



Graphs
******


Figure 1: Map birth rate 
	maps_2024-02-16.do

Figure 2: Map PM10
	maps_2024-02-16.do


Figure 3: Map simulation
	simulation.do
	

Figure A.4 & A.5: Average pollution concentrations (in year t) and log birth rates (in year t+1)
	descriptive_graphs_2023-07-05.do

Figure A.6: Instruments and average pollution concentrations
	descriptive_graphs_2023-07-05.do

Figure A.7-8: Histograms of pollution concentrations with European health standard limits
	histograms_limits.do



Figure A.9-17: Maps: The average XXX pollution in NUTS-3 regions
	maps_2024-02-16.do
	
Figure A.18: Map: NUTS-3 regions above and below median GDP
	maps_2024-02-16.do


	

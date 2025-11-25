
*! version 0.0.1 Priscillia Hunt 7/14/2021

	
capture program drop synth_asmd
program synth_asmd
version 17.0

preserve

/* check if data is tsset with panel and time var */
  qui tsset
  local tvar `r(timevar)'
  local pvar "`r(panelvar)'"
    if "`tvar'" == "" {
    di as err "panel unit variable missing please use -tsset panelvar timevar"
    exit 198
    }

    if "`pvar'" == "" {
    di as err "panel time variable missing please use -tsset panelvar timevar"
    exit 198
    }

	
	
syntax [anything] , ///
	TRUnit(numlist min=1 max=1 int sort) ///
	TRPeriod(numlist min=1 max=1 int sort) ///
	data(string) ///
	depvar(string) ///
	
/* Check User Inputs  ************************* */	
/* Treated an control unit numbers */

   /* Check if tr unit is found in panelvar */
    qui levelsof `pvar',local(levp)
    loc checkinput: list trunit in levp
    if `checkinput' == 0 {
     di as err "treated unit not found in panelvar - check tr()"
     exit 198
    }	

/* Build pre-treatment period */

  /*Check if intervention period is among timevar */
    qui levelsof `tvar', local(levt)
    loc checkinput: list trperiod in levt
    if `checkinput' == 0 {
    di as err "period of treatment is not not found in timevar - check trperiod()"
    exit 198
    }

	
	
********************************

/* Outcomes and Weights Datasets */
qui{
	
	use "`data'", clear
		keep _Y_treated _Y_synthetic _time
			drop if _time==.
			rename _time `tvar'
			
			tempfile outcomes
			save `outcomes'

	use "`data'", clear
		keep _Co_Number _W_Weight
			drop if _W_Weight==0
			rename _Co_Number `pvar'
			
			tempfile weight
			save `weight'
			
	restore, preserve
	merge m:1 `tvar' using `outcomes', nogen
	merge m:1 `pvar' using `weight',  nogen

	
/* Keep preperiod only*/
keep if `tvar'<`trperiod'
	
** generate standard deviations for ASMD denominator
	egen sd_synth = sd(`depvar') if _W_Weight!=., by(`tvar')
** prep as treatment-year panel
	collapse (mean) sd_synth _Y_treated _Y_synthetic ,by(`tvar')

	
// asmd for SC unit
	gen ASMD_synth=abs(_Y_treated-_Y_synthetic)/sd_synth


	su ASMD_synth
	return list
	gen ASMD_mean=r(mean)
	gen ASMD_max=r(max)
	
}	
	di "ASMD mean:"
	display ASMD_mean 
	di "ASMD max:"
	display ASMD_max

end
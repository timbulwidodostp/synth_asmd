{smcl}
{* *! version 0.0.1 Priscillia Hunt 7/14/2021}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "C:\ado\personal\synth_asmd##syntax"}{...}
{viewerjumpto "Description" "C:\ado\personal\synth_asmd##description"}{...}
{viewerjumpto "Options" "C:\ado\personal\synth_asmd##options"}{...}
{viewerjumpto "Remarks" "C:\ado\personal\synth_asmd##remarks"}{...}
{viewerjumpto "Examples" "C:\ado\personal\synth_asmd##examples"}{...}
{title:Title}

{phang}
{bf:synth_asmd} {hline 2} Absolute Standardized Mean Difference (ASMD) for the synthetic control method


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}

{marker description}{...}
{title:Description}

{pstd}
{cmd:synth_asmd} calculates the absolute standardized mean difference statistic to assess balance between the treated group and synthetic control group on pre-intervention outcomes. 

    synth_asmd, trunit(#) trperiod(#) depvar() data()

{marker options}{...}
{title:Required Settings}

{phang}
{opt depvar} the outcome variable

{phang}
{opt trunit(#)} the unit number of the unit affected by the intervention as given in the panel id variable specified in tsset panelvar; see tsset. Notice that only a single unit number can be specified. If the intervention of interest affected several units the user may chose to combine these units first and then treat them as a single unit affected by the
intervention.


{phang}
{opt trperiod(#)} the time period when the intervention occurred. The time period refers to the panel time variable specified in tsset timevar; see tsset. Only a single number can be specified.


{phang}
{opt data(filename)} uses the dataset of results saved from synth using filename.dta.
 
 The filename.dta should hold the following variables:

        {phang}_time:
            A variable that contains the respective time period (from the tsset panel time variable (timevar)) for all periods specified in resultsperiod().

        {phang}_Y_treated:
            The observed outcome depvar for the treated unit specified in tr() for each time period specified in resultsperiod().

        {phang}_Y_synthetic:
            The estimated outcome depvar for the synthetic control unit estimated using the convex combination of the control units specified in co() for each time period specified in resultsperiod().

        {phang}_Co_Number:
            A variable that contains the unit number (from the tsset panel unit variable (panelvar) for each control unit specified in co(). If unit names are supplied via conames()the unit numbers will be labeled accordingly (each control unit number is labeled with its respective name from conames().

        {phang}_W_weight:
            A variable that contains the estimated unit weight for each control units specified in co().



{marker remarks}{...}
{title:Remarks}

{pstd}
To use synth_asmd, perform the following steps:
(1) obtain file of results using synth with the keep option; and
(2) compute synth_asmd immediately following synth.


synth_asmd requires the unit affected by the intervention, when the intervention started, the outcome of interest, and dataset generated using synth. 



{marker examples}{...}
{title:Examples}

    Declare path for synth package and example dataset:
    . cd C:\ado\plus\s

    Install the synth package:
    . ssc install synth, all

    Load Example Data: This panel dataset contains information for 39 US States for the years 1970-2000 (see Abadie, Diamond, and Hainmueller (2010) for details).
    . sysuse synth_smoking

    Declare the dataset as panel:
    . tsset state year

    Declare a location for keeping the result file:
    . cd C:\Users\yourname\Desktop\smokingproject

    Example 1 - Construct synthetic control group keeping results:
    . synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) keep("synth_cigsale.dta")

    ASMD - Calculate the mean and max ASMD
    . synth_asmd, trunit(3) trperiod(1989) depvar(cigsale) data("synth_cigsale.dta")	


{title:References}
{pstd}
Parast, L., Hunt, P. Griffin, B.A., and D. Powell. 2020. When Is a Match Sufficient? A Score-based Balance Metric for the Synthetic Control Method. Journal of Causal Inference 8(1): 209–228.

{pstd}
Abadie, A., Diamond, A., and J. Hainmueller. 2010. Synthetic Control Methods for Comparative Case Studies: Estimating the Effect of California's Tobacco Control Program.  Journal of the American Statistical Association 105(490): 493-505.

{title:Authors}
{pstd}
Priscillia Hunt, phunt@rand.org
RAND
function DisplayHelp
    skipline( );
    disp( 'This is dynareOBC: A toolkit for handling occasionally binding constraints with dynare, by Tom Holden.' );
    skipline( );
    disp( 'Requirements (to be installed and added to your Matlab path):' );
    disp( ' * Matlab version R2013a or later, or a fully compatible clone.' );
    disp( ' * The MATLAB Optimization toolbox, or a fully compatible clone.' );
    disp( ' * dynare, version 4.4 or later, from: http://www.dynare.org/download/dynare-stable' );
    skipline( );
    disp( 'dynareOBC incorporates code by Alexander Meyer-Gohde for calculating risky first order approximations.' );
    disp( 'More information is contained in his paper describing the algorithm, available here:' );
    disp( 'http://enim.wiwi.hu-berlin.de/vwl/wtm2/mitarbeiter/meyer-gohde/stochss_main.pdf.' );
    disp( 'dynareOBC also incorporates code taken from the nonlinear moving average toolkit,' );
    disp( 'by Hong Lan and Alexander Meyer-Gohde.' );
    disp( 'Additionally, dynareOBC incorporates code for nested Gaussian cubature that is copyright Alan Genz' );
    disp( 'and Bradley Keister, 1996, code for LDL decompositions that is copyright Brian Borchers, 2002, and' );
    disp( 'code for displaying a progress bar that is copyright Antonio Cacho, "Stefan" and Jeremy Scheff, 2014.' );
    skipline( );
    disp( 'Usage: dynareOBC FILENAME[.mod,.dyn] [OPTIONS]' );
    skipline( );
    disp( 'dynareOBC executes instruction included in the conventional dynare mod file, FILENAME.mod.' );
    skipline( );
    disp( 'Unlike dynare, dynareOBC can handle simulation of models containing non-differentiable functions.' );
    disp( 'Note:' );
    disp( ' * dynareOBC approximates the non-differentiable function in levels. Thus if r and pi are the' );
    disp( '   endogenous variables of interest: "r = max( 0, 0.005 + 1.5 * pi );" will be more accurate than:' );
    disp( '   "exp(R) = max( 1, exp( 0.005 + 1.5 * pi ) );".' );
    disp( ' * dynareOBC may produce strange results on models with an indeterminate steady-state, so caution' );
    disp( '   should be taken when using the STEADY_STATE command. The initval or steady_state_model blocks' );
    disp( '   should not be used to attempt to pin down a steady-state, since these will be ignored by dynareOBC' );
    disp( '   in later steps of its solution procedure.' );
    skipline( );
    disp( '[OPTIONS] include:' );
    disp( ' * global' );
    disp( '      Without this, dynareOBC assumes agents realise that shocks may arrive in the near future which' );
    disp( '      push them towards the bound, but they do not take into account the risk of hitting the bound' );
    disp( '      in the far future. With the global option, dynareOBC assumes agents take into account the risk' );
    disp( '      of hitting the bound at all horizons. Note that this is significantly slower.' );
    disp( '       * maxiterations=NUMBER (default: 1000)' );
    disp( '            The maximum number of iterations of the global fixed-point algorithm.' );
    disp( '       * fixedpointacceleration' );
    disp( '            Enables an accelerated fixed-point algorithm, when using global. Works only for very well' );
    disp( '            behaved problems, when starting close to the solution.' );
    disp( '       * resume' );
    disp( '            Resumes an interrupted solution iteration, when using global.' );
    disp( ' * maxcubaturedegree=NUMBER (default: 7)' );
    disp( '      Specifies the degree of polynomial which will be integrated exactly in the highest degree,' );
    disp( '      cubature performed. Values above 51 are treated as equal to 51.' );
    disp( '       * cubatureaccuracy=NUMBER (default: 6)' );
    disp( '            Specifies that the maximum acceptable change in the integrals is 10^(-NUMBER).' );
    disp( '       * kappapriorparameter=NUMBER (default: 1)' );
    disp( '            The rate of decay of the standard deviation of the error is given a Frechet distributed' );
    disp( '            prior with shape parameter 1/NUMBER. Setting this to 0 disables the prior on kappa.' );
    disp( '       * nostatisticalcubature' );
    disp( '            Disables the statistical improvement to the cubature algorithm, which aggregates results' );
    disp( '            of cubature at different degrees. Will generally reduce accuracy, but increase speed.' );
    disp( ' * nocubature' );
    disp( '      Speeds up dynareOBC by assuming that agents are "surprised" by the existence of the bound.' );
    disp( '      At order=1, this is equivalent to a perfect foresight solution to the model.' );
    disp( ' * fastcubature' );
    disp( '      Causes dynareOBC to ignore the value specified in maxcubaturedegree, and to instead use a' );
    disp( '      degree 3 rule without negative weights, but involving evaluations further from the origin.' );
    disp( ' * maxcubaturedimension=NUMBER (default: infinity)' );
    disp( '      The maximum dimension over which to integrate.' );
    disp( ' * firstorderconditionalcovariance' );
    disp( '      When order>1 (possibly with firstorderaroundrss or firstorderaroundmean), by default,' );
    disp( '      dynareOBC uses a second order approximation of the conditional covariance.' );
    disp( '      This option specifies that a first order approximation should be used instead.' );
    disp( ' * timetoescapebounds=NUMBER (default: 10)' );
    disp( '      The number of periods following a shock after which the model is expected to be away from any' );
    disp( '      occasionally binding constraints. This also controls the number of periods of uncertainty over' );
    disp( '      which we integrate.' );
    disp( ' * timetoreturntosteadystate=NUMBER (default: requested IRF length)' );
    disp( '      The number of periods in which to verify that the constraints are not being violated.' );
    disp( ' * firstorderaroundrss' );
    disp( '      Takes a linear approximation around the risky steady state of the non-linear model.' );
    disp( '      If specifying this option, you should set order=2 or order=3 in your mod file.' );
    disp( ' * firstorderaroundmean' );
    disp( '      Takes a linear approximation around the ergodic mean of the non-linear model.' );
    disp( '      If specifying this option, you should set order=2 or order=3 in your mod file.' );
    disp( ' * algorithm=0|1|2|3 (default: 0)' );
    disp( '      If algorithm=0, an arbitrary solution is returned when there are several.' );
    disp( '      If algorithm=1, a linear programming problem is solved first, which will increase the likelihood' );
    disp( '      that the same solution is always returned, without guaranteeing this.' );
    disp( '      When algorithm>1, the specific solution determined by the objective option is returned.' );
    disp( '      If algorithm=2 then this is guaranteed via homotopy.' );
    disp( '      When algorithm=3, this is guaranteed via the solution of a QCQP problem.' );
    disp( '       * homotopysteps=NUMSTEPS (default: 10)' );
    disp( '            The number of homotopy steps to take when using algorithm=1.' );
    disp( '       * objective=1|2 (default: 2)' );
    disp( '            The norm of alpha to minimise when algorithm>0.' );
    disp( ' * fastirfs' );
    disp( '      Calculates a fast approximation to IRFs without any Monte-Carlo simulation.' );
    disp( '      Without this option, dynareOBC calculates average IRFs.' );
    disp( ' * irfsaroundzero' );
    disp( '      By default, IRFs are centered around the risky steady state with the fastirfs option, or around' );
    disp( '      the approximate mean without it. This option instead centers IRFs around 0.' );
    disp( ' * shockscale=NUMBER' );
    disp( '      Scale of shocks for IRFs.' );
    disp( ' * mlvsimulationmode=0|1|2|3 (default: 0)' );
    disp( '      If mlvsimulationmode=0, dynareOBC does not attempt to simulate the path of model local variables.' );
    disp( '      If mlvsimulationmode>0, dynareOBC generates simulated paths and average impulse responses for each' );
    disp( '      model local variable (MLV) which is used in the model, non-constant, non-forward looking, and not' );
    disp( '      purely backwards looking.' );
    disp( '      If mlvsimulationmode>1, dynareOBC additionally generates simulated paths and average impulse' );
    disp( '      responses for each non-constant MLV, used in the model, containing forward looking terms.' );
    disp( '      If mlvsimulationmode=2, then dynareOBC takes the expectation of each forward looking MLV using' );
    disp( '      sparse cubature.' );
    disp( '      If mlvsimulationmode=3, then dynareOBC takes the expectation of each forward looking MLV using' );
    disp( '      Monte Carlo integration.' );
    disp( '       * mlvsimulationcubaturedegree=NUMBER (default: 9)' );
    disp( '            Specifies the degree of polynomial which should be integrated exactly, when mlvsimulationmode=1.' );
    disp( '            Values above 51 are treated as equal to 51.' );
    disp( '       * mlvsimulationsamples=NUMBER (default: 2000)' );
    disp( '            Specifies the number of samples to use for Monte Carlo integration, when mlvsimulationmode=2.' );
    disp( ' * nosparse' );
    disp( '      By default, dynareOBC replaces all of the elements of the decision rules by sparse matrices, as' );
    disp( '      this generally speeds up dynareOBC. This option prevents dynareOBC from doing this.' );
    disp( ' * estimation' );
    disp( '      Enables estimation of the model''s parameters.' );
    disp( '       * estimationdatafile=STRING (default: MOD-FILE-NAME.xlsx)' );
    disp( '            Specifies the spreadsheet containing the data to estimate.' );
    disp( '       * estimationfixedpointmaxiterations=NUMBER (default: 100)' );
    disp( '            The maximum number of iterations used to evaluate the stationary distribution.' );
    disp( ' * useficoxpress' );
    disp( '      Performance of dynareOBC is higher when the FICO Xpress library is installed.' );
    disp( '      This is available for free to academics from: https://community.fico.com/download.jspa' );
    disp( ' * nocleanup' );
    disp( '      Prevents the deletion of dynareOBC''s temporary files. Useful for debugging.' );
    skipline( );
    disp( 'See the dynare reference manual for other available options.' );
    skipline( );
    disp( 'Note that dynareOBC only supports some of the options of stoch_simul, and no warning is generated' );
    disp( 'if it is used with an unsupported option. Currently supported options for stoch_simul are:' );
    disp( ' * irf=NUMBER' );
    disp( ' * periods=NUMBER' );
    disp( ' * drop=NUMBER' );
    disp( ' * order=1|2|3' );
    disp( ' * replic=NUMBER' );
    disp( ' * loglinear' );
    disp( ' * irf_shocks' );
    disp( ' * nograph' );
    disp( ' * nodisplay' );
    disp( ' * nomoments' );
    disp( ' * nocorr' );
    skipline( );
    disp( 'dynareOBC also supports a list of variables for simulation after the call to stoch_simul.' );
    disp( 'When mlvsimulationmode>0, this list can include the names of model local variables. Any MLV' );
    disp( 'included in this list will be simulated even if it does not meet the previous criteria.' );
    skipline( );
end

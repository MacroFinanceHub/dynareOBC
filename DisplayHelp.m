function DisplayHelp
    skipline( );
    disp( 'This is dynareOBC: A toolkit for handling occasionally binding constraints with dynare, by Tom Holden.' );
    skipline( );
    disp( 'Requirements (to be installed and added to your Matlab path):' );
    disp( ' * Matlab version R2013a or later, or a fully compatible clone.' );
    disp( ' * The MATLAB Optimization toolbox, or a fully compatible clone.' );
    disp( ' * dynare, version 4.4 or later, from: http://www.dynare.org/download/dynare-stable' );
    disp( ' * Tom Holden''s fork of Hong Lan and Alexander Meyer-Gohde''s nonlinear moving average toolkit,' );
    disp( '   available from: https://github.com/tholden/nlma' );
    skipline( );
    disp( 'dynareOBC incorporates code by Alexander Meyer-Gohde for calculating risky first order approximations.' );
    disp( 'More information is contained in his paper describing the algorithm, available here:' );
    disp( 'http://enim.wiwi.hu-berlin.de/vwl/wtm2/mitarbeiter/meyer-gohde/stochss_main.pdf.' );
    disp( 'dynareOBC also incorporates code taken from the aforementioned nonlinear moving average toolkit,' );
    disp( 'by Hong Lan and Alexander Meyer-Gohde.' );
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
    disp( ' * accuracy=0|1|2 (default: 1)' );
    disp( '      If accuracy<2, dynareOBC solves under the simplifying assumption that agents are perpetually' );
    disp( '      surprised by the bounds. Much faster, but inaccurate if the bound is hit regularly.' );
    disp( '      With accuracy=0, dynareOBC additionally assumes that agents act in a perfect-foresight manner' );
    disp( '      with respect to "shadow shocks".' );
    disp( '       * removenegativequadratureweights' );
    disp( '            Zeros all negative quadrature weights, when accuracy>0. May or may not improve accuracy.' );
    disp( '       * forceequalquadratureweights' );
    disp( '            Uses equal quadrature weights, when accuracy>0. May or may not improve accuracy.' );
    disp( '       * orderfivequadrature' );
    disp( '            Use a degree 5 quadrature rule, rather than the default degree 3 one, when accuracy>0.' );
    disp( '       * pseudoorderfivequadrature' );
    disp( '            Use a pseduo degree 5 quadrature rule instead, when accuracy>0.' );
    disp( '       * maxintegrationdimension=NUMBER (default: infinity)' );
    disp( '            The maximum dimension over which to integrate, when accuracy>0. Setting this to 0 makes' );
    disp( '            accuracy=1 equivalent to accuracy=0' );
    disp( '       * firstorderconditionalcovariance' );
    disp( '            When accuracy>0 and order>1 (possibly with firstorderaroundrss or firstorderaroundmean),' );
    disp( '            by default, dynareOBC uses a second order approximation of the conditional covariance.' );
    disp( '            This option specifies that a first order approximation should be used instead.' );
    disp( '       * shadowshocknumbermultiplier=NUMBER (default: the order of approximation)' );
    disp( '            The number of shocks with which to approximate the distribution of each shadow shock' );
    disp( '            innovation, when accuracy=2.' );
    disp( '       * shadowapproxmiatingorder=NUMBER (default: the order of approximation)' );
    disp( '            The order with which to approximate the expected component of each shadow shock, when' );
    disp( '            accuracy=2.' );
    disp( '       * regressionbasesamplesize=NUMBER (default: 1000)' );
    disp( '            The base sample size for the regression used within the accuracy=2, semi-global' );
    disp( '            approximation loop.' );
    disp( '       * regressionsamplesizemultiplier=NUMBER (default: 30)' );
    disp( '            The number by which the regression sample size increases for each additional regressor,' );
    disp( '            within the accuracy=2, semi-global approximation loop.' );
    disp( '       * maxiterations=NUMBER (default: 1000)' );
    disp( '            The maximum number of iterations of the accuracy=2 fixed-point algorithm.' );
    disp( '       * densityaccuracy=NUMBER (default: 10)' );
    disp( '            The density of the regression residuals when accuracy=2 will be evaluated on a grid with' );
    disp( '            2^NUMBER points.' );
    disp( '       * densityestimationsimulationlengthmultipler=NUMBER (default: 10)' );
    disp( '            The multiplier on the length of simulation to use for matching the shadow shock density.' );
    disp( '       * resume' );
    disp( '            Resumes an interrupted semi-global solution iteration, when accuracy=2.' );
    disp( ' * timetoescapebounds=NUMBER (default: 10)' );
    disp( '      The number of periods following a shock after which the model is expected to be away from any' );
    disp( '      occasionally binding constraints. When accuracy>0, this also controls the number of periods of' );
    disp( '      uncertainty over which we integrate.' );
    disp( ' * timetoreturntosteadystate=NUMBER (default: requested IRF length)' );
    disp( '      The number of periods in which to verify that the constraints are not being violated.' );
    disp( ' * firstorderaroundrss' );
    disp( '      Takes a linear approximation around the risky steady state of the non-linear model.' );
    disp( '      If specifying this option, you should set order=2 or order=3 in your mod file.' );
    disp( ' * firstorderaroundmean' );
    disp( '      Takes a linear approximation around the ergodic mean of the non-linear model.' );
    disp( '      If specifying this option, you should set order=2 or order=3 in your mod file.' );
    disp( ' * algorithm=0|1|2|3 (default: 0)' );
    disp( '      If algorithm=0, an arbitrary solution is returned when there are several. If algorithm=1, a linear' );
    disp( '      programming problem is solved first, which will increase the likelihood that the same solution is' );
    disp( '      always returned, without guaranteeing this. When algorithm>1, the specific solution determined by' );
    disp( '      the objective option is returned. If algorithm=2 then this is guaranteed via homotopy, and when' );
    disp( '      algorithm=3, this is guaranteed via the solution of a quadratically constrained quadratic' );
    disp( '      programming problem.' );
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
    disp( ' * simulatemlvs' );
    disp( '      Causes dynareOBC to generate simulated paths for the expected value of each model local variable.' );
    disp( ' * nosparse' );
    disp( '      By default, dynareOBC replaces all of the elements of the decision rules by sparse matrices, as' );
    disp( '      this generally speeds up dynareOBC. This option prevents dynareOBC from doing this.' );
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
    skipline( );
end

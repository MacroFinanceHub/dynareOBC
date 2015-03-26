function [ oo, dynareOBC ] = FastIRFs( M, options, oo, dynareOBC )
% derived from nlma_irf.m
    
    IRFOffsets = struct;
    IRFsWithoutBounds = struct;
    T = dynareOBC.InternalIRFPeriods;
    Ts = dynareOBC.IRFPeriods;
    % Compute irf, allowing correlated shocks
    SS = M.Sigma_e + 1e-14 * eye( M.exo_nbr );
    cs = transpose( chol( SS ) );
    
    for i = dynareOBC.ShockSelect
        Shock = zeros( M.exo_nbr, 1 ); % Pre-allocate and reset irf shock sequence
        Shock(:,1) = dynareOBC.ShockScale * cs( M.exo_names_orig_ord, i );
        
        %pruning_abounds( M, options, IRFShockSequence, T, dynareOBC.Order, 'lan_meyer-gohde', 1 );
        TempIRFStruct = ExpectedReturn( Shock, M, oo.dr, dynareOBC );
        
        TempIRFOffsets = repmat( dynareOBC.Mean, 1, T );
        
        TempIRFs = TempIRFStruct.total - TempIRFOffsets;
        
        ZeroLowerBoundedReturnPath = vec( TempIRFStruct.total( dynareOBC.VarIndices_ZeroLowerBounded, : )' );
        
        [ alpha, ~, ConstrainedReturnPath ] = SolveBoundsProblem( ZeroLowerBoundedReturnPath, dynareOBC );
        if ~dynareOBC.NoCubature
            alpha = PerformCubature( alpha, ZeroLowerBoundedReturnPath, ConstrainedReturnPath, options, oo, dynareOBC, TempIRFStruct.first, [ 'Computing required integral for fast IRFs for shock ' dynareOBC.Shocks{i} '. Please wait for around ' ], '. Progress: ', [ 'Computing required integral for fast IRFs for shock ' dynareOBC.Shocks{i} '. Completed in ' ] );
        end
        
        for j = dynareOBC.VariableSelect
            IRFName = [ deblank( M.endo_names( j, : ) ) '_' deblank( M.exo_names( i, : ) ) ];
            CurrentIRF = TempIRFs( j, 1:Ts );
            IRFsWithoutBounds.( IRFName ) = CurrentIRF;
            if dynareOBC.NumberOfMax > 0
                CurrentIRF = CurrentIRF + ( dynareOBC.MSubMatrices{ j }( 1:Ts, : ) * ( alpha .* M.params( dynareOBC.ParameterIndices_Signs ) ) )';
            end
            oo.irfs.( IRFName ) = CurrentIRF;
            IRFOffsets.( IRFName ) = TempIRFOffsets( j, 1:Ts );
        end
    end
    dynareOBC.IRFOffsets = IRFOffsets;
    dynareOBC.IRFsWithoutBounds = IRFsWithoutBounds;
    
end

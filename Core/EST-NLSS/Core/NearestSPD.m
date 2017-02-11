% Copyright (c) 2013, John D'Errico & 2016, Tom Holden
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
% 

function [ Ahat, cholAhat ] = NearestSPD( A )
    % nearestSPD - the nearest (in Frobenius norm) Symmetric Positive Definite matrix to A
    % usage: Ahat = nearestSPD(A)
    %
    % From Higham: "The nearest symmetric positive semidefinite matrix in the
    % Frobenius norm to an arbitrary real matrix A is shown to be (B + H)/2,
    % where H is the symmetric polar factor of B=(A + A')/2."
    %
    % http://www.sciencedirect.com/science/article/pii/0024379588902236
    %
    % arguments: (input)
    %  A - square matrix, which will be converted to the nearest Symmetric
    %    Positive Definite Matrix.
    %
    % Arguments: (output)
    %  Ahat - The matrix chosen as the nearest SPD matrix to A.
    %  cholAhat - The cholesky root of Ahat

    if nargin ~= 1
      error('Exactly one argument must be provided.')
    end

    % test for a square matrix A
    [ r, c ] = size( A );
    if r ~= c
      error('A must be a square matrix.')
    elseif r == 1
      % A was scalar
      Ahat = max( real( A ), eps );
      cholAhat = sqrt( Ahat );
      return
    end

    % symmetrize A into B
    Ahat = 0.5 * ( A + A' );

    [ cholAhat, p ] = chol( Ahat );

    if p ~= 0

        % Compute the symmetric polar factor of B. Call it H.
        % Clearly H is itself SPD.
        [ ~, Sigma, V ] = svd( Ahat );
        H = V * Sigma * V';

        % get Ahat in the above formula
        Ahat = 0.5 * ( Ahat + H );

        % ensure symmetry
        Ahat = 0.5 * ( Ahat + Ahat' );

        % test that Ahat is in fact PD. if it is not so, then tweak it just a bit.
        p = 1;
        k = 0;
        while p ~= 0
            [ cholAhat, p ] = chol( Ahat );
            k = k + 1;
            if p ~= 0
            % Ahat failed the chol test. It must have been just a hair off,
            % due to floating point trash, so it is simplest now just to
            % tweak by adding a tiny multiple of an identity matrix.
            EigAhat =  eig( Ahat );
            IScale = abs( min( EigAhat ) );
            IScale = IScale + eps( IScale );
            IScale = max( IScale, eps( max( EigAhat ) ) );
            Ahat = Ahat + ( IScale * k.^2 ) * eye( size( A ) );
            end
        end

    end

end

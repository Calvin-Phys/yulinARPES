function surfaceBasis = plotBZ_V1_primitive_surface_basis(bulkBasis, normal)
%PLOTBZ_V1_PRIMITIVE_SURFACE_BASIS Project the full bulk reciprocal lattice.
%   The three projected bulk generators obey one primitive integer relation.
%   An integer unimodular transform isolates that relation; its other two
%   columns generate every projected point, including high-index surfaces.
%   The result is reduced in 2-D for shorter, better conditioned vectors.

if ~isequal(size(bulkBasis), [3 3]) || ~all(isfinite(bulkBasis), 'all') || ...
        ~isequal(size(normal), [1 3]) || ~all(isfinite(normal)) || ...
        norm(normal) == 0
    error('plotBZ_V1:InvalidBasis', 'Bulk basis and surface normal must be finite and nonzero.');
end

% Express the selected normal in the primitive reciprocal basis. In the
% centered-cell GUI mode the coefficients may be rational, not integers.
coefficients = bulkBasis'\normal';
[numerators, denominators] = rat(coefficients, 1e-9);
commonDenominator = denominators(1);
for index = 2:3
    commonDenominator = lcm(commonDenominator, denominators(index));
end
relation = round(numerators.*(commonDenominator./denominators));
divisor = gcd(gcd(abs(relation(1)), abs(relation(2))), abs(relation(3)));
if divisor == 0
    error('plotBZ_V1:InvalidNormal', 'Surface Miller indices must not all be zero.');
end
relation = relation/divisor;
if norm(cross(normal, relation'*bulkBasis)) > ...
        1e-7*norm(normal)*norm(relation'*bulkBasis)
    error('plotBZ_V1:InvalidNormal', 'Surface normal is not a rational lattice direction.');
end

% Euclidean row operations map the primitive relation to the first unit
% vector. The remaining columns of inverseTransform are a quotient basis
% for Z^3 / <relation>, hence a primitive projected reciprocal basis.
[g12, x, y] = gcd(relation(1), relation(2));
if g12 == 0
    integerBasis = [1 0 0; 0 1 0];
else
    [g123, p, q] = gcd(g12, relation(3));
    if g123 ~= 1
        error('plotBZ_V1:InvalidNormal', 'Could not reduce the Miller direction.');
    end
    firstTransform = [x y 0; -relation(2)/g12 relation(1)/g12 0; 0 0 1];
    secondTransform = [p 0 q; 0 1 0; -relation(3) 0 g12];
    inverseTransform = round(inv(secondTransform*firstTransform));
    integerBasis = inverseTransform(:, 2:3)';
end

unitNormal = normal/norm(normal);
surfaceBasis = integerBasis*bulkBasis;
surfaceBasis = surfaceBasis - (surfaceBasis*unitNormal')*unitNormal;

% Gauss reduction preserves the integer span while shortening the vectors.
for iteration = 1:100
    if norm(surfaceBasis(2, :)) < norm(surfaceBasis(1, :))
        surfaceBasis = surfaceBasis([2 1], :);
    end
    projection = dot(surfaceBasis(1, :), surfaceBasis(2, :)) / ...
        dot(surfaceBasis(1, :), surfaceBasis(1, :));
    % At exactly 60 degrees, either sign is already reduced. Treating a
    % half-integer projection as another subtraction can oscillate.
    if abs(projection) <= 0.5 + 1e-12
        return;
    end
    multiple = round(projection);
    surfaceBasis(2, :) = surfaceBasis(2, :) - multiple*surfaceBasis(1, :);
end
error('plotBZ_V1:ReductionFailed', 'Surface basis reduction did not converge.');
end

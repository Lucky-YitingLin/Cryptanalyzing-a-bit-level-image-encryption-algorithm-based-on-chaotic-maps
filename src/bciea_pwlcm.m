function sequence = bciea_pwlcm(initialState, parameter, transient, count)
%BCIEA_PWLCM Generate a sequence from the piecewise linear chaotic map.
%
%   SEQUENCE = BCIEA_PWLCM(X0, ETA, TRANSIENT, COUNT) discards TRANSIENT
%   states and returns COUNT subsequent states of the PWLCM used by BCIEA.
%   ETA must lie in (0, 0.5), and X0 must lie in [0, 1).  The implementation
%   follows the symmetric third branch F(1 - x, ETA) from the cited paper.
%
%   This helper exposes the finite-precision reference model only.  It does
%   not claim that a floating-point chaotic sequence is cryptographically
%   secure.

validateattributes(initialState, {'numeric'}, {'scalar', 'real', 'finite'});
validateattributes(parameter, {'numeric'}, {'scalar', 'real', 'finite'});
validateattributes(transient, {'numeric'}, {'scalar', 'real', 'finite', 'nonnegative'});
validateattributes(count, {'numeric'}, {'scalar', 'real', 'finite', 'positive'});

if initialState < 0 || initialState >= 1
    error('bciea:InvalidPWLCMState', 'initialState must be in [0, 1).');
end
if parameter <= 0 || parameter >= 0.5
    error('bciea:InvalidPWLCMParameter', 'parameter must be in (0, 0.5).');
end
if transient ~= floor(transient) || count ~= floor(count)
    error('bciea:InvalidPWLCMLength', 'transient and count must be integers.');
end

state = double(initialState);
parameter = double(parameter);

% Advance to the first retained state without allocating a discarded vector.
for index = 1:double(transient)
    state = pwlcm_step(state, parameter);
end

sequence = zeros(1, double(count));
for index = 1:double(count)
    sequence(index) = state;
    state = pwlcm_step(state, parameter);
end

end

function nextState = pwlcm_step(state, parameter)
% Fold the upper half of the interval, then evaluate the two linear pieces.
if state >= 0.5
    state = 1 - state;
end

if state < parameter
    nextState = state / parameter;
else
    nextState = (state - parameter) / (0.5 - parameter);
end

% Exact endpoint hits are mapped back into the half-open state interval.
nextState = mod(nextState, 1);
end

function key = bciea_validate_key(key)
%BCIEA_VALIDATE_KEY Validate and normalize a corrected-BCIEA key structure.
%
%   KEY = BCIEA_VALIDATE_KEY(KEY) verifies the parameters used by the PWLCM
%   reference model.  It returns a normalized structure so callers can use
%   consistent double-valued map parameters and uint8 boundary bits.
%
%   Required fields are DIFFUSION_INITIAL, DIFFUSION_PARAMETER,
%   CONFUSION_INITIAL, CONFUSION_PARAMETER, TRANSIENT, and BOUNDARY_BITS.

if ~isstruct(key) || ~isscalar(key)
    error('bciea:InvalidKey', 'Key must be a scalar structure.');
end

requiredFields = {'diffusion_initial', 'diffusion_parameter', ...
    'confusion_initial', 'confusion_parameter', 'transient', 'boundary_bits'};
for index = 1:numel(requiredFields)
    if ~isfield(key, requiredFields{index})
        error('bciea:InvalidKey', 'Key is missing field "%s".', requiredFields{index});
    end
end

validate_unit_interval(key.diffusion_initial, 'diffusion_initial');
validate_open_half_interval(key.diffusion_parameter, 'diffusion_parameter');
validate_unit_interval(key.confusion_initial, 'confusion_initial');
validate_open_half_interval(key.confusion_parameter, 'confusion_parameter');

if ~isnumeric(key.transient) || ~isscalar(key.transient) || ...
        ~isfinite(key.transient) || key.transient < 0 || ...
        key.transient ~= floor(key.transient)
    error('bciea:InvalidKey', 'transient must be a non-negative integer.');
end

boundaryBits = key.boundary_bits;
if ~isnumeric(boundaryBits) && ~islogical(boundaryBits)
    error('bciea:InvalidKey', 'boundary_bits must contain binary numeric values.');
end
if numel(boundaryBits) ~= 2 || any(~isfinite(double(boundaryBits(:)))) || ...
        any(boundaryBits(:) ~= 0 & boundaryBits(:) ~= 1)
    error('bciea:InvalidKey', 'boundary_bits must be a two-element binary vector.');
end

key.diffusion_initial = double(key.diffusion_initial);
key.diffusion_parameter = double(key.diffusion_parameter);
key.confusion_initial = double(key.confusion_initial);
key.confusion_parameter = double(key.confusion_parameter);
key.transient = double(key.transient);
key.boundary_bits = uint8(reshape(boundaryBits, 1, 2));

end

function validate_unit_interval(value, name)
% The state starts strictly inside the PWLCM state interval.
if ~isnumeric(value) || ~isscalar(value) || ~isfinite(value) || value <= 0 || value >= 1
    error('bciea:InvalidKey', '%s must be a finite value in (0, 1).', name);
end
end

function validate_open_half_interval(value, name)
% The PWLCM control parameter is defined on the open interval (0, 0.5).
if ~isnumeric(value) || ~isscalar(value) || ~isfinite(value) || value <= 0 || value >= 0.5
    error('bciea:InvalidKey', '%s must be a finite value in (0, 0.5).', name);
end
end

function key = bciea_default_key()
%BCIEA_DEFAULT_KEY Return deterministic parameters for demonstrations and tests.
%
%   KEY = BCIEA_DEFAULT_KEY() returns a complete key structure accepted by
%   BCIEA_ENCRYPT and BCIEA_DECRYPT.  The values are intentionally public
%   demonstration values; they are not cryptographically secure keys.
%
%   The original BCIEA diffusion equations feed the last bit back into the
%   first equation, which makes the inverse non-unique.  The accompanying
%   paper studies the corrected form.  BOUNDARY_BITS = [0 0] represents that
%   correction by removing both wraparound terms.  Set it explicitly to a
%   different binary pair only when reproducing a historical variant.

key.diffusion_initial = 0.123456789;
key.diffusion_parameter = 0.312345679;
key.confusion_initial = 0.271828183;
key.confusion_parameter = 0.357142857;
key.transient = 100;
key.boundary_bits = uint8([0 0]);

end

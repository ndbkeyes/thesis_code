function out = mod_1n(in,base)
%
% FUNCTION: mod_1n(in,base)
%
% PURPOSE: version of usual mod function but that returns in the range 
% 1 to n, not 0 to n-1
%
% INPUT: 
% - in: value to be modded
% - base: mod base to be used
%
% OUTPUT: in (mod base), ranging from 1 to n
%

    out = mod(in,base);
    if out == 0
        out = base;
    end
    
end
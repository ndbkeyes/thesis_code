function out = mod_1n(in,base)

    out = mod(in,base);
    if out == 0
        out = base;
    end
    
end
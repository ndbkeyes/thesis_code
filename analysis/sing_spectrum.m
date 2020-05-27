
function [alpha_arr, D_arr] = sing_spectrum(q_arr, h_arr)

    tau_arr = q_arr .* h_arr - 1;
    alpha_arr = diff(tau_arr) ./ diff(q_arr);
    D_arr = q_arr(1:end-1) .* alpha_arr - tau_arr(1:end-1);

end
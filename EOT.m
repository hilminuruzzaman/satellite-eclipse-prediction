function t_diff=EOT(T)
    B=T-2.451544500000000e+06;
    cyc=mod(4*B,1461);
    Theta = cyc * 0.004301;
    EoT1 = 7.353 * sin(1 * Theta + 6.209);
    EoT2 = 9.927 * sin(2 * Theta + 0.37);
    EoT3 = 0.337 * sin(3 * Theta + 0.304);
    EoT4 = 0.232 * sin(4 * Theta + 0.715);
    t_diff =-(0.019 + EoT1 + EoT2 + EoT3 + EoT4);
end
%{
diambil dari
https://equation-of-time.info/calculating-the-equation-of-time
%}
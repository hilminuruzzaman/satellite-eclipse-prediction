function [r_sun,lambda_ecl,M]=SunMotion(t)
T_tdb=(t-2451545)/36525;
lambda_M=mod(deg2rad(280.46+36000.771*T_tdb),2*pi);
M=deg2rad(357.5291092+35999.05*T_tdb);
lambda_ecl=deg2rad(lambda_M+1.914666471*sin(M)+0.019994643*sin(2*M));
eps=deg2rad(23.43921-0.0130042*T_tdb-1.64e-7*T_tdb^2+5.04e-7*T_tdb^3);
r=1.000140612-0.016708617*cos(M)-0.000139589*cos(2*M);
r_sun=[r*cos(lambda_ecl);
    r*cos(eps)*sin(lambda_ecl);
    r*sin(eps)*sin(lambda_ecl)];
r_sun=r_sun*149597870.7;

end
function r=el2eq(req,t)
T_tdb=(t-2451545)/36525;
eps=deg2rad(23.43921-0.0130042*T_tdb-1.64e-7*T_tdb^2+5.04e-7*T_tdb^3);
el2eq=inv([1 0 0;0 cos(eps) sin(eps);0 -sin(eps) cos(eps)]);
r=el2eq*req;
end
function [r_Ea,v_Ea]=EarthMotion(t)
T_tdb=(t-2451545)/36525;
sma=149598023;
ecc=0.016708617-0.000042037*T_tdb-0.0000001236*T_tdb^2+0.000000000004*T_tdb^3;

%ref eclipdate(?)
inc=0;
node=0;
aop=deg2rad(102.93734808+1.7195269*T_tdb+0.00045962*T_tdb^2+0.000000021*T_tdb^3);

%ref J2000 harusnya
%inc=rad2deg(3.394662-0.0008568*T_tdb-0.00003244*T_tdb^2+0.00000001*T_tdb^3);
%node=rad2deg(174.873174-0.2410908*T_tdb+0.00004067*T_tdb^2-0.000001327*T_tdb^3);
%aop=deg2rad(102.93734808+0.3225557*T_tdb+0.00015026*T_tdb^2+0.0000000*T_tdb^3);
mu_sun=1.327e11;

T_Ea=2*pi*sqrt(sma^3/mu_sun);
M_Ea=mod(2*pi/T_Ea*(t-2459949.1784722)*86400,2*pi);
if M_Ea>pi
    E_Ea=M_Ea-ecc;
else
    E_Ea=M_Ea+ecc;
end
E2=0;
diff=1e-6;
while abs(E2-E_Ea)>diff
    E2=E_Ea;
    E_Ea=E_Ea+(M_Ea-E_Ea+ecc*sin(E_Ea))/(1-ecc*cos(E_Ea));
end
if E_Ea<pi
    f_Ea=acos((cos(E_Ea)-ecc)/(1-ecc*cos(E_Ea)));
else
    f_Ea=2*pi-acos((cos(E_Ea)-ecc)/(1-ecc*cos(E_Ea)));
end
p_Ea=sma*(1-ecc^2);

r_Ea=[p_Ea*cos(f_Ea)/(1+ecc*cos(f_Ea));p_Ea*sin(f_Ea)/(1+ecc*cos(f_Ea));0];
v_Ea=[-sqrt(mu_sun/p_Ea)*sin(f_Ea);sqrt(mu_sun/p_Ea)*(ecc+cos(f_Ea));0];
TRF_Ea=[cos(node)*cos(aop)-sin(node)*sin(aop)*cos(inc) -cos(node)*sin(aop)-sin(node)*cos(aop)*cos(inc) sin(node)*sin(inc);
    sin(node)*cos(aop)+cos(node)*sin(aop)*cos(inc) -sin(node)*sin(aop)+cos(node)*cos(aop)*cos(inc) -cos(node)*sin(inc);
    sin(aop)*sin(inc) cos(aop)*sin(inc) cos(inc)];
r_Ea=TRF_Ea*r_Ea;
v_Ea=TRF_Ea*v_Ea;
end
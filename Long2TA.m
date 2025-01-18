function [TA]=Long2TA(sma,ecc,inc,node,aop,Long,Epoch,EpochCheck)

mu=3.986e5;

R=-EarthMotion(Epoch);
R_eq=el2eq(R,Epoch);
[~,~,RA]=State2Eq(R_eq);
% itung HA matahari
HA=2*pi*(mod(Epoch,1)+EOT(Epoch)/1440);
% itung HA titik gamma
HA_aries=RA+HA;
% dapet nilai lambda asli 
long_eq=Long+HA_aries;
a=long_eq-node;
b=atan(tan(a)/cos(inc));
if cos(a)<0
    b=b+pi;
end
f=mod(b-aop,2*pi);
r_orbit=sma*(1-ecc^2)/(1+ecc*cos(f));
E_epoch=acos((1-r_orbit/sma)/ecc);
if mod(f,2*pi)>pi
    E_epoch=-E_epoch;
end
E_epoch=mod(E_epoch,2*pi);
M_epoch=E_epoch-ecc*sin(E_epoch);

T=2*pi*sqrt(sma^3/mu);
dt=M_epoch*T/(2*pi);
t_periapsis=Epoch-dt/86400;

MeanAnom=mod(2*pi/T*(EpochCheck-t_periapsis)*86400,2*pi);
if MeanAnom>pi
    E=MeanAnom-ecc;
else
    E=MeanAnom+ecc;
end
E2=0;
diff=1e-6;
while abs(E2-E)>diff
    E2=E;
    E=E+(MeanAnom-E+ecc*sin(E))/(1-ecc*cos(E));
end
if E<pi
    TA=acos((cos(E)-ecc)/(1-ecc*cos(E)));
else
    TA=2*pi-acos((cos(E)-ecc)/(1-ecc*cos(E)));
end
end
function [r,v]=Keplerian2State(sma,ecc,inc,node,aop,TA)
mu=3.986004415e5;
if ecc~=1
    p=sma*(1-ecc^2);
else
    p=2*sma;
end
r_orb=[p*cos(TA)/(1+ecc*cos(TA));p*sin(TA)/(1+ecc*cos(TA));0];
v_orb=[-sqrt(mu/p)*sin(TA);sqrt(mu/p)*(ecc+cos(TA));0];

TRF=[cos(node)*cos(aop)-sin(node)*sin(aop)*cos(inc) -cos(node)*sin(aop)-sin(node)*cos(aop)*cos(inc) sin(node)*sin(inc);
    sin(node)*cos(aop)+cos(node)*sin(aop)*cos(inc) -sin(node)*sin(aop)+cos(node)*cos(aop)*cos(inc) -cos(node)*sin(inc);
    sin(aop)*sin(inc) cos(aop)*sin(inc) cos(inc)];

r=TRF*r_orb;
v=TRF*v_orb;
end
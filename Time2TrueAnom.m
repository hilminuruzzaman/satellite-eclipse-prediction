function f=Time2TrueAnom(t_periapsis,t,sma,ecc)

step=10000;
mu=3.986e5;
t_periapsis=t_periapsis*86400;
t=t*86400;
t=t_periapsis:(t-t_periapsis)/step:t;
if ecc==1
    p=2*sma;
else
    p=sma*(1-ecc^2);
end
C=sqrt((p)^3/mu);
f=0;

for i=1:length(t)
v=(1+ecc*cos(f))^2*C^-1;
f=f+v*(t(length(t))-t_periapsis)/step;
f=f;
end
if ecc>=1
    if abs((t(length(t))-t_periapsis))/step>10000
        if t_periapsis<t(length(t))
            f=pi/2+asin(1/ecc);
        else
            f=2*pi-pi/2-asin(1/ecc);
        end
    end
end
f=mod(f,2*pi);
end
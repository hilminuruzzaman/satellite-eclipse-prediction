function [sma,ecc,inc,node,aop,TA]=TLE2Keplerian(line_0,line_1,line_2,EpochCheck)
if str2double(line_1(19:20))~=23
error('TLE 2023 bang, kalo gamau ganti sendiri fungsinya')
end
name=line_0;
Epoch_year=2023;
Epoch_day=str2double(line_1(21:32));
Epoch_JD=2451545+ceil((Epoch_year-2000)*365.25)+Epoch_day-1.5;
inc=deg2rad(str2double(line_2(9:16)));
node=deg2rad(str2double(line_2(18:25)));
ecc=str2double(line_2(27:33))*1e-7;
aop=deg2rad(str2double(line_2(35:42))); 
MeanAnom=deg2rad(str2double(line_2(44:51)));
T=1/str2double(line_2(53:63))*86400;
mu=3.986e5;
sma=(mu/(4*pi^2)*T^2)^(1/3);

dt=MeanAnom*T/(2*pi);
t_periapsis=Epoch_JD-dt/86400;
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
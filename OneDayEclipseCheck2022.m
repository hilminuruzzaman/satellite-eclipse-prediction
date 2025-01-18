function [EclipseTable,Fraction,EclipseTableMoon,FractionMoon]=OneDayEclipseCheck2022(REarthSat,VEarthSat,EpochCheck,dur)

T=readtable("MoonElement2022.csv",VariableNamingRule="modify");

t0=EpochCheck;
t1=EpochCheck+dur; %ganti angka buat range ngitung
step=(t1-t0)*86400/1; %ganti yg di kanan buat stepnya
t=t0:(t1-t0)/step:t1;

mu_sun=1.32712428e11;
mu_earth=3.986004415e5;
mu_moon=4902.779;

%transformasi ke ekliptik
REarthSat=eq2el(REarthSat,t0);
VEarthSat=eq2el(VEarthSat,t0);

j=0;k=0;
for i=1:length(t)
[r_Ea]=EarthMotion(t(i));
r_moon=MoonMotion2022(t(i),T);
RMoonSat=REarthSat-r_moon;
RSunSat=EarthMotion(t(i))+REarthSat;
a=-mu_earth/(norm(REarthSat)^3)*REarthSat+mu_sun*(-RSunSat/(norm(RSunSat)^3)+r_Ea/(norm(r_Ea)^3))+mu_moon*(-RMoonSat/(norm(RMoonSat)^3)-r_moon/(norm(r_moon)^3));
v=VEarthSat+a*(t1-t0)/step*86400;
r2=REarthSat+v*(t1-t0)/step*86400;
REarthSat=r2;
VEarthSat=v;
%% Eclipse or no
Elong=acos(dot((r_Ea+REarthSat),REarthSat)/(norm(r_Ea+REarthSat)*norm(REarthSat)));
ElongMoon=acos(dot((r_Ea+REarthSat),RMoonSat)/(norm(r_Ea+REarthSat)*norm(RMoonSat)));
RSun=6.955e5;REarth=6378;RMoon=1740;
angle_sun=asin(RSun/norm(r_Ea+REarthSat)); angle_earth=asin(REarth/norm(REarthSat));angle_moon=asin(RMoon/norm(RMoonSat));


if Elong<angle_sun+angle_earth
    j=j+1;
    if Elong<abs(angle_earth-angle_sun)
    stat=1;
    else
    stat=0.5;
    end
    EclipseTable(j,:)=[t(i),Elong,stat];
    Area(j,:)=angle_sun^2*acos((Elong^2+angle_sun^2-angle_earth^2)/(2*Elong*angle_sun))+angle_earth^2*acos((Elong^2+angle_earth^2-angle_sun^2)/(2*Elong*angle_earth))-0.5*sqrt((-Elong+angle_sun+angle_earth)*(Elong+angle_sun-angle_earth)*(Elong-angle_sun+angle_earth)*(Elong+angle_sun+angle_earth));
    Fraction(j,:)=real(Area(j,:)/(pi*angle_sun^2));
end
EclipseTable(j+1,:)=[0,0,0];
Fraction(j+1,:)=0;

if ElongMoon<angle_sun+angle_moon
    k=k+1;
    if ElongMoon<abs(angle_moon-angle_sun)
    statmoon=1;
    else
    statmoon=0.5;
    end
    EclipseTableMoon(k,:)=[t(i),ElongMoon,statmoon];
    AreaMoon(k,:)=angle_sun^2*acos((ElongMoon^2+angle_sun^2-angle_moon^2)/(2*ElongMoon*angle_sun))+angle_moon^2*acos((ElongMoon^2+angle_moon^2-angle_sun^2)/(2*ElongMoon*angle_moon))-0.5*sqrt((-ElongMoon+angle_sun+angle_moon)*(ElongMoon+angle_sun-angle_moon)*(ElongMoon-angle_sun+angle_moon)*(ElongMoon+angle_sun+angle_moon));
    FractionMoon(k,:)=real(AreaMoon(k,:)/(pi*angle_sun^2));
end
EclipseTable(j+1,:)=[0,0,0];
Fraction(j+1,:)=0;
EclipseTableMoon(k+1,:)=[0,0,0];
FractionMoon(k+1,:)=0;


end
end
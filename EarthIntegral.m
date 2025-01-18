function [r_Ea,v_Ea]=EarthIntegral(t)
Epoch_2023=2459945.5;
r_2023=[-2.348957434911753e+07;1.452160975289603e+08;0];
v_2023=[-29.890301867100927;-4.867901420766533;0];
r_EaSun=r_2023;
v_EaSun=v_2023;


step=(t-Epoch_2023)*86400;
t_tot=Epoch_2023:(t-Epoch_2023)/step:t;

mu_sun=1.327e11;

for i=1:length(t_tot)
a=-mu_sun/(norm(r_EaSun)^3)*r_EaSun;
v=v_EaSun+a*(t-Epoch_2023)/step*86400;
r2=r_EaSun+v*(t-Epoch_2023)/step*86400;
r_EaSun=r2;
v_EaSun=v;
end

r_Ea=r_EaSun; v_Ea=v_EaSun;

end
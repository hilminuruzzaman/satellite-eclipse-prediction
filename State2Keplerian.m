function [p,sma,ecc,inc,node,aop,TA]=State2Keplerian(r,v)
mu=3.986004415e5;
h=cross(r,v);
n=cross([0;0;1],h);
e=((norm(v)^2-mu/norm(r))*r-(dot(r,v)*v))/mu;
ecc=norm(e);
xi=norm(v)^2/2-mu/norm(r);
if ecc~=1
    sma=-mu/(2*xi);
    p=sma*(1-ecc^2);
else
    p=norm(h)^2/mu;
    sma=inf;
end
inc=acos(h(3,1)/norm(h));
node=acos(n(1,1)/norm(n));
if n(2,1)<0
    node=2*pi-node;
end
aop=acos(dot(n,e)/(norm(n)*norm(e)));
if e(3,1)<0
    aop=2*pi-aop;
end
TA=acos(dot(e,r)/(norm(e)*norm(r)));
if dot(r,v)<0
    TA=2*pi-TA;
end

end
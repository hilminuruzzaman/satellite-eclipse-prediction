function [r,b,l]=State2Eq(R)
    r=norm(R);
    b=asin(R(3,:)/r);
    l=atan(R(2,:)/R(1,:));
    if R(1,:)/(r*cos(b))<0
        l=pi+l;
    end
    l=mod(l,2*pi);
end
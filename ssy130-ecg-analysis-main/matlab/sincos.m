function x = sincos(p,m)

f = 50/500;

if p==0
    x = cos(2*pi*m*f);
else
    x = sin(2*pi*m*f);
end
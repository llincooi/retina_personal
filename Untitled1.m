clear all;
close all;
syms a 'positive'
syms b 'positive'
syms c 'positive'
syms g 'positive'
syms l 'positive'
syms A 'positive'
syms tau 'positive'
syms t 'real'
assume(t>=0)
syms w  'real'



H = A*(1j*w+b)/ ((1j*w+a)*(1j*w+b)+g);
pretty(real(H))
Kt = ifourier(H, t);
% 
w0 = sqrt(4*g-(a-b)^2)/2;
d0 = atan( (a-b)/sqrt(4*g-(a-b)^2) );
B = A*sqrt( 4*g/(4*g-(a-b)^2) );
Kt2 = B*exp(-t*(a+b)/2)*cos(w0*t+d0);

someKt2 = subs(Kt2, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt2), [0 ,1]); hold on;

someKt = subs(Kt, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt), [0 ,1]); hold on;

assume(t>=0);
syms x(t)
x(t) = dirac(t);
syms y(t)
syms z(t)
syms w(t)
[y, z] = dsolve(diff(y,t) == -a*y+A*x-z, diff(z,t) == -b*z+g*y, y(0) == 0, z(0) == 0);
somey = subs(y, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
fplot(somey, [0 ,1]); hold on;
isAlways(t>0)
pretty(simplify(y))
pretty(simplify(somey))

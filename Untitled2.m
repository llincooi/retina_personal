clear all;
close all;
syms a 'positive'
syms b 'positive'
syms c 'positive'
syms g 'positive'
syms l 'positive'
syms A 'positive'
syms tau 'positive'
syms t 'positive'
syms w  'real'



H = A*g / ((1j*w+a)*(1j*w+b)+g);
Kt = ifourier(H, t);

% 
w0 = sqrt(4*g-(a-b)^2)/2;
Kt2 = A*g/w0*exp(-t*(a+b)/2)*sin(w0*t);

someKt2 = subs(Kt2, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt2), [0 ,1]); hold on;

someKt = subs(Kt, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt), [0 ,1]); hold on;


syms x(t)
x(t) = dirac(t-1);
syms y(t)
syms z(t)
syms w(t)
[y, z] = dsolve(diff(y,t) == -a*y+A*x-z, diff(z,t) == -b*z+g*y, y(0) == 0, z(0) == 0);
y = subs(y, t, t+1);
pretty(real(simplify(y)))
z = subs(z, t, t+1);
pretty(real(simplify(z)))

somez = subs(z, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
fplot(somez, [0 ,1]); hold on;
% isAlways(t>0)
% pretty(simplify(y))
% pretty(simplify(somey))

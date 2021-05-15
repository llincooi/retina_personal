clear all;
close all;
syms a 'positive'
syms b 'positive'
syms c 'positive'
syms g 'positive'
syms l 'positive'
syms A 'positive'
syms tau 'positive'
syms m n 'positive'
syms t 'positive'
syms w  'real'

syms x(t)
x(t) = dirac(t-1);
syms y(t)
syms z(t)
syms w(t)
% [y, z] = dsolve(diff(y,t) == -a*y+x-z, diff(z,t) == -b*z+g*y, y(0) == 0, z(0) == 0);
% w = dsolve(diff(w,t) == -c*w + y - l*z, w(0)==0 );
[w, y, z] = dsolve(diff(y,t) == -a*y+x-z, diff(z,t) == -b*z+g*y, diff(w,t) == -c*w +y-l*z, y(0) == 0, z(0) == 0, w(0) == 0);
y = subs(y, t, t+1);
z = subs(z, t, t+1);
w = subs(w, t, t+1);
% pretty(real(simplify(y)))
% pretty(real(simplify(z)))
pretty(real(simplify(w)))
% D = A*(b-c+g*l)/(g+a*b-a*c-b*c+c^2);
% w = w+D*exp(-c*t);

% somey = subs(y, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.001, 200});
% fplot(somey, [0 ,1]); hold on;
% somez = subs(z, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.001, 200});
% fplot(somez, [0 ,1]); hold on;
somew = subs(w, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.001, 200});
fplot(somew, [0 ,1]); hold on;

syms x(t)
x(t) = dirac(t-1);
syms y(t)
syms z(t)
syms w(t)
[y, z] = dsolve(diff(y,t) == -a*y+x-z, diff(z,t) == -b*z+g*y, y(0) == 0, z(0) == 0);
w = dsolve(diff(w,t) == -c*w + y - l*z, w(0)==0);
y = subs(y, t, t+1);
z = subs(z, t, t+1);
w = subs(w, t, t+1);
% pretty(real(simplify(y)))
% pretty(real(simplify(z)))
pretty(real(simplify(w)))
% D = A*(b-c+g*l)/(g+a*b-a*c-b*c+c^2);
% w = w+D*exp(-c*t);

% somey = subs(y, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.001, 200});
% fplot(somey, [0 ,1]); hold on;
% somez = subs(z, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.001, 200});
% fplot(somez, [0 ,1]); hold on;
somew = subs(w, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.001, 200});
fplot(somew, [0 ,1]); hold on;
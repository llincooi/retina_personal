clear all;
close all;
syms a 'positive'
syms b 'positive'
syms c 'positive'
syms g 'positive'
syms l 'positive'
syms m 'positive'
syms tau tau_x 'positive'
syms t 'real'
assume(t>=0)
syms w  'real'
syms lambda


%From the recursive?differential?equation.
syms n h 'positive'
syms t 'positive'
syms w  'real'
syms x(t)
x(t) = t/tau_x^2*exp(-t/tau_x)
syms y(t)
syms z(t)
syms w(t)
[w, y, z] = dsolve(diff(y,t) == -a*y+m*x-n*z, diff(z,t) == -b*z+g*y, diff(w,t) == -c*w +h*y-l*z, y(0) == 0, z(0) == 0, w(0) == 0);
pretty(real(simplify(w)))
somew = subs(w, {a, b, c, g, l, m, n, h, tau_x}, {10. ,10., 40., 900., 0.01, 200, 1, 1, 0.03});
fplot(somew, [0,1]); hold on;
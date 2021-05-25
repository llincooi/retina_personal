clear all;
close all;
syms a 'positive'
syms b 'positive'
syms c 'positive'
syms g 'positive'
syms l 'positive'
syms m 'positive'
syms tau 'positive'
syms t 'real'
assume(t>=0)
syms w  'real'
syms lambda

% From Transfer Function
H = m*(1j*w+b-g*l)/ (((1j*w+a)*(1j*w+b)+g)*(1j*w+c));
lambda = tan(angle(H))/(1+tan(angle(H)));
pretty(simplify(lambda))
Kt = ifourier(H, t);
someKt = subs(Kt, {a, b, c, g, l, m}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt), [0 ,1]); hold on;
%From both transfer function (H) and the recursive?differential?equation.
syms n h 'positive'
syms t 'positive'
syms w  'real'
syms x(t)
x(t) = dirac(t-1);
syms y(t)
syms z(t)
syms w(t)
[w, y, z] = dsolve(diff(y,t) == -a*y+m*x-n*z, diff(z,t) == -b*z+g*y, diff(w,t) == -c*w +h*y-l*z, y(0) == 0, z(0) == 0, w(0) == 0);
y = subs(y, t, t+1);
z = subs(z, t, t+1);
w = subs(w, t, t+1);
pretty(real(simplify(w)))
somew = subs(w, {a, b, c, g, l, m, n, h}, {10. ,10., 40., 900., 0.01, 200, 1, 1});
fplot(somew, [0,1]); hold on;
% The Analytic solution
w0 = sqrt(4*g-(a-b)^2)/2;
d0 = atan( (b^2-2*g-a*b+a*c-b*c-a*g*l-b*g*l+2*c*g*l)/(sqrt(4*g-(a-b)^2)*(-b+c+g*l)) );
B = m*sqrt( 4*g*(-b*l+a*l+g*l^2+1)/((4*g-(a-b)^2)*(g+a*b-a*c-b*c+c^2)) );
D = m*(b-c-g*l)/(g+a*b-a*c-b*c+c^2);
Kt2 = B*exp(-t*(a+b)/2)*cos(w0*t+d0) + D*exp(-c*t);
someKt2 = subs(Kt2, {a, b, c, g, l, m}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt2), [0 ,1]); hold on;




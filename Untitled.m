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
syms lambda


H = A*(1j*w+b-g*l)/ (((1j*w+a)*(1j*w+b)+g)*(1j*w+c));
lambda = tan(angle(H))/(1+tan(angle(H)));
pretty(simplify(lambda))
% H = A*(1j*w+b)/ ((1j*w+a)*(1j*w+b)+g);
Kt = ifourier(H, t);
% 
w0 = sqrt(4*g-(a-b)^2)/2;
d0 = atan( (b^2-2*g-a*b+a*c-b*c-a*g*l-b*g*l+2*c*g*l)/(sqrt(4*g-(a-b)^2)*(-b+c+g*l)) );
B = A*sqrt( 4*g*(-b*l+a*l+g*l^2+1)/((4*g-(a-b)^2)*(g+a*b-a*c-b*c+c^2)) );
D = A*(b-c-g*l)/(g+a*b-a*c-b*c+c^2);
Kt2 = B*exp(-t*(a+b)/2)*cos(w0*t+d0) + D*exp(-c*t);

someKt2 = subs(Kt2, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt2), [0 ,1]); hold on;

someKt = subs(Kt, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
ezplot(real(someKt), [0 ,1]); hold on;

% 
% syms x(t)
% x(t) = dirac(t-1E-10);
% syms y(t)
% syms z(t)
% syms w(t)
% [y, z] = dsolve(diff(y,t) == -a*y+A*x-z, diff(z,t) == -b*z+g*y, y(0) == 0, z(0) == 0);
% w = dsolve(diff(w,t) == -c*w+y-l*z, w(0)==0 );
% w = w+D*exp(-c*t);
% pretty(simplify(w))
% somew = subs(w, {a, b, c, g, l, A}, {10. ,10., 40., 900., 0.01, 200});
% % pretty(somey)
% ezplot(somew, [0 ,1]); hold on;


% 
% 
% assume(4*g >= (a-b)^2);
% isAlways(Kt == Kt2)
% Kt2 = B*(exp(-t/tau0)*cos(w0*t+d0)) -D*exp(-2c*t);



% someKt = subs(Kt, {a, b, c, g, l, A}, {14. ,14., 36., 840., 0.01, 100});
% pretty(simplify(real(someKt)))
% pretty(simplify(imag(someKt)))


% pretty(iffH)
% syms t2
% covKt(t) = int(Kt(t2)*Ks(t-t2),t2, -inf, inf)
% 
% 
% ezplot(someKt, [0 ,1])

% Dc= (sqrt(4*g-(a-b)^2)*(-b+c-g*l));
% Ds= (b^2-2*g-a*b+a*c-b*c+a*g*l+b*g*l-2*c*g*l);
% pretty(simplify(sqrt(Ds^2+Dc^2)))
% pretty(simplify(Ds/Dc))
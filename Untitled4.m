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
syms w0 B tau0 'positive'
syms d0 D 'real'
syms E F G H 'real'
assume(4*g-(a-b)^2>=0)

% [a, b, c, g, l, A] = solve([tau0 == (a+b)/2, w0 == sqrt(4*g-(a-b)^2)/2,...
%              d0 == atan( (b^2-2*g-a*b+a*c-b*c-a*g*l-b*g*l+2*c*g*l)/(sqrt(4*g-(a-b)^2)*(-b+c+g*l)) ),...
%              B == A*sqrt( 4*g*(-b*l+a*l+g*l^2+1)/((4*g-(a-b)^2)*(g+a*b-a*c-b*c+c^2)) ),...
%              D == A*(b-c-g*l)/(g+a*b-a*c-b*c+c^2)], [a, b, c, g, l, A])

         
[a, b, g, l] = solve([E*H == g*(-b*l+a*l+g*l^2+1)*(g+a*b-a*c-b*c+c^2)/(b-c-g*l)^2,...
                            F == (b^2-2*g-a*b+a*c-b*c-a*g*l-b*g*l+2*c*g*l)/(-b+c+g*l),...
                            G == a+b,...
                            H == (4*g-(a-b)^2),...
                            c == c], [a, b, g, l])
         
         

% Kt2 = B*exp(-t*(a+b)/2)*cos(w0*t+d0) + D*exp(-c*t);
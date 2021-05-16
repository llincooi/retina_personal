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
assume(4*g-(a-b)^2>=0);

[a, b, g, l] = solve([tau0 == (a+b)/2,...
                   w0 == sqrt(4*g-(a-b)^2)/2,...
                   d0 == atan( (a-b)/sqrt(4*g-(a-b)^2) ),...
                   B == sqrt( 4*g/(4*g-(a-b)^2) )], [a, b, g, l])


clear all;
close all;
syms t 'positive'
syms w  'real'
syms y(t)
syms tau

G = fourier(1/y(t))


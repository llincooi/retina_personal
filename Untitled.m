syms a b c g l A w 'real'
% simplify( A*(1j*w+b+g*l)/(1j*w+c)() )

ReH = simplify( real(A*(1j*w+b)/((1j*w+a)*(1j*w+b)+g)) );
ImH = simplify( imag(A*(1j*w+b)/((1j*w+a)*(1j*w+b)+g)) );

AngH = simplify( atan(ImH/ReH) );
Delta = simplify( diff(atan(AngH), w) )


ezplot(Delta, w)
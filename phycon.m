%kappa = konstanta Boltzman (J/K)

e = 1.6022e-19;
kappa = 1.3807e-23;
%kappa = 8.617e-5; %eV/K.  <--saran grok

%{
grok:
kappa = 1.3807e-23 (<math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mtext>J/K</mtext></mrow><annotation encoding="application/x-tex">\text{J/K}</annotation></semantics></math>) is for SI units, correct for your temperature conversions.
kappa = 8.617e-5 (<math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mtext>eV/K</mtext></mrow><annotation encoding="application/x-tex">\text{eV/K}</annotation></semantics></math>) is for <math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mtext>eV</mtext></mrow><annotation encoding="application/x-tex">\text{eV}</annotation></semantics></math>-based calculations, but wrong for X.
Use kappa = 1.380649e-23 and fix n0 to resolve NaN.
%}

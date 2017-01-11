function result = kb(y,Z)
% PURPOSE: computes Koenker-Bassett Test for Heteroskedasticity
% LM = [1/V](u-ubari)'Z(Z'Z)^(-1)Z'(u-ubari), V=(1/n)sum[e^2 - (e'e)/n]^2
% Follows chi-squared distribution with k-1 degrees of freedom
% ---------------------------------------------------
%  USAGE: results = kb(y,Z)
%  where:  y = dependent variable vector
%          Z = explanatory variable vectors
%          
% --------------------------------------------------
%  NOTES: Requires Jim LeSage's toolbox from www.spatial-econometrics.com
% --------------------------------------------------  
%  SEE ALSO: ols, bpagan
% ---------------------------------------------------
% REFERENCES: From Greene (2000, 4th ed.), p. 510
% Koenker, R. "A Note on Studentizing a Test for Heteroscedasticity."
% Journal of Econometrics, 17, 1981, pp. 107-112.
% Koenker, R. and G. Bassett. "Robust Tests for Heteroscedasticity Based on
% Regression Quantiles." Econometrica, 50, 1982, pp. 43-61.
% ---------------------------------------------------
%
% written by:
% Justin M. Ross
% SPEA
% Indiana University
% Bloomington, IN 47405
% justross@indiana.edu

if nargout == 0
prt = 1;
elseif nargout == 1
prt = 0;
elseif nargin ~= 2
error('Wrong # of arguments to bpagan');
end;

[n, k] = size(Z);
ii=ones(n,1);

res1=ols(y,[ii Z]);

e=res1.resid;
u=e.*e;
ubar=(e'*e)/n;
V=0;
for i=1:n;
    V = V+(u(i,1) - ubar)^2;
end;
V=V/n;
Vinv=1/V;
Zinv=inv(Z'*Z);
diff=(u-ubar*ii);
LM=Vinv*diff'*Z*Zinv*Z'*diff;
dof = k-1;

if prt == 0
result.meth = 'kb';
result.dof = k-1;
result.lm = LM;
result.prob = 1-chis_prb(LM,k-1);
else
fprintf(1,'Koenker-Bassett LM-statistic = %16.8f \n',LM);
fprintf(1,'Chi-squared probability   = %16.4f \n',1-chis_prb(LM,k-1));
fprintf(1,'Degrees of freedom        = %16d   \n',dof);
end;




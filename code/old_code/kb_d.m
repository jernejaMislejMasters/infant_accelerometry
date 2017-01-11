clear all;
X=randn(100,3);
E=randn(100,1);
const=ones(100,1);
for i=1:100;
    Y(i,1)=1.5 + 2*X(i,1) + 2*X(i,2) + 2.5*X(i,3) + E(i,1);
end;

Z=X;

results=kb(Y,Z);




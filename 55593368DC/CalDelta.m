function delta=CalDelta(Bus,Y,P)
%����delta   Y*delta=P
global Bus Y P;

[nb,mb]=size(Bus);
delta=zeros(17,1);
delta=delta+inv(Y)*P;



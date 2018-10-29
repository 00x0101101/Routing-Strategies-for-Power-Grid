function P=FormP(Bus,Load,Generator)
%形成节点功率向量
global  Bus Load Generator;

[nb,mb]=size(Bus);
[nd,md]=size(Load);
[ng,mg]=size(Generator);
P=zeros(nb-1,1);
for i=1:nb
    ID=Bus(i,1);
    CKT=Bus(i,3);
    if CKT<3
       for j=1:nd
           if Load(j,1)==ID
              P(ID)=P(ID)-Load(j,2);
           end
       end
       for k=1:ng
           if Generator(k,1)==ID
              P(ID)=P(ID)+Generator(k,2);
           end
       end
    end
end

P=P/100;
    


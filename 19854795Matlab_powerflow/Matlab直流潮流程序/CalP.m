function PIJ=CalP(Bus,Line)
%������·����PIJ=Delta(i)-Delta(j)/x
global Bus Line delta;

[nl,ml]=size(Line);

for i=1:nl
    I=Line(i,1);
    J=Line(i,2);
    X=Line(i,4);
    %ƽ��ڵ�ǶȵĴ���
    if Bus(I,3)==3
       delta(I)=0;
    elseif Bus(J,3)==3
       delta(J)=0;
    end
    
    PIJ(i)=(delta(I)-delta(J))/X;
end

        
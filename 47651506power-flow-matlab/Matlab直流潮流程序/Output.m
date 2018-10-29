function Output(bus,line,delta,myf,PIJ,Y)
%输出导纳矩阵、节点相角、线路潮流
global myf bus line delta PIJ  Y;

[nb,mb]=size(bus);
[nl,ml]=size(line);
%导纳矩阵
fprintf(myf,'-------------导纳矩阵----------\n',1);
for i=1:nb-1
    for j=1:nb-1
        fprintf(myf,'%.2f    ',Y(i,j));
    end
    fprintf(myf,'\n');
end


%节点相角
fprintf(myf,'-------------节点相角----------\n',1);
for i = 1:nb-1
    fValue(i)=delta(i);
    while(fValue(i)*180/pi<=-180)
        fValue(i)=fValue(i)+2*pi;
    end
    while(fValue(i)*180/pi>=180)
        fValue(i)=fValue(i)-2*pi;
    end
    fprintf(myf,'节点%d的角度   %f\n',i,fValue(i)*180/pi);
end

%线路潮流
for j = 1:nl
    I=line(j,1);
    J=line(j,2);
    fprintf(myf,'线路P（%d--%d）    %f\n',I,J,PIJ(j)*100);
end
fprintf(myf, '\n');
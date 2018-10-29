function Output(bus,line,delta,myf,PIJ,Y)
%������ɾ��󡢽ڵ���ǡ���·����
global myf bus line delta PIJ  Y;

[nb,mb]=size(bus);
[nl,ml]=size(line);
%���ɾ���
fprintf(myf,'-------------���ɾ���----------\n',1);
for i=1:nb-1
    for j=1:nb-1
        fprintf(myf,'%.2f    ',Y(i,j));
    end
    fprintf(myf,'\n');
end


%�ڵ����
fprintf(myf,'-------------�ڵ����----------\n',1);
for i = 1:nb-1
    fValue(i)=delta(i);
    while(fValue(i)*180/pi<=-180)
        fValue(i)=fValue(i)+2*pi;
    end
    while(fValue(i)*180/pi>=180)
        fValue(i)=fValue(i)-2*pi;
    end
    fprintf(myf,'�ڵ�%d�ĽǶ�   %f\n',i,fValue(i)*180/pi);
end

%��·����
for j = 1:nl
    I=line(j,1);
    J=line(j,2);
    fprintf(myf,'��·P��%d--%d��    %f\n',I,J,PIJ(j)*100);
end
fprintf(myf, '\n');
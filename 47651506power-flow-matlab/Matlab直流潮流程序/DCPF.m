function DCPF()
%ֱ����������
clc;
clear;
global Y  P  delta  PIJ   myf  Bus  Line Load Generator;
myf=fopen('E:\ѧϰ\����\Matlabֱ����������\output.dat','wt')

Openfile();
P=FormP();
Y=FormY();
delta=CalDelta();
PIJ=CalP();
Output();

fclose(myf)

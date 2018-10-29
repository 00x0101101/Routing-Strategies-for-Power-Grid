function DCPF()
%直流潮流程序
clc;
clear;
global Y  P  delta  PIJ   myf  Bus  Line Load Generator;
myf=fopen('C:\Users\Administrator\Desktop\DC\DC\output.dat','wt')

Openfile();
P=FormP();
Y=FormY();
delta=CalDelta();
PIJ=CalP();
Output();

fclose(myf)

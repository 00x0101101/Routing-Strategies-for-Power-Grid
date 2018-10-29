function DCPF()
%直流潮流程序
clc;
clear;
global Y  P  delta  PIJ   myf  Bus  Line Load Generator;
myf=fopen('E:\学习\程序\Matlab直流潮流程序\output.dat','wt')

Openfile();
P=FormP();
Y=FormY();
delta=CalDelta();
PIJ=CalP();
Output();

fclose(myf)

function openfile()
global bus load generator line ;

% �����ļ��Ĵ�  ѡ�������ļ� Text ����
[dfile,pathname]=uigetfile('*.m','Select Data File');
if pathname == 0
    error(' you must select a valid data file')
else
    lfile =length(dfile);
    % strip off .m
    eval(dfile(1:lfile-2));
end
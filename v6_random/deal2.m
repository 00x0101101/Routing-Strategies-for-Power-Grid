line1 = find((record_powerloss_total <1.401) &(record_powerloss_total >1.4));
content_line1  = record_content(line1,:);
index_line1 = record_index(line1,:);

line2 = find((record_powerloss_total <1.394) &(record_powerloss_total >1.3935));
content_line2  = record_content(line2,:);
index_line2 = record_index(line2,:);

% line3 = find((record_powerloss_total <1.515) &(record_powerloss_total >1.505));
% content_line3 = record_content(line3,:);
% index_line3 = record_index(line3,:);
% 
% line4 = find((record_powerloss_total <1.505) &(record_powerloss_total >1.495));
% content_line4 = record_content(line4,:);
% index_line4 = record_index(line4,:);
% 
% line5 = find((record_powerloss_total <1.495) &(record_powerloss_total >1.49));
% content_line5 = record_content(line5,:);
% index_line5 = record_index(line5,:);
% 
line6 = find((record_powerloss_total <1.3935));
content_line6 = record_content(line6,:);
index_line6 = record_index(line6,:);

figure(2);
% for i = 1:1:length(index_line1(:,1))
%     plot(index_line1(i,:)),hold on;
% end
for i = 1:1:length(content_line1(:,1))
    plot(content_line1(i,:)),hold on;
end

figure(3);
% for i = 1:1:length(index_line1(:,1))
%     plot(index_line1(i,:)),hold on;
% end
for i = 1:1:length(content_line2(:,1))
    plot(content_line2(i,:)),hold on;
end

figure(4);
% for i = 1:1:length(index_line1(:,1))
%     plot(index_line1(i,:)),hold on;
% end
for i = 1:1:length(content_line6(:,1))
    plot(content_line6(i,:)),hold on;
end
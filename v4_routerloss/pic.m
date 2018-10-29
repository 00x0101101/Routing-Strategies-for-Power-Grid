t=0:2:24;
for i =1:1:12
    P_temp = P_out{i};
    P_1(i) = P_temp(1);
    P_2(i) = P_temp(2);
end
P_1(13) = P_1(1);
P_2(13) = P_2(1);
plot(t,P_1,'-bs','LineWidth',1.5);hold on;
plot(t,P_2,'--ro','LineWidth',1.5);hold on;
xlabel('time');ylabel('Power');
axis([0 24 0 25]);
set(gca,'xtick',0:2:22);
title('各机组出力曲线预测');
legend('机组1','机组2');
grid on;
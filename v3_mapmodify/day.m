% load change, source not change
% expect + real
M = inf;
connect(1,:)=[zeros(1,1),M,1,M,M,M,M,1,M];
connect(2,:)=[zeros(1,2),M,1,M,M,M,M,1];
connect(3,:)=[zeros(1,3),1,1,1,M,M,M];
connect(4,:)=[zeros(1,4),M,1,M,M,1];
connect(5,:)=[zeros(1,5),1,1,M,M];
connect(6,:)=[zeros(1,6),M,1,M];
connect(7,:)=[zeros(1,7),1,1];
connect(8,:)=[zeros(1,8),1];
connect(9,:)=[zeros(1,9)];
Connect=connect+connect';

N=0;
l(1,:)=[zeros(1,1),N,4,N,N,N,N,4,N];
l(2,:)=[zeros(1,2),N,4,N,N,N,N,4];
l(3,:)=[zeros(1,3),5,3,3,N,N,N];
l(4,:)=[zeros(1,4),N,6,N,N,5];
l(5,:)=[zeros(1,5),2,3,N,N];
l(6,:)=[zeros(1,6),N,3,N];
l(7,:)=[zeros(1,7),6,4];
l(8,:)=[zeros(1,8),6];
l(9,:)=[zeros(1,9)];
L = (l+l');
% R = L.*R0.*1000;
R = 0.4*L;
I_real = zeros(size(Connect));
U_real = zeros(size(Connect));

cap_line(1,:)=[zeros(1,1),0,100,0,0,0,0,100,0];
cap_line(2,:)=[zeros(1,2),0,100,0,0,0,0,100];
cap_line(3,:)=[zeros(1,3),100,100,100,0,0,0];
cap_line(4,:)=[zeros(1,4),0,100,0,0,100];
cap_line(5,:)=[zeros(1,5),100,100,0,0];
cap_line(6,:)=[zeros(1,6),0,100,0];
cap_line(7,:)=[zeros(1,7),100,100];
cap_line(8,:)=[zeros(1,8),100];
cap_line(9,:)=[zeros(1,9)];
Capacity_line=cap_line+cap_line';

P_load = zeros(1,length(Connect));
P_out = zeros(1,length(Connect));

expect_load = [
%                0 0 0 0 0 0 0 0 0 0 0 0
%                0 0 0 0 0 0 0 0 0 0 0 0
               1 1 1 3 4 5 4 4 6 5 3 1
               2 3 3 5 6 6 6 5 7 7 3 2
               0 0 0 0 0 0 0 0 0 0 0 0
               0 0 0 0 0 0 0 0 0 0 0 0
               2 2 2 3 3 4 5 6 5 4 3 2
               3 3 4 4 3 4 5 6 5 5 4 3
               2 2 3 4 4 5 5 6 5 4 3 2
               1 1 1 2 2 3 3 3 4 3 3 2
               1 1 2 2 3 3 4 4 5 5 3 1];
expect_source = [
%                  7 7 8 20 12 16 16 18 18 16 12 7
%                  8 8 10 10 15 16 16 16 20 18 10 8
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 7 7 8 20 12 16 16 18 18 16 12 7
                 8 8 10 10 15 16 16 16 20 18 10 8
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0];
             
real_load = [
%              0 0 0 0 0 0 0 0 0 0 0 0
%              0 0 0 0 0 0 0 0 0 0 0 0
             1 1 2 3 4 5 4 4 6 5 3 1  % no.3
             2 3 3 5 6 5 6 5 7 7 3 2  % no.5
             0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0
             2 2 2 3 3 4 5 6 5 4 3 2
             3 3 4 4 3 4 5 6 5 5 4 3
             2 2 3 4 4 5 5 6 5 4 3 2
             1 1 1 2 2 3 3 3 4 3 3 2
             1 1 2 2 3 3 4 4 5 5 3 1];
             
U_rated = 10;
%%
% expect
source = find(all(expect_source ~=0,2))';
source_status = zeros(size(expect_source));
data_I_expect = {I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real};
data_U_expect = {U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real};
P_load = {};
P_out = {};
[point, time] = size(expect_load);
% 
for i = 1:1:time
P_load{i} = zeros(1,length(Connect));
P_out{i} = zeros(1,length(Connect));
    [content,index] = sort(expect_load(:,i),'descend');
    for j = 1:1:point
        destination = index(j);
        P_demand = content(j);
        if P_demand > 0;
        [ data, data_I_expect{i}, data_U_expect{i}, P_load{i}, P_out{i}] = Limited_ShortestPath_loss(Connect, data_I_expect{i}, data_U_expect{i}, P_load{i}, P_demand, destination, U_rated, source, expect_source(:,i), Capacity_line, R, P_out{i} );
%         [ data, data_Status_expect{i}, ~, source_status(:,i) ] = SourceLimited_Mapcal( Connect, source, destination, data_Status_expect{i}, Capacity_line, demand, source_status(:,i), expect_source(:,i), R );
        end
    end
end
%%
% % real
data_I_real = data_I_expect;
data_U_real = data_U_expect;
P_load_real = P_load;
P_out_real = P_out;

compare_load = real_load - expect_load;
[m,n] = find(compare_load~=0);
for k = 1:1:length(m)
    if compare_load(m(k),n(k))>0
        destination = m(k);
        P_demand = compare_load(m(k),n(k));
        [ data, data_I_real{n(k)}, data_U_real{n(k)}, P_load_real{n(k)}, P_out_real{n(k)}] = Limited_ShortestPath_loss(Connect, data_I_expect{n(k)}, data_U_expect{n(k)}, P_load_real{n(k)}, P_demand, destination, U_rated, source, expect_source(:,n(k)), Capacity_line, R, P_out_real{n(k)} );
%         [ data, data_Status_expect{n(k)}, ~, source_status(:,n(k)) ] = SourceLimited_Mapcal( Connect, source, destination, data_Status_expect{n(k)}, Capacity_line, demand, source_status(:,n(k)), expect_source(:,n(k)), R );
    elseif compare_load(m(k),n(k))<0
        destination = m(k);
        P_demand = -compare_load(m(k),n(k));
        [ data, data_I_real{n(k)}, data_U_real{n(k)}, P_load_real{n(k)}, P_out_real{n(k)}] = Limited_LongestPath_loss(Connect, data_I_expect{n(k)}, data_U_expect{n(k)}, P_load_real{n(k)}, P_demand, destination, U_rated, source, expect_source(:,n(k)), Capacity_line, R, P_out_real{n(k)} );
%         [ data, data_Status_expect{n(k)}, ~, source_status(:,n(k)) ] = SourceLimited_Mapcal_longest( Connect, source, destination, data_Status_expect{n(k)}, Capacity_line, demand, source_status(:,n(k)), expect_source(:,n(k)), R );
    end  
end
% %%
% % calculate loss and supply/load
% supply = zeros(1,time);
% for timeindex = 1:1:time
% %     Status_time_temp = triu(data_Status_expect{timeindex});
%     Status_time_temp = data_Status_expect{timeindex};
%     Status_up = triu(data_Status_expect{timeindex});
%     powerloss_time(timeindex) = sum(sum((Status_up.^2.*R)));
%     for sourceindex = 1:1:length(source)
%         supplytemp = sum(Status_time_temp(source(sourceindex),:));
%         supply(timeindex) = supply(timeindex)+supplytemp;
%     end
% end
% load = sum(real_load);
% power_supply = supply./load;
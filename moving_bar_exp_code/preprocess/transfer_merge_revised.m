clear all
exp_folder = 'D:\Leo\0225';
%load([exp_folder, '\data\all_merge_all_pick_unit_a.mat'])
load([exp_folder, '\data\all_merge_all.mat'])
channel = [12,13,14,15,16,17,21,22,23,24,25,26,27,28,31,32,33,34,35,36,37,38,41,42,43,44,45,46,47,48,51,52,53,54,55,56,57,58,61,62,63,64,65,66,67,68,71,72,73,74,75,76,77,78,82,83,84,85,86,87];
unit_number=5;
merge_Spikes = cell(unit_number,60);
%adch_47 = zeros(3);
for h=1:60
    adch_channel = eval(['adch_',int2str(channel(h))]);
    %unit_number = length(unique(adch_channel(:,2)'));
    for u = 1:unit_number
        merge_Spikes{u,h} = adch_channel(find(adch_channel(:,3)==u),1); %
    end
end

% 
% for u=1:unit_number
%     for h=1:60
%         adch_channel = eval(['adch_',int2str(channel(h))]);
%         for i=1:size(adch_channel,1)
%             if adch_channel(i,2)==u
%                 merge_Spikes{u,h} = [merge_Spikes{u,h} adch_channel(i,1)];
%             end
%         end
%     end
% end

cd(exp_folder)
mkdir sort
fileID = fopen([exp_folder, '\playmovie\all_list.txt'],'r');
formatSpec = '%c';
txt = textscan(fileID,'%s','delimiter','\n');
num_files = length(txt{1});
cutrange = zeros(1,num_files+1);

for i = 1:num_files
    load([exp_folder, '\data\', txt{1}{i},'.mat']);
    cutrange(i+1) = cutrange(i) + size(a_data,2);
end

cutrange=cutrange./20000;

for i = 1:num_files
    Spikes = cell(unit_number,60);
    for u=1:unit_number
        for j = 1:60
            spike=find(merge_Spikes{u,j}>cutrange(i) & merge_Spikes{u,j}<cutrange(i+1));
            Spikes{u,j} = merge_Spikes{u,j}(spike)-cutrange(i);
        end
    end
    save([exp_folder,'\sort\',txt{1}{i},'.mat'],'Spikes')
end


fclose(fileID);
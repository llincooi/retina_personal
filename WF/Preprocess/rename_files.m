clear
exp_folder = 'D:\GoogleDrive\retina\Exps\2021\1028'; % change every time
cd([exp_folder,'\LED_output'])
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file);
for i =1:n_file;   date{i,1}=all_file(i).date;    end
[datesort ind]=sort(date)

% cd([exp_folder,'\SplitData'])
% for i=1:n_file
%     movefile([num2str(i),'.mat'],all_file(ind(i)).name)
% end

cd(exp_folder)
mkdir merge
for i=1:n_file
    load([exp_folder,'\SplitData\',all_file(ind(i)).name])
    load([exp_folder,'\LED_output\',all_file(ind(i)).name])
    save([exp_folder,'\merge\',all_file(ind(i)).name], 'a2','a_data','callumin_filter','ey', 'Spikes', 'TimeStamps')
end
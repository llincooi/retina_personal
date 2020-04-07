channelnumber=[32]
analyze_spikes = sorted_spikes;
analyze_spikes{31} = [];
pre = [];
post = [];
remove_index = [];
for i = channelnumber
    spike =analyze_spikes{i}'.*0.001;
    
    inter = diff(spike);
    pre = inter(1:end-1);
    post = inter(2:end);
    figure;
    scatter(pre,post);hold on;
    xlabel('pre isi(sec)');ylabel('post isi(sec)');
    set(gca,'xscale','log')
    set(gca,'yscale','log')
%     for j = 1:length(pre)
%         if pre(j) > 10^-4 || post(j) > 10^-4
%             remove_index = [remove_index j+1];
%         end
%     end
%     analyze_spikes{i}(remove_index) = [];
end



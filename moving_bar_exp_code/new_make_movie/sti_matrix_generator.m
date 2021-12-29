function  matrix = sti_matrix_generator(type, width, length, dynamical_range, productfolder)
load('oled_boundary_set.mat')
mkdir([productfolder,'\matrix_folder\'])
mkdir([productfolder,'\matrix_folder\',type])

mea_size_bm_bm = ceil(mea_size_bm*sqrt(2)/2)*2+1; % larger range for rotation
leftx_bd_bm = meaCenter_x-(mea_size_bm_bm-1)/2; %boundary for larger range
rightx_bd_bm = meaCenter_x+(mea_size_bm_bm-1)/2; %boundary for larger range
if strcmp(type,'SW')
    hw = width;
    if strcmp(length,'long')
        matrix = zeros(dynamical_range(2)-dynamical_range(1)+1, mea_size_bm_bm);
        for kk = dynamical_range(1):dynamical_range(2)
            brightIndex = kk -leftx_bd_bm+1   +(-hw:hw);
            brightIndex(brightIndex<1) = [];
            brightIndex(brightIndex>mea_size_bm_bm) = [];
            matrix(kk+1-dynamical_range(1), brightIndex) = 1;
        end
    else
        matrix = zeros(dynamical_range(2)-dynamical_range(1)+1, mea_size_bm_bm, mea_size_bm_bm);
        for kk = dynamical_range(1):dynamical_range(2)
            brightIndex = kk + (-hw:hw) -leftx_bd_bm+1;
            brightIndex(brightIndex<1) = [];
            brightIndex(brightIndex>mea_size_bm_bm) = [];
            matrix(kk+1-dynamical_range(1), (-bar_le:bar_le)+1+(mea_size_bm_bm-1)/2 ,brightIndex) = 1;
        end
    end
    save([productfolder, 'matrix_folder\',type,'_hw',num2str(width),'_',length,...
        '_',num2str(dynamical_range(1)),'to',num2str(dynamical_range(2)),'.mat'], 'matrix');
    
    
elseif strcmp(type,'GP')
    sigma = width;
    if length == 'long'
        matrix = zeros(dynamical_range(2)-dynamical_range(1)+1, mea_size_bm_bm);
        for kk = dynamical_range(1):dynamical_range(2)
            xaxis = leftx_bd_bm : rightx_bd_bm;
            GF = (exp(-((xaxis-kk)/sigma).^2/2));
            matrix(kk+1-dynamical_range(1), :) = GF;
        end
    else %wait for you to extent
    end
    save([productfolder, 'matrix_folder\',type,'_sigma',num2str(width),'_',length,...
        '_',num2str(dynamical_range(1)),'to',num2str(dynamical_range(2)),'.mat'], 'matrix');

    
elseif strcmp(type,'Grating') % some pos are redundant can be imporved
    hw = width(1);
    D2BR=width(2); %ratio of dark part of Grating to bright part
    cycle = ceil(mea_size_bm_bm/((D2BR+1)*(1+2*hw)));
    cycle_len = (D2BR+1)*(1+2*hw)*cycle;
    if strcmp(length,'long')
        matrix = zeros(dynamical_range(2)-dynamical_range(1)+1, mea_size_bm_bm);
        for kk = dynamical_range(1):dynamical_range(2)
            brightIndex = kk -leftx_bd_bm+1+(-hw:hw);
            for c = 1:cycle-1
                addtional_bar_pos = kk-leftx_bd_bm+1+c*(D2BR+1)*(1+2*hw);
                brightIndex = [brightIndex, addtional_bar_pos +  (-hw:hw)];
            end
            brightIndex(brightIndex>cycle_len) = brightIndex(brightIndex>cycle_len)-cycle_len;
            brightIndex(brightIndex<1) = [];
            brightIndex(brightIndex>mea_size_bm) =[];
            matrix(kk+1-dynamical_range(1), brightIndex) = 1;
        end
    else %wait for you to extent
    end
    save([productfolder, 'matrix_folder\',type,'_hw',num2str(width),'_DBrR',num2str(D2BR),'_',length,...
        '_',num2str(dynamical_range(1)),'to',num2str(dynamical_range(2)),'.mat'], 'matrix');
    
end

    
end
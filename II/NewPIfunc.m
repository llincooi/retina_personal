function [MIxr, MIvr, MIxvR, Redun] = NewPIfunc(Neurons,isi2, isi3,BinningInterval,backward,forward)
% set min(state) = 1;
Neurons = Neurons +1 -1*min(Neurons);
isi2 = isi2 +1 -1*min(isi2);
isi3 = isi3 +1 -1*min(isi3);
binshifts = [-backward:forward];
Redun =zeros(1,length(binshifts));
MIxr=zeros(1,length(binshifts));
MIvr=zeros(1,length(binshifts));
MIxvR=zeros(1,length(binshifts));
for s = 1:length(binshifts)
    shift = binshifts(s);
    if shift>0
        xx=isi2(1+shift:end);
        vv=isi3(1+shift:end);
        rr=Neurons(1:end-shift);
    elseif shift==0
        xx=isi2;
        vv=isi3;
        rr=Neurons;
    elseif shift<0
        xx=isi2(1:end+shift);
        vv=isi3(1:end+shift);
        rr=Neurons(1-shift:end);
    end
    v3d = max(xx)*max(vv)*(rr-1) +  max(xx)*(vv-1) + xx-1; % min(state) == 0 now
    [N,edges] = histcounts(v3d, [unique(v3d) max(v3d)+1]);
    H = zeros(max(xx), max(vv), max(rr)) ;
    for l = 1:length(edges)-1
        k = floor(edges(l)/max(xx)/max(vv))+1;
        j = floor(mod(edges(l), max(xx)*max(vv))/max(xx))+1;
        i = mod(edges(l), max(vv))+1;
        H(i,j,k) = N(l);
    end
    px=sum(H,[2 3])/sum(H, 'all');
    pv=sum(H,[1 3])/sum(H, 'all');
    pr=sum(H,[1 2])/sum(H, 'all');
    pxv=sum(H,3)/sum(H, 'all');
    pxr=sum(H,2)/sum(H, 'all');
    pvr=sum(H,1)/sum(H, 'all');
    pxvr=H/sum(H, 'all');
    MIxr(s)=nansum(pxr.*log2(pxr./px./pr), 'all')/BinningInterval;
    MIvr(s)=nansum(pvr.*log2(pvr./pv./pr), 'all')/BinningInterval;
    MIxvR(s)=nansum(pxvr.*log2(pxvr./pxv./pr), 'all')/BinningInterval;

     PI_xR = squeeze(nansum(pxr.*log2(pxr./px./pr), [1 2]));
     PI_vR = squeeze(nansum(pvr.*log2(pvr./pv./pr), [1 2]));
     Redun(s) = sum(min([PI_xR PI_vR], [], 2))/BinningInterval;
end

end
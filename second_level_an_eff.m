%group analysis for 2-armed bandid results

function second_level_an_eff(arg)

state=arg.initstate;

SE=max(arg.SEN);

nexcltri=arg.nexcltri;

group=zeros(arg.nsubj,3,7);

resp=zeros(arg.nsubj,3);%matrix storing average resp per environment

groupnpr=zeros(arg.nsubj,3);
groupnpr2=zeros(arg.nsubj,10);

W=zeros(3,3);%average value matrix for AccAction
We=zeros(3,10);%average value matrix for AccBoost

for s=1:arg.nsubj
    
    
    
    load(['S' num2str(s)]);
    
    for se=1:SE
        clear buff
        buff(:,1)=dat.rw(state,dat.se==se);
        buff(:,2)=dat.optim(state,dat.se==se);
        buff(:,3)=dat.k(state,dat.se==se);
        buff(:,4)=(abs(dat.D(state,dat.se==se)));
        buff(:,5)=dat.respside(state,dat.se==se);
        buff(:,7)=dat.b(state,dat.se==se);
        buff_npr=squeeze(dat.V(state,dat.se==se,:));
        buff_npr2=squeeze(dat.V2(state,dat.se==se,:));
        
        buff(1:nexcltri,:)=[];
        
        buff_npr(1:nexcltri,:)=[];
        
        buff_npr2(1:nexcltri,:)=[];
        
        group(s,se,1)=mean(buff(:,1));
        group(s,se,2)=mean(buff(buff(:,5)~=3,2));
%         group(s,se,2)=mean(buff(:,2));
        group(s,se,3)=mean(buff(:,3));
        groupnpr(s,:)=mean(buff_npr,1);
        groupnpr2(s,:)=mean(buff_npr2,1);
        group(s,se,5)=mean(buff(:,5));
        group(s,se,7)=mean(buff(:,7));
        
    end
    
    for rty=1:3
            resp(s,rty)=mean(buff(:,5)==rty);
    end
    
    W(state,:)=W(state,:)+mean(buff_npr(end-10:end,:),1);
    We(state,:)=We(state,:)+mean(buff_npr2(end-10:end,:),1);
    
end



respm=mean(resp,1);
respstd=std(resp,1);

W=W/arg.nsubj;
We=We/arg.nsubj;

figure
errorbar([1,2,3],mean(group(:,:,7),1),std(group(:,:,7),1)/sqrt(arg.nsubj));
title('Boost')

figure
errorbar([1,2,3],mean(group(:,:,2),1),std(group(:,:,2),1)/sqrt(arg.nsubj));
title('Optm choices')

figure
errorbar([1,2,3],mean(group(:,:,3),1),std(group(:,:,3),1)/sqrt(arg.nsubj));
title('Kalman gain')

figure
errorbar([1,2,3],mean(group(:,:,5),1),std(group(:,:,5),1)/sqrt(arg.nsubj));
title('choices')
% 
figure
errorbar([1],mean(groupnpr(:,1),1),std(groupnpr(:,1),1)/sqrt(arg.nsubj));
title('DA activity higher-order, resp 1')

figure
errorbar([1],mean(groupnpr(:,2),1),std(groupnpr(:,2),1)/sqrt(arg.nsubj));
title('DA activity higher-order, resp 2')

createfigure2([1 2],[respm(1)/sum(respm(1:2)) respm(3)]*100,(respstd([1 3]))/sqrt(arg.nsubj)*100);

save W W
save We We
save resp resp


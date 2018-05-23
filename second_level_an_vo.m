%group analysis for 2-armed bandid results

function second_level_an_vo(arg)

state=max(arg.SEN);

nexcltri=arg.nexcltri;

group=zeros(arg.nsubj,3,7);

resp=zeros(arg.nsubj,3,3);%matrix storing average resp per environment

SE=3;

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
        buff_npr=dat.V(state,dat.se==se,1:2);
        
        buff(1:nexcltri,:)=[];
        
        buff_npr(:,1:nexcltri,:)=[];
        
        group(s,se,1)=mean(buff(:,1));
        group(s,se,2)=mean(buff(buff(:,5)~=3,2));
        group(s,se,4)=mean(buff(:,4));
        group(s,se,3)=mean(buff(:,3));
        groupnpr(s,state,:)=mean(dat.V(state,:,:),2);
        group(s,se,5)=mean(buff(:,5));
        group(s,se,7)=mean(buff(:,7));
        for rty=1:3
            resp(s,se,rty)=mean(buff(:,5)==rty);
        end
    end
   
    
end

resp=mean(resp,1);
resp=squeeze(resp);

figure
errorbar([1,2,3],mean(group(:,:,7),1),std(group(:,:,7),1)/sqrt(arg.nsubj));
title('Boost')

figure
errorbar([1,2,3],mean(group(:,:,2),1),std(group(:,:,2),1)/sqrt(arg.nsubj));
title('Optm choices')

createfigure([1,2,3],mean(group(:,:,3),1),std(group(:,:,3),1)/sqrt(arg.nsubj))

figure
barwitherr(std(group(:,:,4),1)/sqrt(arg.nsubj),mean(group(:,:,4),1));

figure
errorbar([1,2,3],mean(group(:,:,5),1),std(group(:,:,5),1)/sqrt(arg.nsubj));
title('choices')
% 
figure
errorbar([1],mean(groupnpr(:,state,1),1),std(groupnpr(:,state,1),1)/sqrt(arg.nsubj));
title('DA activity higher-order, resp 1')

figure
errorbar([1],mean(groupnpr(:,state,2),1),std(groupnpr(:,state,2),1)/sqrt(arg.nsubj));
title('DA activity higher-order, resp 2')

save resp resp


%group analysis for 2-armed bandid results

function second_level_an_ho2(arg)

nstate=3;

group=zeros(arg.nsubj,nstate,7);
options=3;
boptions=10;


groupnpr=zeros(arg.nsubj,nstate);
groupnpr3=zeros(arg.nsubj,nstate,options);
groupnpr2=zeros(arg.nsubj,nstate,boptions);
groupnpr4=zeros(arg.nsubj,nstate);

load(['S1']);

grouptr=zeros(arg.nsubj,nstate,length(dat.respside(1,:))-arg.nexcltri);


se=1;

for s=1:arg.nsubj
    
    
    load(['S' num2str(s)]);
    
    buff_npr=cell(3,1);
    
    buff_npr3=cell(3,1);
    buff=cell(3,1);
    
    dat.rw(:,1:arg.nexcltri)=[];
    dat.optim(:,1:arg.nexcltri)=[];
    dat.k(:,1:arg.nexcltri)=[];
    dat.D(:,1:arg.nexcltri)=[];
    dat.respside(:,1:arg.nexcltri)=[];
    dat.b(:,1:arg.nexcltri)=[];
    dat.VTA(:,1:arg.nexcltri)=[];
    dat.VTA2(:,1:arg.nexcltri)=[];
    
    
    for state=1:nstate%1st to 3rd order
        
        buff{state}(:,1)=dat.rw(state,dat.k(state,:)>0)';
        buff{state}(:,2)=dat.optim(state,dat.k(state,:)>0)';
        buff{state}(:,3)=dat.k(state,dat.k(state,:)>0)';
        buff{state}(:,4)=(abs(dat.D(state,dat.k(state,:)>0)))';
        buff{state}(:,5)=dat.respside(state,dat.k(state,:)>0)';
        buff{state}(:,7)=dat.b(state,dat.k(state,:)>0)';
    
        
        buff_npr{state}=(dat.VTA(state,dat.VTA(state,:)>0));
        buff_npr3{state}=(dat.VTA2(state,dat.VTA2(state,:)>0));
        
        
        group(s,state,1)=mean(buff{state}(:,1));
        group(s,state,2)=mean(buff{state}(buff{state}(:,2)~=.5,2));%exclude "stay" trials
        group(s,state,3)=mean(buff{state}(:,3));
        group(s,state,5)=mean(buff{state}(buff{state}(:,5)<3 & buff{state}(:,5)>0,5));%exclude "stay" trials
        group(s,state,7)=mean(buff{state}(:,7));
        
        if sum(arg.trans(1,:))>4 || sum(arg.trans(1,:))>6%if Gersch et al. 2015 task
           grouptr(s,state,:)=dat.optim(state,:);
        end
        
        groupnpr(s,state)=mean(buff_npr{state});
        groupnpr4(s,state)=mean(buff_npr3{state});
        
    end
    

    groupnpr3(s,:,:)=squeeze(mean(dat.V(:,arg.nexcltri+1:end,:),2));
    groupnpr2(s,:,:)=squeeze(mean(dat.V2(:,arg.nexcltri+1:end,:),2));
    
end



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
errorbar([1,2,3],(mean(groupnpr,1)),(std(groupnpr,1))/sqrt(arg.nsubj));
title('DA activity higher-order (from next state)')

figure
errorbar([1,2,3],(mean(groupnpr4,1)),(std(groupnpr4,1))/sqrt(arg.nsubj));
title('DA activity higher-order (from this state)')

figure
barwitherr((std(groupnpr4,1))/sqrt(arg.nsubj),(mean(groupnpr4,1)));

if sum(arg.trans(1,:))>4 || sum(arg.trans(1,:))>6%if Gersch et al. 2015 task
    figure%behavioural learning time course
    tc=squeeze(mean(grouptr(:,3,:),1));
    tcvar=squeeze(std(grouptr(:,3,:),1)/sqrt(arg.nsubj));
    plot(tc,'linewidth',1.5);
    x=1:length(dat.respside(1,:));
    boundedline(x,tc,tcvar,'cmap',[0 0 1],'alpha','transparency',0.3);
end

We=squeeze(mean(groupnpr2,1));
W=squeeze(mean(groupnpr3,1));

save('W','W');
save('We','We');
save('behav','grouptr')
% eval(['save W' num2str(fname) ' W']);
% eval(['save We' num2str(fname) ' We']);


% ['optimal resp = ' num2str(mean(group(:,1,2),1)) ' ' num2str(std(group(:,1,2),1)/sqrt(arg.nsubj))]
% ['Outcome-locked DA activity = ' num2str(mean(groupnpr(state,:,2),2)) ' ' num2str(std(groupnpr(state,:,2))/sqrt(arg.nsubj))]


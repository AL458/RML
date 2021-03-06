
%RML-environment interaction. Simulation of one subject (subID). Argument "arg" defines the environment
%type. Arg is generated by param_build*.m

function kenntask(subID,arg,seed)

%Variables and data structure initialization%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create a specific random stream for current workspace (for parallel batching)
rss = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(rss);

nstate=arg.constAct.nstate;

%miniblock length in trials (each block consists of 5 miniblocks)
Nminiblock=5;
MBLOCK=arg.volnum(1):arg.volnum(2);%miniblocks possible lengths
while sum(MBLOCK(1:Nminiblock))~=90% 90 trials is the length of a block
    MBLOCK=MBLOCK(randperm(length(MBLOCK)));
end
MBLOCK=MBLOCK(1:Nminiblock);



%number of miniblock in each SE
MBLN=length(MBLOCK);
%statistical environment length (each SE is made of 4 miniblocks)
BL=sum(MBLOCK);


arg.SEN(2:end)=randperm(max(arg.SEN)); %first environment is always stat0
%number of trials
NTRI=BL*length(arg.SEN);


%binary reward list
RWLIST=zeros(nstate,length(arg.RWP),NTRI);
for i=1:length(arg.RWP)
    for s=1:nstate
        RWLIST(s,i,1:round(arg.RWP(s,i)*NTRI))=1;
        RWLIST(s,i,:)=RWLIST(s,i,randperm(NTRI));
    end
end

%reward list magnitude
RWLISTM=zeros(size(arg.RWM,1),size(arg.RWM,2),NTRI);
for i=1:size(arg.RWM,2)
    for j=1:nstate
        RWLISTM(j,i,:)=arg.RWM(j,i)+randn(1,NTRI)*arg.var(j,i).^.5;
    end
end



%data structure storing all events
dat.se=zeros(NTRI,1); %statistical environment 1=Stat;2=Stat2;3=Vol
dat.blck=zeros(NTRI,1); %block number
dat.ttype=zeros(NTRI,1); %trial type
dat.respside=zeros(nstate,NTRI); %response side
dat.optim=zeros(nstate,NTRI)+arg.chance2; %response optimality in terms of rw probability
dat.rw=zeros(nstate,NTRI); %reward 1=yes
dat.V=zeros(nstate,NTRI,arg.nactions);
dat.V2=zeros(nstate,NTRI,arg.nactions_boost);
dat.D=zeros(nstate,NTRI);
dat.k=zeros(nstate,NTRI);
dat.k2=zeros(nstate,NTRI);
dat.varD=zeros(nstate,NTRI);
dat.varV=zeros(nstate,NTRI);
dat.varV2=zeros(nstate,NTRI);
dat.VTA=zeros(nstate,NTRI);
dat.VTA2=zeros(nstate,NTRI);

dat.b=zeros(nstate,NTRI);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Start Experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%create RML object%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AccAct=RML(nstate,arg.nactions,arg.constAct);
AccBoost=RML(nstate,arg.nactions_boost,arg.constBoost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initial weights
AccAct.V(1:nstate,:)=importdata('W3.mat');
AccBoost.V(1:nstate,:)=importdata('We3.mat');

trial=1;%trials counter

b=1;

for se=arg.SEN
    for mb=1:MBLN%miniblock counter
        for mbtri=1:MBLOCK(mb)
            
            %RML initialization
            if se==0 %if training
                AccAct.costs=[.5 .5 0;...
                    0.5 0.5 0;...
                    .5 .5 0]; %no barrier and no lesion
                AccAct.lesion=1;
                AccBoost.lesion=1;
            else
                AccAct.costs=arg.constAct.costs;
                AccAct.lesion=arg.constAct.lesion;
                AccBoost.lesion=arg.constBoost.lesion;
            end
            
            s=arg.initstate;%start trial from state s
            
            while s<=nstate %within trial state transitions
                               
                %%%%%RML action selection%%%%%%
                b=action(AccBoost,s,[1:arg.nactions_boost],1);%boost selection  

                if arg.constAct.classic==0%if instrumental
                    res=action(AccAct,s,[1:arg.nactions],b);%action selection
                else%if pavlovian
                    res=1;
                end
        
                %%%%%environment analyzes the response by dCC_Action and
                %%%%%provides outcome (that can be a primary reward, a state transition or both)
                [opt, rw, RW, s1]=resp_analys(trial,se,mb,s,res,RWLIST,RWLISTM,arg.RWM,arg.RWP,arg.trans,arg.chance);
                
                
                %%%RML learning%%%%%%
                learn(AccAct,rw,s,s1,res,RW,b);%feedback analysis dACC_Action
                learn(AccBoost,rw,s,s1,b,RW,b);%feedback analysis dACC_Boost 
      
                %%%record events
                dat.se(trial)=se; %statistical environment 1=Stat;2=Stat2;3=Vol
                dat.blck(trial)=mb; %block number                             
                dat.respside(s,trial)=res; %response side
                dat.optim(s,trial)=opt; %response optimality in terms of rw probability                    
                dat.rw(s,trial)=rw*RW; %reward 1=yes           
                dat.VTA(s,trial)=rw*AccAct.lesion*(RW+AccAct.mu*b)+(1-AccAct.mu)*b*AccAct.gamma*AccAct.lesion*max(AccAct.V(s1,:));
                dat.VTA2(s,trial)=(1-AccAct.mu)*b*AccAct.gamma*AccAct.lesion*max(AccAct.V(s,:));                           
                dat.V(:,trial,:)=AccAct.V(1:nstate,:);
                dat.V2(:,trial,:)=AccBoost.V(1:nstate,:);
                dat.D(s,trial)=abs(AccAct.D(s,res));
                dat.k(s,trial)=(AccAct.k);
                dat.k2(s,trial)=(AccBoost.k);
                dat.varD(s,trial)=mean(AccAct.varD(s,res));
                dat.varK(s,trial)=mean(AccAct.varK(s,res));
                dat.varV(s,trial)=mean(AccAct.varV(s,res));
                dat.varV2(s,trial)=mean(AccAct.varV2(s,res));
                dat.b(s,trial)=b;
                                
                s=s1; %update within trial state
                
            end
                     
            %update trial counter
            trial=trial+1;
        
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eval(['save S' num2str(subID) ' dat']);

end










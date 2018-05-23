%write down parameters data structure from Gersch et al., 2015

arg.nsubj=100;
arg.initstate=1;
arg.nexcltri=0;
arg.nactions=3;%numb of possible actions by dACC_Action
arg.nactions_boost=10;%numb of possible actions by dACC_Boost

%reward mean magnitude and variance by SE
arg.RWM=[1 1 0 0 0 0;...
         2 2 0 0 0 0;...
         2 2 0 0 0 0];
arg.var=[0.05 0.05 0 0 0 0;...
         0.05 0.05 0 0 0 0;...
         0.05 0.05 0 0 0 0];
     %state-action transitions (4=end of trial)
arg.trans=[3 2;...
           4 4;...
           4 4];
%reward prob by SE
arg.RWP=[1 1 .0 .0 .0 .0;... %reward rates at dfferent cond order
	     1 1 .0 .0 .0 .0;...
        1 1 0 0 0 0];
 
 %number of statistical environments administered
arg.SEN=[1 1 1];%SE*REPS;
arg.chance=0.25;%specify what is the a priori chance level to execute the task optimally
arg.chance2=0;%specify what is the a priori chance level to execute the task optimally 
%(if prob is referred to completing the task, then 0, otherwise it refers to the prob of answering correclty to each state within a trial)

arg.constAct.temp=0.6;%temperature
arg.constAct.k=0.3;%initial kalman gain;
arg.constAct.mu=0.1;
arg.constAct.omega=0;
arg.constAct.alpha=0.3;
arg.constAct.eta=0.15;
arg.constAct.beta=1;
arg.constAct.gamma=0.1;
arg.constAct.classic=0;

arg.constAct.lesion=1;%DA lesion, 1=no lesion;

arg.constAct.costs=[.5 .5 0;...
                    0.5 0.5 0;...
                    .5 .5 0];
arg.constAct.nstate=3;
arg.constBoost=arg.constAct;
arg.constBoost.costs=zeros(arg.constAct.nstate,arg.nactions_boost);
arg.constBoost.temp=0.3;
arg.constBoost.omega=0.15;

%init value weights
W3=zeros(arg.constAct.nstate,arg.nactions);
We3=zeros(arg.constAct.nstate,arg.nactions_boost);

% %from instrumental conditioning of 3rd state with RW 3 and 1
% We3=[0         0         0         0         0         0         0         0    0   0;...
%          0         0         0         0         0         0         0         0    0   0;...
%     1.2208    0.9898    0.7603    0.7426    0.5526    0.4448    0.3252    0.3059 0.2003    0.1468];
% 
% W=[0 0 0;...
%    0 0 0;...
%    2.215 2.218 0];

save arg arg
save W3 W3
save We3 We3

save arg arg
%write down parameters data structure from Gersch et al., 2015

arg.nsubj=20;
arg.initstate=1;
arg.nexcltri=0;
arg.nactions=3;%numb of possible actions by dACC_Action
arg.nactions_boost=10;%numb of possible actions by dACC_Boost

arg.volnum=[14,22];%min and max trials before a change point in volatility task (SE=3)

%reward mean magnitude and variance by SE
arg.RWM=[0 .1 0 0 0 0;...
         1 1 0 0 0 0;...
         6 1 0 0 0 0];
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

arg.constAct.costs=[3 .5 0;...
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

%init weights by instrumental conditioning with no F states (param_*gottl_init.m)
We3=[0.8961    1.0156    0.8395    0.7189    0.3775    0.3110    0.1983     0.0921    0.0258   -0.0441;...
    0.6514    0.5931    0.4936    0.4402    0.3273    0.2361    0.2501      0.1257    0.0939    0.0831;...
    0.6922    0.6348    0.5391    0.4190    0.3555    0.2711    0.1758      0.1453    0.0998    0.0845];

W3=[1.6527    1.6088         0;...
    1.7221    1.7899         0;...
    1.8507    1.7118         0];

save arg arg
save W3 W3
save We3 We3

save arg arg
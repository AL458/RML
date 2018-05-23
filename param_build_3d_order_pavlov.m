%write down RML and environmental parameters data structure

arg.nsubj=12;
arg.initstate=1;%1=3rd order, 2=2nd order, 3=1st order.
arg.nexcltri=40;%trials to esclude for data analysis
arg.nactions=3;%numb of possible actions by dACC_Action
arg.nactions_boost=10;%numb of possible actions by dACC_Boost

arg.volnum=[14,22];%min and max trials before a change point in volatility task (SE=3)

%reward mean magnitude and variance by SE
arg.RWM=[0 0 0 0 0 0;...
         0 0 0 0 0 0;...
         8 8 2 2 3 1];
arg.var=[0 0 0 0 0 0;...
         0 0 0 0 0 0;...
         0 0 0 0 0 0];
%state-action transitions (4=end of trial)
arg.trans=[2 2;...
           3 3;...
           4 4];     

%reward prob by SE
arg.RWP=[.73 .0 .0 .0 .0 .0;... %reward rates at dfferent cond order
	 .9 .8 .0 .0 .0 .0;...
     .8 .8 .8 .8 .8 .8];
 
 %number of statistical environments administered
arg.SEN=[1 1 1 1 1];%SE*REPS;
arg.chance=0.5;%specify what is the a priori chance level to execute the task optimally (it can refer either to the entire trial or to single steps)
arg.chance2=0.5;%specify what is the a priori chance level to execute the task optimally 
%(if prob is referred to completing the task, then 0, otherwise it refers to the prob of answering correclty to each state within a trial)

arg.constAct.temp=0.6;%temperature
arg.constAct.k=0.3;%initial kalman gain;
arg.constAct.mu=0.1;
arg.constAct.omega=0;
arg.constAct.alpha=0.3;
arg.constAct.eta=0.15;
arg.constAct.beta=1;
arg.constAct.gamma=0.1;
arg.constAct.classic=1;

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


save arg arg
save W3 W3
save We3 We3

save arg arg
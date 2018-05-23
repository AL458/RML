%run n subjects and launch data analysis scripts


load arg

seed=round(rand(1,arg.nsubj)*100000);

for s=1:arg.nsubj
    kenntask(s,arg,seed(s));
end

%launch data plotting
if max(arg.SEN)>1
   second_level_an_vo(arg);
elseif arg.initstate==3
   second_level_an_eff(arg);
else
   second_level_an_ho2(arg);
end
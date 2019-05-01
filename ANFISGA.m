
clear all
close all
load Data
Table=a;
Table=Table';
[trainingData,valInd,testingData] = dividerand(Table,0.5,0,0.5);
trainingData=trainingData';
testingData=testingData';


%% Anfis

fisys=readfis('y3kprof_5input');
epoch_n = 40;
dispOpt = nan(1,4);
optMethod=1;
[out_fis, error,ss,out_fis1,error1]= anfis(trainingData,fisys,epoch_n,dispOpt,testingData,optMethod);
writefis(out_fis,'testfis')
op_anfis=(evalfis(testingData(:,1:end-1),out_fis));
Anfis_error1=op_anfis-testingData(:,end);
Anfis_error=mser(op_anfis,testingData(:,end));


%% GA starts here
fitness=  @(z) objectiveGA(z,testingData);
options = gaoptimset('MutationFcn',@mutationadaptfeasible,'PopulationSize',10);
                                                
options = gaoptimset(options,'PlotFcns',@gaplotbestf, ...
    'Display','iter','Generations',50);
%  options = gaoptimset(options,'OutputFcn',@myoutputfcn);
dim=5*23*2;
[x,fval,exitflag,output] = ga(fitness,dim,[],[],[],[],0,1,[],options);
out_fis=readfis('GAupdatedfis');
op_fisGA=(evalfis(testingData(:,1:end-1),out_fis));
GAerr=op_fisGA-testingData(:,end);
%%
figure
plot(Anfis_error1,'b')
hold on 
plot(GAerr,'g')
hold on
%% Plot of Membership function
noInp=numel(out_fis.input);
figure
for ii=1:noInp
subplot(3,2,ii)
plotmf(out_fis,'input',ii)

end
figure
for ii=1:noInp
subplot(3,2,ii)
plotmf(out_fis,'input',ii)

end




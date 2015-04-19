close all, clear, clc

[data,~,~] = loaddata();

IdOptions = identifyOptions();
    IdOptions.output = 0;
    IdOptions.inputDelayAuto=false;
    IdOptions.modelType = 'oe';
    IdOptions.target = 'simulation';
    IdOptions.minOrders = [ 1 1 1 1 1];
    IdOptions.maxOrders = [ 5 5 1 1 3];
SimOptions = simOptions();

models = cell(3,1);
J= zeros(3,3);

for i=1:3
    disp(['*Training on ' num2str(i) ' exp']);
    
    training = data{1,i};
    [models{i},~] = identify(training, IdOptions);
    printModel( models{i} );
    
    for j=1:3                                   
            validation = data{1,j};           
            J(i,j) = validate(models{i}, validation, IdOptions.cost, SimOptions);           
            disp(['Validation on ' num2str(j) ' exp: ' num2str(J(i,j))]);
    end
    disp(' ');
end
%%
% figure; hold on; grid;
% h = iopzplot(models{1},'b',models{2},'r',models{3},'c');
% showConfidence(h,3);
% legend('model1', 'model2', 'model3');

for i=1:3
    figure; pzplot(models{i});
end
figure; hold on;
for i=1:3
    step(models{i});
end

save('../data/models/sim/OE23IDmodel.mat','oe23id');
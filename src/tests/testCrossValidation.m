close all, clear, clc
%read comments to see analysis of results

[data,~,~] = loaddata();

IdOptions = identifyOptions();
    IdOptions.output = 0;
SimOptions = simOptions();

models = cell(3,1);

for i=1:3
    disp(['*Training on ' num2str(i) ' exp']);
    
    training = data{1,i};
    [models{i},~] = identify(training, IdOptions);
    printModel( models{i} );
    
    for j=1:3       
        if i ~= j                            
            validation = data{1,j};           
            J = validate(models{i}, validation, IdOptions.cost, SimOptions);           
            disp(['Validation on ' num2str(j) ' exp: ' num2str(J)]); disp(' ');
        end
    end
end
%%
figure; hold on; grid;
plot( roots(models{1}.a), 'O' ); 
plot( roots(models{2}.a), 'X' );
plot( roots(models{3}.a), 's' );
legend('model1', 'model2', 'model3','Location','northwest');

%model1 has an order more than the other two and 
disp(' ');
norm2 = norm(models{2},2);
norm3 = norm(models{3},2);
disp(['Distance between model2 and model3: ' num2str(abs(norm2-norm3)) ]);

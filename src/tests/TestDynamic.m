close all;

% step response is perceivably different. In order to discriminate the
% different model, an idea might be to see how the true system reacts to the
% a step response.

models1 = load('../data/models/sim/ARXmodels.mat', 'models'); models1 = models1.models;
models2 = load('../data/models/sim/OEmodels.mat', 'models'); models2 = models2.models;


% for i=1:3
%     disp(['Validation ' num2str(i) ': ' num2str(models1{i}.NoiseVariance) ' - ' num2str(models2{i}.NoiseVariance) ]);
% end

% arxinfo = cell(3,1);
% oeinfo = cell(3,1);
% 
% for i=1:3
%     arxinfo{i} = stepinfo(models1{i});
%     oeinfo{i} = stepinfo(models2{i});
% end
% 
% disp(['arx1: OV ' num2str(arxinfo{1}.Overshoot) ' SET ' num2str(arxinfo{1}.SettlingTime)]);
% disp(['arx2: OV ' num2str(arxinfo{2}.Overshoot) ' SET ' num2str(arxinfo{2}.SettlingTime)]);
% disp(['arx3: OV ' num2str(arxinfo{3}.Overshoot) ' SET ' num2str(arxinfo{3}.SettlingTime)]);
% 
% disp(['oe1: OV ' num2str(oeinfo{1}.Overshoot) ' SET ' num2str(oeinfo{1}.SettlingTime)]);
% disp(['oe2: OV ' num2str(oeinfo{2}.Overshoot) ' SET ' num2str(oeinfo{2}.SettlingTime)]);
% disp(['oe3: OV ' num2str(oeinfo{3}.Overshoot) ' SET ' num2str(oeinfo{3}.SettlingTime)]);


for i=1:3
    figure; pzplot(models1{i});
    figure; pzplot(models2{i});
end
% for i=1:3
%     figure; pzplot(models2{i});
% end

% figure; hold on;
% for i=1:3
%     step(models1{i});
% end
% legend('model1','model2','model3');
% 
% figure; hold on;
% for i=1:3
%     step(models2{i});
% end
% legend('model1','model2','model3');
% % 
%  figure; hold on;
% for i=1:3
%     step(models1{i});
%     step(models2{i});
% end
%legend('ARXmodel1','OEmodel1','ARXmodel2','OEmodel2','ARXmodel3','OEmodel3');

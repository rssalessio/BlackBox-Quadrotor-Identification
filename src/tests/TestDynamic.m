close all;

%step response is perceivably different. In order to discriminate the
%different model, an idea might be to see how the true system reacts to the
%a step response.

ARXmodels = load('../data/models/ARXmodels.mat', 'models');
OEmodels = load('../data/models/OEmodels.mat', 'models');

ARXmodels = ARXmodels.models;
OEmodels = OEmodels.models;

arxinfo = cell(3,1);
oeinfo = cell(3,1);

for i=1:3
    arxinfo{i} = stepinfo(ARXmodels{i});
    oeinfo{i} = stepinfo(OEmodels{i});
end

disp(['arx1: OV ' num2str(arxinfo{1}.Overshoot) ' SET ' num2str(arxinfo{1}.SettlingTime)]);
disp(['arx2: OV ' num2str(arxinfo{2}.Overshoot) ' SET ' num2str(arxinfo{2}.SettlingTime)]);
disp(['arx3: OV ' num2str(arxinfo{3}.Overshoot) ' SET ' num2str(arxinfo{3}.SettlingTime)]);

disp(['oe1: OV ' num2str(oeinfo{1}.Overshoot) ' SET ' num2str(oeinfo{1}.SettlingTime)]);
disp(['oe2: OV ' num2str(oeinfo{2}.Overshoot) ' SET ' num2str(oeinfo{2}.SettlingTime)]);
disp(['oe3: OV ' num2str(oeinfo{3}.Overshoot) ' SET ' num2str(oeinfo{3}.SettlingTime)]);


% for i=1:3
%     figure; pzplot(ARXmodels{i});
% end
% for i=1:3
%     figure; pzplot(OEmodels{i});
% end
% 
% figure; hold on;
% for i=1:3
%     step(ARXmodels{i});
% end
% legend('model1','model2','model3');
% 
% figure; hold on;
% for i=1:3
%     step(OEmodels{i});
% end
% legend('model1','model2','model3');

% figure; hold on;
% for i=1:3
%     step(ARXmodels{i});
%     step(OEmodels{i});
% end
% legend('ARXmodel1','OEmodel1','ARXmodel2','OEmodel2','ARXmodel3','OEmodel3');

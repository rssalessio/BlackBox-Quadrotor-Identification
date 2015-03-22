% clear, clc, close all
% [data,model]= loaddata();
% stateSpaceModel=ss(model.A,model.B,model.C,model.D,0.2);
% 
% u = data.u1;
% y = data.y1;

 N= length(o.y1);
fftout=fft(o.y1);
mod = zeros(1,N/2);
mod(1)=abs(fftout(1))/N;
mod(2:N/2)=abs(fftout(2:N/2))*2/N;
figure;
plot(mod)

mody=mod;

 N= length(i.u1);
fftout=fft(i.u1);
mod = zeros(1,N/2);
mod(1)=abs(fftout(1))/N;
mod(2:N/2)=abs(fftout(2:N/2))*2/N;
figure;
plot(mod)
modu=mod;
figure;
plot(mody./modu);


%  u = data.separated.A.ol1;
%  y = y(614:1611);
% % lim = 100;
% % N = length(y)-200;
% % 
% % data=iddata(y,u);
% % 
% % NA = 12;
% % NB = 40;
% % minJ = 1000;
% % minTheta = [0];
% % minNa=0;
% % minNb=0;
% % for na=1:NA
% %     for nb = 1:NB
% %         X = zeros(na+nb, na+nb);
% %         phi = zeros(na+nb,1);
% %         res = zeros(na+nb,1);
% %         for i=1:N
% %            phi = [ y(lim-na+i:lim+i-1); u(lim-nb+i:lim+i-1)];
% %            X = X+ phi*phi';
% %            res = res+phi*y(lim+i);
% %         end
% %         theta = X\res;
% %         J=0;
% %         for i=1:N
% %            phi = [ y(lim-na+i:lim+i-1); u(lim-nb+i:lim+i-1)];
% %            J = J+(y(i)- phi'*theta)^2;
% %         end
% %         J=J/N;
% %         if (J < minJ)
% %             minJ=J;
% %             minTheta = [0; theta];
% %             minNa = na;
% %             minNb = nb;
% %             disp(['na : ' num2str(na) ' nb: ' num2str(nb) ' J: ' num2str(J)]);
% %         end
% %     end
% % end
% % minTheta = minTheta(2:end,1);
% % filter = filt([0 minTheta(minNa+1:end)'], [1 -minTheta(1:minNb)']);
% % risfin = lsim(filter, u);
% % plot(1:998, y, 1:998, risfin-mean(risfin)); grid; 
% 
% %%
% % 
% opt = bjOptions;
% opt.Focus = 'prediction';
% min=0;
% minna=0;
% minnb=0;
% minnc=0;
% minnd=0;
% for na=1:10
%     for nb=1:1
%         for nc=1:1
%            for nd=1:10
%                 model = oe(iddata(y,u), [na  nd 1], opt);
%                 if (model.Report.Fit.FitPercent > min)
%                     min=model.Report.Fit.FitPercent
%                     minna=na;
%                     minnb=nb;
%                     minnc=nc;
%                     minnd=nd;
%                 end
%                 disp([num2str(na) ' - ' num2str(nb) ' - ' num2str(nc) ' - ' num2str(nd)  ]);
%             end
%         end
%     end
% end
% % min
% % minna
% % minnb
% %%
% % figure;
% % plot(1:998,lsim(oe(iddata(y,u),[minna minnd 1],opt),u),1:998,y);
% 
% mdl=oe(iddata(y,u),[8 8 1],opt);
% 
% u = data.u1;
% y = data.y1;
% 
% 
% simulate(u,y,mdl,stateSpaceModel);

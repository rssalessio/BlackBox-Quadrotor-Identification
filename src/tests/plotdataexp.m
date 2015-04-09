clc; clear all; close all;

 [data,ss,Ts]=loaddata();
 
 J = zeros(5,3);
 
 for k=1:3
     for n=1:4
     [~,temp, ~] = inspectSignal.isWhite(data{n,k}.u, 0.1, 1, 'plot', '');  
     J(n,k)=temp;
     end
 end
 
 for k=1:3
 x = data{3,k}.u;
 x = x(200:end-200);
 [~,temp, ~] = inspectSignal.isWhite(x, 0.1, 0.1, 'nooutput', '');  
 J(5,k)=temp;
 end
 
 
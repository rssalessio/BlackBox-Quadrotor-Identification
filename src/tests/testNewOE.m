clc 
close all
clear all
[data,sm,t]=loaddata();

  data= detrend(data{1,1});
  
  
  oeMatlab = oe(data, [5 5 2]);
  
  theta = newMinOE(data, [5 5 2]);
  
  
  m = tf(theta(1:5)', theta(6:end)',0.2,'variable', 'z^-1');
  pzplot(m)
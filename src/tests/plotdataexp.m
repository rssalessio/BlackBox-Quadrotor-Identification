
close all; clear all; clc;
[i,o,m]=loaddata();

figure;
subplot(2,1,1);

plot([zeros(length(o.exp1.y1)+length(o.exp1.y2),1); o.exp1.y3]); hold on;
plot([zeros(length(o.exp1.y1),1) ;o.exp1.y2]); hold on;
plot(o.exp1.y1); hold on; grid; xlabel('Time [s]'); ylabel('y(t)');
grid;title('Experiment 1');
subplot(212);

plot([zeros(length(i.exp1.u1)+length(i.exp1.u2),1); i.exp1.u3]); hold on;
plot([zeros(length(i.exp1.u1),1) ;i.exp1.u2]); hold on;
plot(i.exp1.u1); hold on;grid; xlabel('Time [s]'); ylabel('u(t)');


figure;
subplot(2,1,1);

plot([zeros(length(o.exp2.y1)+length(o.exp2.y2),1); o.exp2.y3]); hold on;
plot([zeros(length(o.exp2.y1),1) ;o.exp2.y2]); hold on;
plot(o.exp2.y1); hold on; grid; xlabel('Time [s]'); ylabel('y(t)');
grid;title('Experiment 2');
subplot(212);

plot([zeros(length(i.exp2.u1)+length(i.exp2.u2),1); i.exp2.u3]); hold on;
plot([zeros(length(i.exp2.u1),1) ;i.exp2.u2]); hold on;
plot(i.exp2.u1); hold on;grid; xlabel('Time [s]'); ylabel('u(t)');


figure;
subplot(2,1,1);

plot([zeros(length(o.exp3.y1)+length(o.exp3.y2),1); o.exp3.y3]); hold on;
plot([zeros(length(o.exp3.y1),1) ;o.exp3.y2]); hold on;
plot(o.exp3.y1); hold on; grid; xlabel('Time [s]'); ylabel('y(t)');
grid;title('Experiment 3');
subplot(212);

plot([zeros(length(i.exp3.u1)+length(i.exp3.u2),1); i.exp3.u3]); hold on;
plot([zeros(length(i.exp3.u1),1) ;i.exp3.u2]); hold on;
plot(i.exp3.u1); hold on;grid; xlabel('Time [s]'); ylabel('u(t)');


inspectSignal.inspectX(i.
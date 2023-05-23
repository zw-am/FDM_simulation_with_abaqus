% %close all;
clear all; clc; fclose all; close all;
%%%%%%%%%%%%%%%%
Nx = 30;
Ny=1;
Nz = 10;
LENGTH1 = 0.01;% small size, length = 
width = 0.008; % 
thickness = 0.003; %
coolORnot = 0;% if equals 1, then cool the part down
data_cell = [1,2,3];% S11
% data_cell = [1,2,4];% S22
%% %%%%%%%%%%%%%%%%%%
SS_avg_1 = [];N_layer =1;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_1 = [SS_avg_1;T_layer mean(c)];
end
SS_avg_1 = [1, 0;SS_avg_1];fclose all;
%
%% %%%%%%%%%%%%%%%%%%
SS_avg_3 = [];N_layer =3;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_3 = [SS_avg_3;T_layer mean(c)];
end
SS_avg_3 = [1, 0;SS_avg_3];fclose all;
%% %%%%%%%%%%%%%%%%%%
SS_avg_6 = [];N_layer =6;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_6 = [SS_avg_6;T_layer mean(c)];
end
SS_avg_6 = [1, 0;SS_avg_6];fclose all;
%% %%%%%%%%%%%%%%%%%%
SS_avg_10 = [];N_layer =10;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_10 = [SS_avg_10;T_layer mean(c)];
end
SS_avg_10 = [1, 0;SS_avg_10];fclose all;
%%
t_lys = [0 6 9 12 15 18 21 24 27 30];
figure; hold on;
plot(t_lys,SS_avg_1(:,2),'-x','linewidth',2);
plot(t_lys,SS_avg_3(:,2),'-s','linewidth',2);
plot(t_lys,SS_avg_6(:,2),'-o','linewidth',2);
plot(t_lys,SS_avg_10(:,2),'-*','linewidth',2);
xlabel('Time (sec.)');ylabel('S_{11}');
legend('1-interval','3-interval','6-interval','10-interval');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_cell = [1,2,3];% S11
data_cell = [1,2,4];% S22
%% %%%%%%%%%%%%%%%%%%
SS_avg_1 = [];N_layer =1;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_1 = [SS_avg_1;T_layer mean(c)];
end
SS_avg_1 = [1, 0;SS_avg_1];fclose all;
%
%% %%%%%%%%%%%%%%%%%%
SS_avg_3 = [];N_layer =3;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_3 = [SS_avg_3;T_layer mean(c)];
end
SS_avg_3 = [1, 0;SS_avg_3];fclose all;
%% %%%%%%%%%%%%%%%%%%
SS_avg_6 = [];N_layer =6;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_6 = [SS_avg_6;T_layer mean(c)];
end
SS_avg_6 = [1, 0;SS_avg_6];fclose all;
%% %%%%%%%%%%%%%%%%%%
SS_avg_10 = [];N_layer =10;
%
[nodes_1,els_1] = abq_LAAM_mesh(Nx,Ny,Nz,N_layer,LENGTH1,width,thickness,coolORnot);
%close all;

for j = 2:10
T_layer  = j;
filename = ['abaqus_',num2str(N_layer),'_',num2str(T_layer),'30.rpt'];
fid = fopen(filename, 'rt');
node= nodes_1;%load('node.dat');
elem= els_1;%load('elem.dat');
% read the entire file, if not too big
s = textscan(fid, '%s', 'delimiter', '\n');
% str1 = '-------------------------------------------------';
% str1 = '---------------------------------------------------------------------------------';
str1 = '-----------------------------------------------------------------';
idx1 = find(strcmp(s{1}, str1), 1E10, 'first');S11num  = [];
for p = 1:length(idx1)
    S11str_1 = s{1}(idx1(p)+1:idx1(p)+8);
    for q = 1:8
    S11num      = [S11num; str2num(S11str_1{q})];
    end
%     keyboard
end
s11_cell = zeros(8,4,p);
for i = 1:p
    s11_cell(:,:,i) = S11num(1+(i-1)*8:8+(i-1)*8,:);
end
%
s11 = s11_cell(:,data_cell,:);
node_a = [];
for i = 1:size(node,1)
    node_a = [node_a;i node(i,:)];
end
% figure;
% patchHEX_abq(node_a,s11);
% view([180 0]);

% z = 0.003;y= 0.008;x = 0.1;
idf = find(nodes_1(:,1) == 0.100 & nodes_1(:,2) == 0.008 & nodes_1(:,3) == 0.006);
% for j = 1:size(s11,3)
[a,b]=find(squeeze(s11(:,2,:)) == idf);
%
c = [];
for i = 1:length(a)
    c=[c;s11(a(i),3,b(i))];
end
SS_avg_10 = [SS_avg_10;T_layer mean(c)];
end
SS_avg_10 = [1, 0;SS_avg_10];fclose all;
%%
t_lys = [0 6 9 12 15 18 21 24 27 30];

figure; hold on;
plot(t_lys,SS_avg_1(:,2),'-x','linewidth',2);
plot(t_lys,SS_avg_3(:,2),'-s','linewidth',2);
plot(t_lys,SS_avg_6(:,2),'-o','linewidth',2);
plot(t_lys,SS_avg_10(:,2),'-*','linewidth',2);
xlabel('Time (sec.)');ylabel('S_{22}');
legend('1-interval','3-interval','6-interval','10-interval');

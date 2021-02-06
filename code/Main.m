clc;
clear all;
close all;


%% ��������
global geom dynam param 
% %%
% load('./lib/���ӻ�����.mat');
%% ����
% ���ɳ�ʼ����
param.nx = 2; 
param.ny = 2;
param.distx = 5;
param.disty = 5;
param.noise = 0.0;
Planar_Sheet_2D('hexagonal');

geom.Nc = length(geom.cell_v(:,1));
geom.Nv = length(geom.vertices(:,1));

dynam.force = zeros(geom.Nv,2);

param.Ka = 5; % ~ 5e9 N/m = 5 pN/(um)^3
param.Kc = 2; % ~ 2e-3 N/m = 2 pN/um
param.Kv = 100; % 1e4 N s/m^2 = 10 pN s/um^2
param.A0 = 3*sqrt(3)/2; % (um)^2
param.P = 0.1; % 1e2 N/m^2 = 0.1 pN/um^2
param.H = 5; % ~ 5 um

%% test history
% % figure;
% for i = 1:20
%     theta = 2*pi*rand(length(vertices(:,1)),1);
%     rho = 0.1;
%     displacement = cat(2, rho*cos(theta), rho*sin(theta));
%     vertices = vertices + displacement;
%     CellVisualization(vertices, cell_v);
%     name = ['DemoNo.',num2str(i),'.jpg'];
%     print('-dtiff','-r300',name);
%     close
% end

% geom_update(); % ����geom������� Nc Nv vertices cell_v ���¼��β���
% dynam_update(); % ����geom�����а����ļ�����Ϣ������

%% ��ѭ��
timestep = 10;
dt = 0.5;
mkdir fig

for i = 1:timestep
    geom_update();
    dynam_update();
    for j = 1:geom.Nv
        geom.vertices(j,:) =  geom.vertices(j,:) + dt*dynam.force(j,:)/param.Kv;
    end
    CellVisualization(geom);
    name = ['./fig/DemoNo.',num2str(i),'.jpg'];
    print('-dtiff','-r300',name);
    close
end

% command1 = 'cd C:\Users\Lenovo\Desktop\��ҵ���\2020-12-30����\����ģ�ͣ����ɱ߽磩Matlab\fig ';
% command2 = 'magick *.jpg Ani.gif';
% system(command1,command2);
delete ./fig/*
%% subfunctions
function y = before_after(list, x)
% ʵ��һ���������βѭ������������
%     INPUT: list: ���⣬һ���̶����ȵ��б�
%            x: �б���ĳ��Ԫ�أ�
%     OUTPUT: y = [before, after]���б���β��ӣ�before��x֮ǰ��Ԫ�أ�after��x֮���Ԫ��
    index = find(list==x);
    if isempty(index)
        error('������û��Ҫ�ҵ�Ԫ�أ�Ҳ��û��ǰԪ�ͺ�Ԫ��');
    elseif index == length(list)
        afterIndex = 1;
        beforeIndex = index-1;
    elseif index == 1
        afterIndex = index+1;
        beforeIndex = length(list);
    else 
        afterIndex = index+1;
        beforeIndex = index-1;
    end
    before = list(beforeIndex);
    after = list(afterIndex);
    y = [before, after];
end

function dir = bisect(a, b)
% ������������a��b �Ľ�ƽ��������������Ĭ����a b �����
%   INPUT: a,b: 1x2 ����������
%   OUTPUT: dir: ��ƽ�������� 1x2����
    dir = (a/norm(a) + b/norm(b))/norm(a/norm(a) + b/norm(b));

    if norm(dir)==0
        dir = [a(2),-a(1)];
    end

end







clc;
clear all;
close all;


%% 变量声明
global geom dynam param 
% %%
% load('./lib/可视化样例.mat');
%% 参数
% 生成初始构型
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

% geom_update(); % 根据geom对象里的 Nc Nv vertices cell_v 更新几何参数
% dynam_update(); % 根据geom对象中包含的几何信息计算力

%% 主循环
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

% command1 = 'cd C:\Users\Lenovo\Desktop\毕业设计\2020-12-30程序\顶点模型（自由边界）Matlab\fig ';
% command2 = 'magick *.jpg Ani.gif';
% system(command1,command2);
delete ./fig/*
%% subfunctions
function y = before_after(list, x)
% 实现一个数组的首尾循环的索引操作
%     INPUT: list: 如题，一个固定长度的列表；
%            x: 列表中某个元素；
%     OUTPUT: y = [before, after]将列表首尾相接，before是x之前的元素，after是x之后的元素
    index = find(list==x);
    if isempty(index)
        error('数组里没有要找的元素，也就没有前元和后元！');
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
% 计算两个向量a，b 的角平分线向量，方向默认与a b 成锐角
%   INPUT: a,b: 1x2 的数组向量
%   OUTPUT: dir: 角平分线向量 1x2数组
    dir = (a/norm(a) + b/norm(b))/norm(a/norm(a) + b/norm(b));

    if norm(dir)==0
        dir = [a(2),-a(1)];
    end

end







clc;
clear all;
close all;


%% 变量声明
global geom dynam param 
%%
load('./lib/可视化样例.mat');
%% 参数
geom.Nc = length(geom.cell_v(:,1));
geom.Nv = length(geom.vertices(:,1));

dynam.force = zeros(geom.Nv,2);

param.Ka = 2; % ~ 5e9 N/m = 5 pN/(um)^3
param.Kc = 1; % ~ 2e-3 N/m = 2 pN/um
param.Kv = 0.01;
param.A0 = 3*sqrt(3)/2; % (um)^2
% % 生成初始构型
% param.nx = 3; 
% param.ny = 3;
% param.distx = 1.0;
% param.disty = 1.0;
% param.noise = 0.0;
% Planar_Sheet_2D('hexagonal')


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
dt = 1;
mkdir fig

for i = 1:timestep
    geom_update();
    dynam_update();
    geom.vertices = geom.vertices - param.Kv*dt*dynam.force;
    CellVisualization(geom);
    name = ['./fig/DemoNo.',num2str(i),'.jpg'];
    print('-dtiff','-r300',name);
    close
end

movefile ./fig/*.jpg
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







clc;
clear all;
close all;


%% ��������
global geom dynam param 
%%
load('./lib/���ӻ�����.mat');
%% ����
geom.Nc = length(geom.cell_v(:,1));
geom.Nv = length(geom.vertices(:,1));

dynam.force = zeros(geom.Nv,2);

param.Ka = 2; % ~ 5e9 N/m = 5 pN/(um)^3
param.Kc = 1; % ~ 2e-3 N/m = 2 pN/um
param.Kv = 0.01;
param.A0 = 3*sqrt(3)/2; % (um)^2
% % ���ɳ�ʼ����
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

% geom_update(); % ����geom������� Nc Nv vertices cell_v ���¼��β���
% dynam_update(); % ����geom�����а����ļ�����Ϣ������

%% ��ѭ��
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







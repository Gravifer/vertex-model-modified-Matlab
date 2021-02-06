function dynam_update()
% 根据geom对象中包含的几何信息计算如下力信息：
% force
% stress
%% 变量声明
global geom dynam param

Nv = geom.Nv;
Nc = geom.Nc;
cell_v = geom.cell_v;
vertices = geom.vertices;
vNVI_v = geom.vNVI_v;

Ka = param.Ka;
Kc = param.Kc;
A0 = param.A0;
%% 从构型计算面积力F_a : Areal Force(可与周长力计算合并循环)
%面积力大小等于Ka*(A_i-A_0)，方向垂直于顶点的两个邻居顶点的连线指向细胞外侧
F_a = zeros(Nv,2); %F_a是一个Nvx2的数组，每一行对应一个顶点上作用的面积力的总和
for i = 1:Nc
    vList = cell_v{i};
    % 计算面积力大小
    polyin = polyshape(vertices(vList, :));
    Ai = area(polyin);
    fa = Ka*(Ai-A0);
    for j = 1:length(vList)
        % 计算顶点j处面积力的方向，由顶点j的邻居细胞决定
        idx = vList(j);
        coord = vertices(idx, :);
        nb_idx = vNVI_v{idx};
        nb_coord = vertices(nb_idx, :); % 存放两个从j顶点出发指向邻居顶点的向量
        line = nb_coord(1, :) - nb_coord(2, :);
        dir = [line(2),-line(1)];
        if isinterior(polyin,dir + coord) % 确保方向朝外 
            dir = -dir;
        end
        F_a(idx, :) = F_a(idx, :) + fa*dir;
    end
end
clear i vList j Ai fa nb_idx coord idx nb_coord dir line polyin

%% 从构型计算周长力F_c : Contraction Force
%周长力大小等于Kc*L_i, 方向沿着两条邻边的角平分线指向细胞内侧
F_c = zeros(Nv,2);
for i = 1:Nc
    vList = cell_v{i};
    polyin = polyshape(vertices(vList, :));
    L_i = perimeter(polyin);
    fc = Kc*L_i;
    for j = 1:length(vList)
        idx = vList(j);
        coord = vertices(idx,:);
        nb_idx = vNVI_v{idx};
        nb_coord = vertices(nb_idx,:) - coord;
        dir = bisect(nb_coord(1,:),nb_coord(2,:));
        if ~isinterior(polyin,dir + coord) %确保方向朝内
            dir = -dir;
        end
        F_c(idx,:) = F_c(idx,:) + fc*dir;
    end
end
clear i vList polyin L_i fc j idx coord nb_idx nb_coord dir 

dynam.force = F_a + F_c ;


end


%% subfunction
function dir = bisect(a, b)
    % 计算两个向量a，b 的角平分线向量，方向默认与a b 成锐角
    %   input: a,b: 1x2 的数组向量
    %   output: dir: 角平分线向量 1x2数组
    dir = (a/norm(a) + b/norm(b))/norm(a/norm(a) + b/norm(b));

    if norm(dir)==0
        dir = [a(2),-a(1)];
    end
end
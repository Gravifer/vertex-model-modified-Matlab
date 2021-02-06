function geom_update()
% 根据geom对象里的 Nc Nv vertices cell_v 更新如下几何参数：
% vNCI_c
% vNVI_v
%% 变量声明
global geom
Nc = geom.Nc;
Nv = geom.Nv;
cell_v = geom.cell_v;
vertices = geom.vertices;
%% 从cell_v计算vNCI_c: vertices' Neighbour Cell Index written by index of cell_v
% 未逆时针排序
vNCI_c = cell(Nv,1);
for i = 1:Nc
   vlist = cell_v{i};
   for j = 1:length(vlist)
       nciList = union(vNCI_c{vlist(j)},i); %单个元素也是单元向量、
       vNCI_c{vlist(j)} = nciList;
   end
end
clear i vlist nciList
geom.vNCI_c = vNCI_c;
%% 从cell_v和vertices计算vNVI_v: vertices' Neighbour Vertices Index written by index of vertices
% 未逆时针排序
vNVI_v = cell(Nv,1);
for i = 1:Nc
    vlist = cell_v{i};
    for j = 1:length(vlist)
        ba = before_after(vlist,vlist(j));
        nviList = union(vNVI_v{vlist(j)},ba);
        vNVI_v{vlist(j)} = nviList;
    end
end
for i = 1: length(vNVI_v)
    vNVI_v{i} = vNVI_v{i}';
end
clear i vlist j ba nviList 
geom.vNVI_v = vNVI_v;

%% 计算每个顶点的s数组
% 每个顶点从属于周围的几个细胞。在每个细胞中，该顶点有且仅有两个邻居顶点。
% 定义在某个细胞中，两个邻居顶点的距离为s。按照该顶点在vNCI_c中邻居细胞的顺序，分别计算对应细胞的s，形成一个数组。
s = cell(Nv,1);
for i = 1:Nv
    nci = geom.vNCI_c{i};
    ss = zeros(length(nci),1)';
    for j = 1:length(nci)
        clist = cell_v{nci(j)};
        nb_list = before_after(clist,i);
        ss(j) = norm(vertices(nb_list(1),:)-vertices(nb_list(2),:));
    end
    s{i} = ss;
end
geom.s = s;
clear s i nci ss j clist nb_clist ss
end


%% subfunctions
function y = before_after(list, x)
% 实现一个数组的首尾循环的索引操作
%     input: list: 如题，一个固定长度的列表；
%            x: 列表中某个元素；
%     output: y = [before, after]将列表首尾相接，before是x之前的元素，after是x之后的元素
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


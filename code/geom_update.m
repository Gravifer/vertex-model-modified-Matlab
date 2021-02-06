function geom_update()
% ����geom������� Nc Nv vertices cell_v �������¼��β�����
% vNCI_c
% vNVI_v
%% ��������
global geom
Nc = geom.Nc;
Nv = geom.Nv;
cell_v = geom.cell_v;
%% ��cell_v����vNCI_c: vertices' Neighbour Cell Index written by index of cell_v
% δ��ʱ������
vNCI_c = cell(Nv,1);
for i = 1:Nc
   vlist = cell_v{i};
   for j = 1:length(vlist)
       nciList = union(vNCI_c{vlist(j)},i); %����Ԫ��Ҳ�ǵ�Ԫ������
       vNCI_c{vlist(j)} = nciList;
   end
end
clear i vlist nciList
geom.vNCI_c = vNCI_c;
%% ��cell_v��vertices����vNVI_v: vertices' Neighbour Vertices Index written by index of vertices
% δ��ʱ������
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

end


%% subfunctions
function y = before_after(list, x)
% ʵ��һ���������βѭ������������
%     input: list: ���⣬һ���̶����ȵ��б�
%            x: �б���ĳ��Ԫ�أ�
%     output: y = [before, after]���б���β��ӣ�before��x֮ǰ��Ԫ�أ�after��x֮���Ԫ��
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


function dynam_update()
% ����geom�����а����ļ�����Ϣ������������Ϣ��
% force
% stress
%% ��������
global geom dynam param

Nv = geom.Nv;
Nc = geom.Nc;
cell_v = geom.cell_v;
vertices = geom.vertices;
vNVI_v = geom.vNVI_v;

Ka = param.Ka;
Kc = param.Kc;
A0 = param.A0;
%% �ӹ��ͼ��������F_a : Areal Force(�����ܳ�������ϲ�ѭ��)
%�������С����Ka*(A_i-A_0)������ֱ�ڶ���������ھӶ��������ָ��ϸ�����
F_a = zeros(Nv,2); %F_a��һ��Nvx2�����飬ÿһ�ж�Ӧһ�����������õ���������ܺ�
for i = 1:Nc
    vList = cell_v{i};
    % �����������С
    polyin = polyshape(vertices(vList, :));
    Ai = area(polyin);
    fa = Ka*(Ai-A0);
    for j = 1:length(vList)
        % ���㶥��j��������ķ����ɶ���j���ھ�ϸ������
        idx = vList(j);
        coord = vertices(idx, :);
        nb_idx = vNVI_v{idx};
        nb_coord = vertices(nb_idx, :); % ���������j�������ָ���ھӶ��������
        line = nb_coord(1, :) - nb_coord(2, :);
        dir = [line(2),-line(1)];
        if isinterior(polyin,dir + coord) % ȷ�������� 
            dir = -dir;
        end
        F_a(idx, :) = F_a(idx, :) + fa*dir;
    end
end
clear i vList j Ai fa nb_idx coord idx nb_coord dir line polyin

%% �ӹ��ͼ����ܳ���F_c : Contraction Force
%�ܳ�����С����Kc*L_i, �������������ڱߵĽ�ƽ����ָ��ϸ���ڲ�
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
        if ~isinterior(polyin,dir + coord) %ȷ��������
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
    % ������������a��b �Ľ�ƽ��������������Ĭ����a b �����
    %   input: a,b: 1x2 ����������
    %   output: dir: ��ƽ�������� 1x2����
    dir = (a/norm(a) + b/norm(b))/norm(a/norm(a) + b/norm(b));

    if norm(dir)==0
        dir = [a(2),-a(1)];
    end
end
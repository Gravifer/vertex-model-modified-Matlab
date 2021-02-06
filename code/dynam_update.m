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
s = geom.s;

Ka = param.Ka;
Kc = param.Kc;
A0 = param.A0;
%% �ӹ��ͼ��������F_a : Areal Force(�����ܳ�������ϲ�ѭ��)
%�������С����-Ka*s(A-A0)r_norm������ֱ�ڶ���������ھӶ��������ָ��ϸ�����,
%�ο����ף�[Liu,Z.Y.2020]Mesoscopic dynamic model of epithelial cell division with cell-cell junction effects
F_a = zeros(Nv,2); %F_a��һ��Nvx2�����飬ÿһ�ж�Ӧһ�����������õ���������ܺ�
for i = 1:Nc
    vList = cell_v{i};
    % �����������С
    polyin = polyshape(vertices(vList, :));
    Ai = area(polyin);
    for j = 1:length(vList)
        % ���㶥��j��������ķ����ɶ���j���ھ�ϸ������
        idx = vList(j);
        coord = vertices(idx, :);
        nb_idx = vNVI_v{idx};
        nb_coord = vertices(nb_idx, :); 
        s_plus = nb_coord(1,:) - coord;
        s_minus = nb_coord(2,:) - coord;
        s = 0.5 * (norm(s_plus) + norm(s_minus));
        line = (s_plus - s_minus)/norm(s_plus - s_minus);
        dir = [line(2),-line(1)];
        if ~isinterior(polyin,(dir + coord)*0.01) % ȷ�������ڣ��������շ�����
            dir = -dir;
        end
        F_a(idx, :) = F_a(idx, :) + (-Ka*s*(Ai-A0)*dir - param.P*param.H*dir);
    end
end
clear i vList polyin Ai j idx coord nb_idx nb_coord s_plus s_minus s line dir

%% �ӹ��ͼ����ܳ���F_c : Contraction Force
%�ܳ�����С����-Kc*s_minus��-Kc*s_plus, �������������ڱ�ָ���ھӶ���
%�ο����ף�[Liu,Z.Y.2020]Mesoscopic dynamic model of epithelial cell division with cell-cell junction effects
F_c = zeros(Nv,2);
for i = 1:Nc
    vList = cell_v{i};
    for j = 1:length(vList)
        idx = vList(j);
        coord = vertices(idx,:);
        nb_idx = vNVI_v{idx};
        nb_coord = vertices(nb_idx,:);
        s_plus = nb_coord(1,:) - coord;
        s_minus = nb_coord(2,:) - coord;
        F_c(idx,:) = F_c(idx,:) + (Kc*(s_plus + s_minus));
    end
end
clear i vList j idx coord nb_idx nb_coord s_plus s_minus

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
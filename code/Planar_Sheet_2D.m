function Planar_Sheet_2D(label)

global param geom
switch label
    case 'hexagonal'
        nx = param.nx; 
        ny = param.ny;
        distx = param.distx;
        disty = param.disty;
        noise = param.noise;

        x = 0:distx:(nx+1)*distx;
        y = 0:disty:(ny+1)*disty;
        [X,Y] = meshgrid(x,y);

        for i = 1:(nx+1)
            if mod(i,2)
                Y(:,i) = Y(:,i) + disty*0.5;
            end
        end

        CellCenter = [];
        for i = 1:(nx+1)
            for j = 1:(ny+1)
                CellCenter = cat(1,CellCenter,[X(i,j),Y(i,j)]);
            end
        end
        [V,C] = voronoin(CellCenter);

        V(1,:)= [];
        flag = boolean(zeros(length(C),1));
        for i = 1:length(C)
            list = C{i};
            list = list - 1;
            C{i} = list;
            if length(list) > 2 && isempty(find(~list)) % list 长度不能低于3，并且不能包含0指标
                flag(i) = true;
            end
        end
        C = C(flag);
        geom.vertices = V;
        geom.cell_v = C;
        CellVisualization(geom);
        close

        clear C CellCenter flag i j list V x X y Y
end
end
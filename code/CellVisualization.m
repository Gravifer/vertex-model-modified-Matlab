% CELLCOLORATION   Color the cells in 2D space.
%
%   DESCRIPTIONS:
%     Color the cells within an epithelia.
%
%   INPUTS:
%     - vertices : Nv-by-2 array of vertices' positions
%     - cell_v   : Nv-by-1 cell array of which vetices consist of a cell,
%     vertices are aligned anticlockwise.
%
%   COPYRIGHT:
%      Author : Jia Ziyao(Jiazy17@mails.tsinghua.edu.cn)
%      Update : 2021-1-1

function CellVisualization(varargin)
    global geom
    fig = figure;
    
%     if length(varargin) == 2    %vertices,cell_v
%         Vertices = varargin{1};
%         Faces = varargin{2};
%        for k = 1:length(Faces)
%               patch('vertices',Vertices,'Faces', Faces{k},...
%               'EdgeColor','b','FaceColor','r','LineWidth',2,'FaceAlpha',0.2);
%        end
%     else
%         ...
%     end
    Vertices = geom.vertices;
    Faces = geom.cell_v;
    for k = 1:length(Faces)
          patch('vertices',Vertices,'Faces', Faces{k},...
          'EdgeColor','b','FaceColor','r','LineWidth',2,'FaceAlpha',0.2);
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  High level A* planning which returns the body path of the robot
% 
%  Auther: Tianyu Chen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ rob_path_new ] = HighLevelPlan(CostMap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1 % random obstacles
% ----------------step 1-------------------
% given (1) the target 
%       (2) obstacle map
%       (3) robot initial position
% the map is 10*10
RANDOM = 1;
x_map   = 10;
y_map   = 10;
obs_num = 40;
tar_num = 1;
rob_num = 1;
CostMap = 1;
% rob_mat the current position of the robot
[ map, obs_mat, tar_mat, rob_mat ] = init_map(x_map, y_map, obs_num, tar_num, rob_num, RANDOM, CostMap);
end

if nargin < 2
RANDOM = 0;
x_map   = 10;
y_map   = 10;
obs_num = 0;
tar_num = 1;
rob_num = 1;
% rob_mat the current position of the robot
[ map, obs_mat, tar_mat, rob_mat ] = init_map(x_map, y_map, obs_num, tar_num, rob_num, RANDOM, CostMap);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----------------step 2------------------
% initialize the cost fcn array, like hn, gn, 
% hn --- cost of travaling to the node
% gn --- distance between current node and the goal
% fn --- sum of hn and gn
% OPEN --- open nodes list
% | IS in the list? | current_x | current_y | parrent_x | parrent_y | hn |
% gn | fn |
% CLOSED --- closed nodes list
% | x_val | y_val |
OPEN   = init_OPEN(rob_mat, tar_mat); % initialize OPEN
CLOSED = [obs_mat; rob_mat]; % initialize CLOSED

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----------------step 3------------------
% while loop reapeat step 2 until the node reaches the target
num = 0; % count how many iterations A* takes
f1 = 0; % f1 = 1 indicates A* reaches its target node
NoPath = 0;
while (f1 == 0) % not reach target node
    % find next node with lowest fn cost value
    [next_node, idx1, f2] = find_next(OPEN);
    if f2 == 0
        fprintf('cant find solution.\n');
        NoPath = 1;
        break;
    end
    hn = OPEN(idx1, 6);
    
    % search the nodes beside rob_mat
    [OPEN_candidate, f3] = do_search(next_node, tar_mat, hn, CLOSED, map);
    
    % upgrade OPEN and CLOSED list
    OPEN = upgrade_OPEN(OPEN, OPEN_candidate, idx1, f3);
    CLOSED = upgrade_CLOSED(next_node, CLOSED);

    % check whether reaches the target
    [f1, idx2] = check_OPEN(OPEN, tar_mat);
    num = num + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------step 4---------------------
    figure(2)
if NoPath == 0
    % take the path out
    rob_path = path(OPEN, idx2, rob_mat);
    [c1, ~] = size(rob_path);
    fprintf('A* search uses %d steps to reach the target.\n', c1-1); 
    scatter(rob_path(:,2)+0.5, rob_path(:, 1)+0.5, 'b');
    hold on
    plot(rob_path(:, 2)+0.5, rob_path(:, 1)+0.5, 'b');
    hold on
end
    scatter(obs_mat(:, 2)+0.5, obs_mat(:, 1)+0.5, 'r');
    hold on 
    grid on
    scatter(tar_mat(2)+0.5, tar_mat(1)+0.5, 'g');
    hold on
    title('A* search')
    axis([1 11 1 11]);

%   process rob_path
    [c1, c2] = size(rob_path);
    rob_path_new = zeros(c1, c2);
    for i = 1:c1
        rob_path_new(i, :) = rob_path(c1 + 1 - i, :);
    end
    % rob_path_new = diff(rob_path_new)*0.2; % *StepDistance
    
end
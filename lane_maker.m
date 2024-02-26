clear all
close all
clc

%% Change setting
dist_cut = 0;
lane_width = 12;
data = readmatrix('path.csv');

%% init
total_path = [data(2:end, 1), data(2:end, 2)];
prev = [total_path(1,1), total_path(1, 2)];
count = 1;

%% path cutting
for i = 1:length(total_path)

    curr = [total_path(i,1),total_path(i,2)];
    dist =norm(curr-prev);
    
    if dist >= dist_cut
        mid_path(count).x = total_path(i,1);
        mid_path(count).y = total_path(i,2);
        prev = [total_path(i,1), total_path(i, 2)];
        count = count+1;
    end
end

%% make lane
for j = 1:length(mid_path)-1
    
    if j >= 1
        py = mid_path(j+1).y - mid_path(j).y;
        px = mid_path(j+1).x - mid_path(j).x;
        theta = atan2(py, px);

        in_x = lane_width/2;
        in_y = 0;

        out_x = -lane_width/2;
        out_y = 0;

        inline(j).x = mid_path(j).x + in_x*sin(-theta) + in_y*cos(-theta);
        inline(j).y = mid_path(j).y + in_x*cos(-theta) - in_y*sin(-theta);

        outline(j).x = mid_path(j).x + out_x*sin(-theta) + out_y*cos(-theta);
        outline(j).y = mid_path(j).y + out_x*cos(-theta) - out_y*sin(-theta);

    end
end
        

%% plot result
figure(1)
hold on
plot(data(2:end, 1), data(2:end, 2), LineWidth=2, Color='b', LineStyle='-')
plot([inline.x], [inline.y], LineWidth=2, Color='g', LineStyle='-')
plot([outline.x], [outline.y], LineWidth=2, Color='g', LineStyle='-')

%% save csv
writetable(struct2table(inline), 'inline.csv')
writetable(struct2table(outline), 'outline.csv')

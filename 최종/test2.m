% 0704

clear;
drone = ryze('Tello');

takeoff(drone);
pause(1);

% 드론 카메라 중심의 y 값을 200 으로 설정
center_point = [480, 200];
cameraObj = camera(drone);

% 1 st stage
% 드론 카메라 중심이 링 너머 빨간색 색상 마크의 중심과 일치하도록 조정
dif = 40;
while true
    frame = snapshot(cameraObj);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0, 0.07);
    move_to_center(drone, x, y, dif);
 
    if isnan(x) || isnan(y)
        disp('No red square detected.');
        break;
    end
 
    centroid = [x, y];
    dis = centroid - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        disp('Centered successfully!');
        break;
    end
end

moveforward(drone, 'Distance', 3.5, 'Speed', 0.85);
pause(1.5);

% 2 nd stage
turn(drone, deg2rad(130));
pause(2);

moveforward(drone, 'Distance', 3, 'Speed', 1);
pause(1);

% 드론 카메라 중심이 링 너머 초록색 색상 마크의 중심과 일치하도록 조정
dif = 30;
while true
    frame = snapshot(cameraObj);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0.24, 0.34);
    move_to_center(drone, x, y, dif);
    
    if isnan(x) || isnan(y)
        disp('No green square detected.');
        break;
    end
    
    centroid = [x, y];
    dis = centroid - center_point;
    
    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        disp('Centered successfully!');
        break;
    end
end

moveforward(drone, 'Distance', 2.1, 'Speed', 1);
pause(1.5);

% 3 rd stage
turn(drone, deg2rad(-130));
pause(1);

moveforward(drone, 'Distance', 2.6, 'Speed', 1);
pause(1);

% 드론 카메라 중심이 링 너머 보라색 색상 마크의 중심과 일치하도록 조정
dif = 30;
while true
    frame = snapshot(cameraObj);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0.70, 0.79);
    move_to_center(drone, x, y, dif);
    
    if isnan(x) || isnan(y)
        disp('No purple square detected.');
        break;
    end
    
    centroid = [x, y];
    dis = centroid - center_point;
    
    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        disp('Centered successfully!');
        break;
    end
end

% 4 th stage
turn(drone, deg2rad(215));
pause(1);

flag = 0;
move_cnt = 0;

while true
    frame = snapshot(cameraObj);
    [x, y, boundingBox] = detect_from_frame(frame);

    % 파란색 가림막막이 인식되지 않는 경우 while loop 중단
    if isempty(boundingBox)
        disp("no bounding box")
        break;
    end

    centroid = [x, y];
    move_to_center(drone, x, y, 50);
    move_cnt = move_cnt + 1;
    
    % 드론이 4 번 이상 이동한 경우 while loop 중단
    if move_cnt > 3
        break;
    end
    
    dis = centroid - center_point;
    if(abs(dis(1)) <= 50 && abs(dis(2)) <= 50)
        disp("3.85m Centered successfully!");
        break;
    end
end

moveforward(drone, 'Distance', 2.3, 'Speed', 0.9);
pause(1);

% 드론 카메라 중심이 링 너머 빨간색 색상 마크의 중심과 일치하도록 조정
dif = 40;
while true
    frame = snapshot(cameraObj);
    dif = dif + 20;

    [x, y] = square_detect(frame, 0, 0.06);
    move_to_center(drone, x, 200, dif);
    
    if isnan(x) || isnan(y)
        disp('No red square detected.');
        break;
    end
    
    centroid = [x, 200];
    dis = centroid - center_point;

    if abs(dis(1)) <= dif
        disp('Centered successfully!');
        break;
    end
end
moveforward(drone, 'Distance', 1.55, 'Speed', 0.85);
pause(1);

land(drone);

% 파란색 가림막 링의 중심 좌표를 return
function [center_x, center_y, boundingBox] = detect_from_frame(frame)
    blue_th_down = 0.55;
    blue_th_up = 0.65;

    tohsv = rgb2hsv(frame);
    h = tohsv(:,:,1);
    s = tohsv(:,:,2);

    toBinary = (blue_th_down < h) & (h < blue_th_up) & (s > 0.5);
    filtered = imcomplement(toBinary);

    area = regionprops(filtered, 'BoundingBox', 'Area');
    tmpArea = 0;
    boundingBox = [];
    
    for j = 1:length(area)
        tmpBox = area(j).BoundingBox;

        % 드론 카메라boundingBox
        if(tmpBox(3) == size(frame, 2) || tmpBox(4) == size(frame, 1)) %BoundingBox 예외 처리
            continue;
        else
            if tmpArea <= area(j).Area
                tmpArea = area(j).Area;
                boundingBox = area(j).BoundingBox;
            end
        end
    end
    
    % boundingBox 가 존재하는 경우 파란색 가림막 링의 중심 좌표 추출
    if ~isempty(boundingBox)
        center_x = boundingBox(1) + (0.5 * boundingBox(3));
        center_y = boundingBox(2) + (0.5 * boundingBox(4));
        
        inner_region = imcrop(frame, boundingBox);
        gray_inner = rgb2gray(inner_region);
        edges_inner = edge(gray_inner, 'Canny');
        
        [centers, radii] = imfindcircles(edges_inner, [20 100]); % 반지름 범위 조정 가능
        
        if ~isempty(centers)
            % 크기가 가장 큰 원의 중심 좌표 추출
            [~, max_idx] = max(radii);
            circle_center = centers(max_idx, :);
            
            center_x = boundingBox(1) + circle_center(1);
            center_y = boundingBox(2) + circle_center(2);
        end
    else
        center_x = NaN;
        center_y = NaN;
    end
end

function move_to_center(drone, target_x, target_y, dif)
    % 드론 카메라의 중심
    center_point = [480, 200]; % 예시 값 (드론 카메라의 해상도에 따라 다를 수 있음)
    
    % 목표 지점과 드론 카메라 중심의 차이 계산
    dis = [target_x, target_y] - center_point;

    % 드론 이동 제어
    if(abs(dis(1)) <= dif && abs(dis(2)) <= dif)
        disp("Find Center Point!");
    elseif(abs(dis(1)) > 40)
        if dis(1) < 0
            disp("Move left")
            moveleft(drone, 'Distance', 0.2, 'Speed', 1);
        else
            disp("Move right")
            moveright(drone, 'Distance', 0.2, 'Speed', 1);
        end
    end
    if(abs(dis(2)) > 40)
        if dis(2) < 0
            disp("Move up")
            moveup(drone, 'Distance', 0.2, 'Speed', 1);
        else
            disp("Move down")
            movedown(drone, 'Distance', 0.2, 'Speed', 1);
        end
    end
    pause(1); % 잠시 멈춤
end

function [center_x, center_y] = square_detect(frame, th_down, th_up)

    % RGB 이미지를 HSV로 변환
    tohsv = rgb2hsv(frame);
    h = tohsv(:,:,1);
    s = tohsv(:,:,2);
    v = tohsv(:,:,3);

    % 초록색 영역을 이진화 이미지로 생성
    toBinary = (th_down < h) & (h < th_up) & (s > 0.4) & (v > 0.2);

    % 영역 검출
    area = regionprops(toBinary, 'BoundingBox', 'Area');

    % 가장 큰 영역 검출 (전체 이미지가 아닌 영역)
    tmpArea = 0;
    boundingBox = [];
    for j = 1:length(area)
        tmpBox = area(j).BoundingBox;
        if tmpBox(3) < size(frame, 2) * 0.9 && tmpBox(4) < size(frame, 1) * 0.9
            if tmpArea <= area(j).Area
                tmpArea = area(j).Area;
                boundingBox = area(j).BoundingBox;
            end
        end
    end
    if isempty(boundingBox)
        center_x = NaN;
        center_y = NaN;
        return;
    end
    % Bounding box의 중심 좌표 계산
    center_x = boundingBox(1) + (0.5 * boundingBox(3));
    center_y = boundingBox(2) + (0.5 * boundingBox(4));
end

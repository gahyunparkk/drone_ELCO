% 0704

clear; 
% 드론 객체 생성 (drone 변수는 사용자의 환경에 맞게 설정)
drone = ryze('Tello');

% 드론 이륙
takeoff(drone);
pause(1);

% 드론의 카메라 중심
center_point = [480, 200];
cameraObj = camera(drone);
move_cnt = 0;

while true
    % 드론의 현재 프레임 가져오기
    frame = snapshot(cameraObj);
    [x, y, boundingBox] = detect_from_frame(frame);
    %imshow(frame);

    % 파란색 테두리가 감지되지 않으면 while 루프 중단
    if isempty(boundingBox)
        disp("no bounding box")
        break;
    end
    
    disp(boundingBox);

    % 사각형 중심 좌표
    centroid = [x, y];

    % 목표 지점으로 드론 이동
    move_to_center(drone, x, y, 60);
    disp(move_cnt);
    move_cnt = move_cnt + 1;
    if move_cnt > 2
        break;
    end

    % 중심 좌표가 맞춰졌는지 확인
    dis = centroid - center_point;
    if(abs(dis(1)) <= 60 && abs(dis(2)) <= 60)
        disp("3.5m Centered successfully!");
        break;
    end
end
moveforward(drone, 'Distance', 3.5, 'Speed', 0.85);
pause(1.5);


%빨간색 사각형 확인
% dif = 30;
% while true
%     frame = snapshot(cameraObj);
%     imshow(frame);
%     dif = dif + 15;
% 
%     % 빨간색 사각형 검출
%     [x, y] = square_detect(frame, 0, 0.05);
%     move_to_center(drone, x, 200, dif);
% 
%     if isnan(x) || isnan(y)
%         disp('No red square detected.');
%         break;
%     end
% 
%     % 중심 좌표 차이 계산
%     centroid = [x, 200];
%     dis = centroid - center_point;
% 
%     % 중심에 도달했는지 확인
%     if abs(dis(1)) <= dif
%         disp('Centered successfully!');
%         break;
%     end
% end


% moveforward(drone, 'Distance', 1.6, 'Speed', 0.75);
% pause(1);

% 오른쪽 130도 회전
turn(drone, deg2rad(130));
pause(2);

% 앞으로 5.1미터
moveforward(drone, 'Distance', 3, 'Speed', 1);
pause(1);
%초록색 사각형 중심 확인
dif = 30;
while true
    frame = snapshot(cameraObj);
    %imshow(frame);
    dif = dif + 15;

    % 초록색 사각형 검출
    [x, y] = square_detect(frame, 0.24, 0.34);
    move_to_center(drone, x, y, dif);
    
    if isnan(x) || isnan(y)
        disp('No green square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    centroid = [x, y];
    dis = centroid - center_point;
    
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        disp('Centered successfully!');
        break;
    end
end
moveforward(drone, 'Distance', 2.1, 'Speed', 1);
pause(1.5);

% 왼쪽으로 130도 회전
turn(drone, deg2rad(-130));
pause(1);

% 2.7미터 전진
moveforward(drone, 'Distance', 2.6, 'Speed', 1);
pause(1);
%보라색 사각형 확인
dif = 30;
while true
    frame = snapshot(cameraObj);
    %imshow(frame);
    dif = dif + 15;

    % 보라색 사각형 검출
    [x, y] = square_detect(frame, 0.70, 0.79);
    
    if isnan(x) || isnan(y)
        disp('No purple square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    centroid = [x, y];
    dis = centroid - center_point;
    move_to_center(drone, x, y, dif);
    
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        disp('Centered successfully!');
        break;
    end
end

% 오른쪽으로 215도 회전
turn(drone, deg2rad(215));
pause(1);

% 3.85미터 전진
flag = 0;
move_cnt = 0;

while true
    % 드론의 현재 프레임 가져오기
    frame = snapshot(cameraObj);
    [x, y, boundingBox] = detect_from_frame(frame);
    %imshow(frame);
    % 파란색 테두리가 감지되지 않으면 while 루프 중단
    if isempty(boundingBox)
        disp("no bounding box")
        break;
    end
        
    disp(boundingBox);
    %if (960/boundingBox(3))>7 || (720/boundingBox(4))>5.5
    %    disp("bounding box too small")
    %    break;
    %end

    % 사각형 중심 좌표
    centroid = [x, y];
    % 목표 지점으로 드론 이동
    move_to_center(drone, x, y, 50);
    disp(move_cnt);
    move_cnt = move_cnt + 1;
    if move_cnt > 3
        break;
    end
    % 중심 좌표가 맞춰졌는지 확인
    dis = centroid - center_point;
    if(abs(dis(1)) <= 50 && abs(dis(2)) <= 50)
        disp("3.85m Centered successfully!");
        break;
    end
end
moveforward(drone, 'Distance', 2.3, 'Speed', 1);
pause(1);

%빨간색 사각형 확인
dif = 40;
while true
    frame = snapshot(cameraObj);
    %imshow(frame);
    dif = dif + 20;

    % 빨간색 사각형 검출
    [x, y] = square_detect(frame, 0, 0.06);
    move_to_center(drone, x, 200, dif);
    
    if isnan(x) || isnan(y)
        disp('No red square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    centroid = [x, 200];
    dis = centroid - center_point;
    
    disp(dif);
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= dif
        disp('Centered successfully!');
        break;
    end
end
moveforward(drone, 'Distance', 1.55, 'Speed', 0.85);
pause(1);

% 드론 착륙
land(drone);

% 프레임에서 중심 좌표 검출 함수
function [center_x, center_y, boundingBox] = detect_from_frame(frame)
    % 파란색 테두리를 감지하기 위한 HSV 색상 범위 설정
    blue_th_down = 0.55; % 파란색 하한 값 (Hue)
    blue_th_up = 0.65;   % 파란색 상한 값 (Hue)

    % RGB 이미지를 HSV 이미지로 변환
    tohsv = rgb2hsv(frame); % RGB to HSV
    h = tohsv(:,:,1); % Hue 채널
    s = tohsv(:,:,2); % Saturation 채널

    % 파란색 영역 이진화
    toBinary = (blue_th_down < h) & (h < blue_th_up) & (s > 0.5);
    filtered = imcomplement(toBinary); % 반전 이진화

    % 파란색 테두리 객체의 속성 추출
    area = regionprops(filtered, 'BoundingBox', 'Area');
    tmpArea = 0;
    boundingBox = []; % boundingBox 변수 초기화
    for j = 1:length(area)
        tmpBox = area(j).BoundingBox;
        if(tmpBox(3) == size(frame, 2) || tmpBox(4) == size(frame, 1)) %BoundingBox 예외 처리
            continue;
        else
            if tmpArea <= area(j).Area
                tmpArea = area(j).Area;
                boundingBox = area(j).BoundingBox;
            end
        end
    end
    
    % boundingBox가 존재하면 중심 좌표 계산
    if ~isempty(boundingBox)
        % 파란색 테두리의 중심 좌표
        center_x = boundingBox(1) + (0.5 * boundingBox(3));
        center_y = boundingBox(2) + (0.5 * boundingBox(4));
        
        % 파란색 테두리 내부 영역을 추출
        inner_region = imcrop(frame, boundingBox);
        
        % 내부 영역에서 원 감지
        gray_inner = rgb2gray(inner_region); % 그레이스케일 변환
        edges_inner = edge(gray_inner, 'Canny'); % 엣지 검출
        
        % Hough 변환을 이용한 원 검출
        [centers, radii] = imfindcircles(edges_inner, [20 100]); % 반지름 범위 조정 가능
        
        if ~isempty(centers)
            % 가장 큰 원의 중심 좌표 선택
            [~, max_idx] = max(radii);
            circle_center = centers(max_idx, :);
            
            % 원 중심의 절대 좌표 계산
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
        disp('No green square detected.');
        center_x = NaN;
        center_y = NaN;
        return;
    end
    % Bounding box의 중심 좌표 계산
    center_x = boundingBox(1) + (0.5 * boundingBox(3));
    center_y = boundingBox(2) + (0.5 * boundingBox(4));

    % 검출된 Bounding box와 중심 좌표를 표시
    hold on
    rectangle('Position', boundingBox, 'EdgeColor', '#F59F00', 'LineWidth', 2);
    plot(center_x, center_y, 'o')
    title(['Center X: ', num2str(center_x), ', Center Y: ', num2str(center_y)])
    axis on
    grid on
end

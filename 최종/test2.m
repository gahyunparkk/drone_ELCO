clear;
% 드론 객체 생성 (drone 변수는 사용자의 환경에 맞게 설정)
drone = ryze('Tello');

% 드론 이륙
takeoff(drone);
pause(1);

% 위로 조금 이동
moveup(drone, 'Distance', 0.3, 'Speed', 1);
pause(2);

% 드론의 카메라 중심
center_point = [480, 260];
cameraObj = camera(drone);
preboundingBox3=0; preboundingBox4=0;
flag = 0;

% 앞으로 파란색 천막 중심 잡으면서 조금씩 이동
for cnt = 0:4
    move_cnt = 0;

    while true
        % 드론의 현재 프레임 가져오기
        frame = snapshot(cameraObj);
        [x, y, boundingBox] = detect_from_frame(frame);
        imshow(frame);

        % 파란색 테두리가 감지되지 않으면 while 루프 중단
        if isempty(boundingBox)
            disp("no bounding box")
            break;
        end
        
        % 바운딩박스의 크기사 작아지면 = 천막을 지나치면 루프 종료 및 계속 직진
        if flag == 1 || boundingBox(3)<preboundingBox3 || boundingBox(4)<preboundingBox4
            flag = 1;
            disp("flag = 1")
            break;
        end
        disp(boundingBox);

        %바운딩박스의 크기가 너무 작으면 비교 안하고 앞으로 전진
        if (960/boundingBox(3))>7 || (720/boundingBox(4))>5.5
            disp("bounding box too small")
            break;
        end

        % 사각형 중심 좌표
        centroid = [x, y];

        % 목표 지점으로 드론 이동
        move_to_center(drone, x, y);
        disp(move_cnt);
        move_cnt = move_cnt + 1;
        if move_cnt > 3
            break;
        end

        % 중심 좌표가 맞춰졌는지 확인
        dis = centroid - center_point;
        if(abs(dis(1)) <= 40 && abs(dis(2)) <= 40)
            disp("3.7m Centered successfully!");
            break;
        end
    end
    moveforward(drone, 'Distance', 0.7, 'Speed', 1);
    pause(2);

    % 이전값 업데이트
    if ~isempty(boundingBox)
        preboundingBox3 = boundingBox(3);
        preboundingBox4 = boundingBox(4);
    end
    if flag == 1
        break;
    end
end

%빨간색 사각형 확인
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    
    % 빨간색 사각형 검출
    [center_x, center_y] = square_detect(frame, 0, 0.05);
    
    if isnan(center_x) || isnan(center_y)
        disp('No green square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    dis = [center_x, center_y] - center_point;
    
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= 40 && abs(dis(2)) <= 40
        disp('Centered successfully!');
        break;
    end
end
moveback(drone, 'Distance', 0.2, 'Speed', 1);

% 오른쪽 130도 회전
turn(drone, deg2rad(130));
pause(2);

% 앞으로 6.2미터
moveforward(drone, 'Distance', 3, 'Speed', 1);
while true
    % 드론의 현재 프레임 가져오기
    frame = snapshot(cameraObj);
    [x, y, boundingBox] = detect_from_frame(frame);
    imshow(frame);
    
    % 사각형 중심 좌표
    centroid = [x, y];
    disp(centroid);
        
    % 목표 지점으로 드론 이동
    move_to_center(drone, x, y);
    
    % 중심 좌표가 맞춰졌는지 확인
    dis = centroid - center_point;
    if(abs(dis(1)) <= 35 && abs(dis(2)) <= 35)
        disp("6.2m Centered successfully!");
        pause(2);
        break;
    end
end
moveforward(drone, 'Distance', 3, 'Speed', 1);
%초록색 사각형 중심 확인
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    
    % 초록색 사각형 검출
    [center_x, center_y] = square_detect(frame, 0.33, 0.44);
    
    if isnan(center_x) || isnan(center_y)
        disp('No green square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    dis = [center_x, center_y] - center_point;
    
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= 40 && abs(dis(2)) <= 40
        disp('Centered successfully!');
        break;
    end
end
moveback(drone, 'Distance', 0.2, 'Speed', 1);

% 왼쪽으로 130도 회전
turn(drone, deg2rad(-130));
pause(2);

% 3.7미터 전진
moveforward(drone, 'Distance', 3.7, 'Speed', 0.5);
pause(2);
%파란색 사각형 확인
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    
    % 파란색 사각형 검출
    [center_x, center_y] = square_detect(frame, 0.55, 0.65);
    
    if isnan(center_x) || isnan(center_y)
        disp('No green square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    dis = [center_x, center_y] - center_point;
    
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= 40 && abs(dis(2)) <= 40
        disp('Centered successfully!');
        break;
    end
end
moveback(drone, 'Distance', 0.2, 'Speed', 1);

% 오른쪽으로 215도 회전
turn(drone, deg2rad(215));
pause(2);

% 4.5미터 전진
flag = 0;
preboundingBox3 = 0; preboundingBox4 = 0;
for cnt = 0:4
    move_cnt = 0;

    while true
        % 드론의 현재 프레임 가져오기
        frame = snapshot(cameraObj);
        [x, y, boundingBox] = detect_from_frame(frame);
        imshow(frame);

        % 파란색 테두리가 감지되지 않으면 while 루프 중단
        if isempty(boundingBox)
            disp("no bounding box")
            break;
        end
        
        if flag == 1 || boundingBox(3)<preboundingBox3 || boundingBox(4)<preboundingBox4
            flag = 1;
            disp("flag = 1")
            break;
        end
        disp(boundingBox);
        if (960/boundingBox(3))>7 || (720/boundingBox(4))>5.5
            disp("bounding box too small")
            break;
        end

        % 사각형 중심 좌표
        centroid = [x, y];

        % 목표 지점으로 드론 이동
        move_to_center(drone, x, y);
        disp(move_cnt);
        move_cnt = move_cnt + 1;
        if move_cnt > 3
            break;
        end

        % 중심 좌표가 맞춰졌는지 확인
        dis = centroid - center_point;
        if(abs(dis(1)) <= 40 && abs(dis(2)) <= 40)
            disp("4.5m Centered successfully!");
            break;
        end
    end
    moveforward(drone, 'Distance', 0.88, 'Speed', 1);
    pause(2);
    if ~isempty(boundingBox)
        preboundingBox3 = boundingBox(3);
        preboundingBox4 = boundingBox(4);
    end
end

%빨간색 사각형 확인
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    
    % 초록색 사각형 검출
    [center_x, center_y] = square_detect(frame, 0, 0.05);
    
    if isnan(center_x) || isnan(center_y)
        disp('No green square detected.');
        break;
    end
    
    % 중심 좌표 차이 계산
    dis = [center_x, center_y] - center_point;
    
    % 중심에 도달했는지 확인
    if abs(dis(1)) <= 40 && abs(dis(2)) <= 40
        disp('Centered successfully!');
        break;
    end
end
moveback(drone, 'Distance', 0.2, 'Speed', 1);

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

function move_to_center(drone, target_x, target_y)
    % 드론 카메라의 중심
    center_point = [480, 260]; % 예시 값 (드론 카메라의 해상도에 따라 다를 수 있음)
    
    % 목표 지점과 드론 카메라 중심의 차이 계산
    dis = [target_x, target_y] - center_point;

    % 드론 이동 제어
    if(abs(dis(1)) <= 40 && abs(dis(2)) <= 40)
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

function [center_x, center_y] = square_detect(th_down, th_up)

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

2024 미니드론 자율비행 경진대회
===============

- 2024 미니드론 자율비행 경진대회 기술 워크샵
- 주최 : 대한전기학회
- 팀명 : ELCO

(사진 1 : 강의실 사진)

## 0. 목차

1. 개요
2. 대회 진행 전략
3. 알고리즘 및 소스 코드 설명
4. 시도한 알고리즘

## 1. 개요

### 1.1. 경로 상세 규격

(사진 2 : 경로 사진)

- 가림막 링
  - 1차 링 지름 : 57 cm
  - 2차 링 지름 : 46 cm
  - 3차 링 지름 : 46 cm
  - 4차 링 지름 : 52 cm
  - 링 중심의 높이 : 80 ~ 100 cm
 
- 색상 hsv 의 h 범위
  - 빨간색 색상 마크 : 0 ~ 0.07
  - 초록색 색상 마크 : 0.24 ~ 0.34
  - 보라색 색상 마크 : 0.70 ~ 0.79
  - 파란색 가림막 : 0.55 ~ 0.75

## 2. 대회 진행 전략

### 2.1. 

* 정사각형의 색상 추출 및 드론 제어:
  * 1, 2, 3단계에서, 천막 넘어서 보이는 정사각형의 색상을 HSV로 값을 받은 다음, 드론을 중심에 위치하게 한다
  * 만약 정사각형이 보이지 않을 경우엔, "No (color) square detected" 문구 출력 후, 경로를 따라 계속 주행, 다음 단계에서 중심을 맞춘다.
 
* 파란색 천막의 중심 계산 및 드론 제어:
   * 3단계 회전 후, 4단계 경로를 이동하기 전, 천막의 중심을 찾아서 드론의 위치를 고정해준 다음, 이동하게 한다.
   * 만약 천막이 감지되지 않으면 "No bounding box" 문구를 출력하면서 이동을 한다.
   * 화면의 잡히는 천막의 비율을 비교해서, 만약 인식되는 천막이 너무 작으면 "Bounding box too small" 문구 출력 후, 이동한다.
 
* 드론 위치 조정 및 이동
   * 드론이 정사각형 또는 천막의 중심을 잡을 때, 화면에 잡히는 중심과 드론의 카메라의 중심을 비교해 오차값을 계산한다
   * 드론의 위치가 오차값보다 크면 상하좌우로 0.2m씩 움직여 중심을 잡는다
   * 링을 통과할 때 정확한 중심을 잡을 필요는 없어, 오차값을 드론이 중심을 잡을 때 마다 커지게 해 중심을 잡기 위해 반복하는 행동을 하지 않도록 하였다.

### 2.4. 드론 카메라 중심의 y 좌표를 360 이 아닌 200 으로 설정

- 드론 카메라 frame 의 x 좌표는 0 ~ 960, y 좌표는 0 ~ 720 이다. 드론 카메라 중심의 y 좌표를 360 으로 설정한 경우 드론이 위치해야 하는 곳에 비해 위쪽에 위치하는 문제가 발생했다. 드론 카메라가 정확히 정면이 아닌 약간 아래쪽을 향하기 때문이다.

- 드론이 위치해야 하는 곳에 정확히 위치하도록 하는 y 좌표를 찾기 위해 드론을 조금식 moveup 함수를 이용하여 드론을 위쪽으로 20 cm 씩 이동시키고 imshow 함수를 이용하여 이미지를 표시했다.

- 드론 카메라가 정확히 정면을 향하지 않고 약간 아래쪽을 향한다. 드론 카메라 중심의 y 좌표를 240 으로 설정한 경우, 드론이 링 또는 색상 마크의 중심에 위치하도록 조정할 때 드론이 위치해야 하는 중심에 비해 위쪽에 위치하는 문제가 발생했다.
- moveup 함수를 이용하여 드론을 위쪽으로 20 cm 씩 이동하면서 

* 착륙 및 이동 경로의 y축
   * 드론의 카메라가 인식하는 중심과 실제 중심의 차이가 있어 실제 드론이 중심에 있을 때, 드론의 y축을 찾아야한다.
   * 조금씩 드론을 위로 띄우면서, 실제 링의 중심에 올 때 값을 찾아서 y축 중심을 200으로 설정했다.
   * 시간 단축을 위해 4단계 착륙하기 전 y축은 비교할 필요가 없다고 판단, y축을 200으로 고정 후 빨간색 정사각형의 중심과 비교 후 착륙한다.
 
## 3. 알고리즘 및 소스 코드 설명

* #### 드론 설정

   drone 변수 생성 및 중심 기준 선언
   
   cameraObj 변수 생성
   
   오차범위 dif = 40 선언
   
```
clear;
drone = ryze('Tello');

takeoff(drone);
pause(1);

% 드론 카메라 중심의 y 값을 200 으로 설정
center_point = [480, 200];
cameraObj = camera(drone);
dif = 40; 
```
   
* #### 1단계[링 통과]

   squzre_detect 함수 사용하면서 빨간색 정사각형의 x, y축 찾기

   빨간색의 hsv 값 범위를 0~0.06으로 조절절
   
   move_to_center 함수 사용하면서 드론의 위치 조정, 
   
   오차범위(시작할때 55, 한번 위치 조정할 때마다 15씩 증가) 안에 들어올때까지 무한반복
   
   만약 정사각형이 인식되지 않으면 오류메세지 출력 후 앞으로 이동

   빨간색 마크가 화면 중심에 오면 파란색 링 인식 후 링 안에 들어와있는지 판단, 링 밖에 벗어나있으면 드론 화면과 링의 중심 맞추고 빨간색 사각형 다시 인식

   빨간색 마크가 인식이 되지 않으면 링 먼저 인식 후 화면과 중심 일치하도록 조정, 링이 인식되지 않으면 드론 후진하면서 링 인식 시도
   
```
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0, 0.06);
    [x1, y1, boundingBox] = detect_from_frame(frame);
 
    %빨간색 색상 마크가 인식이 되지 않았을 때 드론의 중심과 링의 중심 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No red square detected.');

        %링이 인식이 되지 않았을 때 후진 후 다시 인식
        while ~isempty(boundingBox)
            disp('No bounding box detected.');
            moveback(drone, 'Distance', 0.2, 'Speed', 1);
            pause(0.5);
            [x1, y1, boundingBox] = detect_from_frame(frame);
        end
        
        move_to_center(drone, x1, y1, dif);

        centroid = [x1, y1];
        dis = centroid - center_point;

        if abs(dis(1)) <= 100 && abs(dis(2)) <= 100
            disp('Centered successfully!');
            break;
        end
    end
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif 
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 3.5, 'Speed', 0.85);
pause(1.5);
```
  
* #### 2단계[130도 시계방향 회전 및 초록색 정사각형 중심 찾기]

    드론 130도 시계방향 회전 후 3.5m 전진
    * 텔로 비행시 최대 이동 가능 거리가 5m라 3.5m, 1.6m 나눠서 비행
    * 3.5m 이하로 비행하면 4단계 링이 인식되는 경우가 있어 3.5m로 선택

    초록색 마크의 hsv 값 0.24~0.34로 조절

    1단계와 마찬가지로 초록색 마크 인식이 되면 드론 카메라의 중심에 있는지 판단 후 링 안에 마크가 위치하는지 판단, 마크 또는 링 인식할 때/안될 때 예외처리

    초록색 마크와 링 인식 완료 후 남은 1.6m 전진
    
```
turn(drone, deg2rad(130));
pause(2);
 
moveforward(drone, 'Distance', 3.5, 'Speed', 1);
pause(1);
 
% 드론 카메라 중심이 링 너머 초록색 색상 마크의 중심과 일치하도록 조정
dif = 40;
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0.24, 0.34);
    [x1, y1, boundingBox] = detect_from_frame(frame);
 
    %초록색 색상 마크가 인식이 되지 않았을 때 드론의 중심과 링의 중심 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No green square detected.');

        %링이 인식이 되지 않았을 때 후진 후 다시 인식
        while ~isempty(boundingBox)
            disp('No bounding box detected.');
            moveback(drone, 'Distance', 0.2, 'Speed', 1);
            pause(0.5);
            [x1, y1, boundingBox] = detect_from_frame(frame);
        end
        
        move_to_center(drone, x1, y1, dif);

        centroid = [x1, y1];
        dis = centroid - center_point;

        if abs(dis(1)) <= 100 && abs(dis(2)) <= 100
            disp('Centered successfully!');
            break;
        end
    end
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 1.6, 'Speed', 1);
pause(1.5);
```   
    
  
* #### 3단계[130도 반시계방향 회전 및 보라색 정사각형 중심 찾기]

    드론 130도 반시계방향 회전 후 보라색 마크 인식

    보라색 마크의 hsv 값 0.70~0.79로 조절

    1단계와 마찬가지로 보라색 마크 인식이 되면 드론 카메라의 중심에 있는지 판단 후 링 안에 마크가 위치하는지 판단, 마크 또는 링 인식할 때/안될 때 예외처리

    보라색 마크와 링 인식 완료 후 2.6m 전진
   
```
turn(drone, deg2rad(-130));
pause(1);

% 드론 카메라 중심이 링 너머 보라색 색상 마크의 중심과 일치하도록 조정
dif = 30;
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0.70, 0.79);

    [x1, y1, boundingBox] = detect_from_frame(frame);
 
    %보라색 색상 마크가 인식이 되지 않았을 때 드론의 중심과 링의 중심 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No purple square detected.');

        %링이 인식이 되지 않았을 때 후진 후 다시 인식
        while ~isempty(boundingBox)
            disp('No bounding box detected.');
            moveback(drone, 'Distance', 0.2, 'Speed', 1);
            pause(0.5);
            [x1, y1, boundingBox] = detect_from_frame(frame);
        end
        
        move_to_center(drone, x1, y1, dif);

        centroid = [x1, y1];
        dis = centroid - center_point;

        if abs(dis(1)) <= 100 && abs(dis(2)) <= 100
            disp('Centered successfully!');
            break;
        end
    end
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 2.6, 'Speed', 1);
pause(1);
```

* #### 4단계[215도 시계방향 회전 및 링 중심 찾기]

    드론 215도 시계방향 회전 후 빨간색 마크 인식

    빨간색 hsv 값이 0~0.05, 0.95~1 두가지 범위가 있어 한가지로만 했을 때 마크가 인식이 되지 않는 문제 발생, 따라서 두가지 범위 중 인식이 되는 범위 선택 후 코드 진행

    1단계와 마찬가지로 빨간색 마크 인식이 되면 드론 카메라의 중심에 있는지 판단 후 링 안에 마크가 위치하는지 판단, 마크 또는 링 인식할 때/안될 때 예외처리

    빨간색 마크와 링 인식 완료 후 2.3m 전진
    * 시간초과 문제로 드론이 링을 통과하지 않을 최대 거리 계산 = 2.3m
   

```
turn(drone, deg2rad(215));
pause(1);

dif = 40;
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0, 0.06);
    [x1, y1, boundingBox] = detect_from_frame(frame);
 
    %빨간색 색상 마크가 인식이 되지 않았을 때 드론의 중심과 링의 중심 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No red square detected.');

        %링이 인식이 되지 않았을 때 후진 후 다시 인식
        while ~isempty(boundingBox)
            disp('No bounding box detected.');
            moveback(drone, 'Distance', 0.2, 'Speed', 1);
            pause(0.5);
            [x1, y1, boundingBox] = detect_from_frame(frame);
        end
        
        move_to_center(drone, x1, y1, dif);

        centroid = [x1, y1];
        dis = centroid - center_point;

        if abs(dis(1)) <= 100 && abs(dis(2)) <= 100
            disp('Centered successfully!');
            break;
        end
    end
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 2.3, 'Speed', 0.9);
pause(1);
```

* #### 5단계[빨간색 정사각형 중심 찾기 맟 착륙]

    정확한 착륙 지점을 위해 링 통과 직전 x축만 비교
    * y축은 앞서 2.3m 전진하기 전 높이를 맞춰놔서 비교할 필요가 없다고 판단

    링과 가까운 위치에서 중심을 잡이 링이 화면에 나오지 않는 경우가 발생해 빨간색 마크의 중심만 찾음

    중심을 찾으면 남은 1.85m 전진 후 드론 착륙륙

```
dif = 40;
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 20;

    [x, y] = square_detect(frame, 0, 0.06);

    if isnan(x) || isnan(y)
        [x, y] = square_detect(frame, 0.94, 1);
    end

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
```

* #### 함수 detect_from_frame

    링의 바운딩박스와 중심 좌표 x, y를 알아내는 함수

    파란색 영역을 찾기 위해 색상 값이 0.55와 0.65 사이에 있고, 채도가 0.5 이상인 픽셀을 선택 후 이진화된 이미지를 반전시킴

    regionprops 함수를 사용해 반전된 이미지에서 각 연결된 영역의 bounding box와 면젹을 계산

    bounding box 내에서 원을 찾아 가장 큰 원의 중심을 구하고 결과 시각화화

```
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

        % boundingBox 의 크기가 드론 카메라 frame 의 크기와 같은 경우 예외 처리
        if(tmpBox(3) == size(frame, 2) || tmpBox(4) == size(frame, 1))
            continue;
        else
            if tmpArea <= area(j).Area
                tmpArea = area(j).Area;
                boundingBox = area(j).BoundingBox;
            end
        end
    end
    
    % boundingBox 가 존재하는 경우 가림막 링의 중심 좌표 추출
    if ~isempty(boundingBox)
        center_x = boundingBox(1) + (0.5 * boundingBox(3));
        center_y = boundingBox(2) + (0.5 * boundingBox(4));
        
        inner_region = imcrop(frame, boundingBox);
        gray_inner = rgb2gray(inner_region);
        edges_inner = edge(gray_inner, 'Canny');
        
        [centers, radii] = imfindcircles(edges_inner, [20 100]);
        
        if ~isempty(centers)
            % 크기가 가장 큰 원의 중심 좌표 추출
            [~, max_idx] = max(radii);
            circle_center = centers(max_idx, :);
            
            center_x = boundingBox(1) + circle_center(1);
            center_y = boundingBox(2) + circle_center(2);
        end
        hold on
        rectangle('Position', boundingBox, 'EdgeColor', '#F59F00', 'LineWidth', 2);
        plot(center_x, center_y, 'o')
        title(['Center X: ', num2str(center_x), ', Center Y: ', num2str(center_y)])
        axis on
        grid on
    else
        center_x = NaN;
        center_y = NaN;
    end
end
```

* #### 함수 move_to_center

    드론이 색상 마크 혹은 가림막 링의 중심 좌표로 이동하도록 하는 함수

    드론의 중심(480, 200)과 매개변수로 주어진 x, y 좌표의 차이를 구하고, 주어진 오차값 범위 안에 들어가면 "Find Center Point" 문구 출력

    드론의 중심과 좌표의 차이가 40 이상이면 상하좌우로 0.2m씩 드론 조절
    * 텔로의 최소 이동 가능 거리가 0.2m로, 0.2m씩 좌우 또는 상하로 반복되는 경우가 있어 오차값을 점차 늘림림

```
function move_to_center(drone, target_x, target_y, dif)
    center_point = [480, 200];
    dis = [target_x, target_y] - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        disp('Find Center Point!');
        
    elseif abs(dis(1)) > 40
        if dis(1) < 0
            disp('Move left');
            moveleft(drone, 'Distance', 0.2, 'Speed', 1);
        else
            disp('Move right');
            moveright(drone, 'Distance', 0.2, 'Speed', 1);
        end
    end
    
    if abs(dis(2)) > 40
        if dis(2) < 0
            disp('Move up');
            moveup(drone, 'Distance', 0.2, 'Speed', 1);
        else
            disp('Move down');
            movedown(drone, 'Distance', 0.2, 'Speed', 1);
        end
    end
    
    pause(1);
end
```

* #### 함수 square_detect

    색상 마크의 중심 좌표를 반환 하는 함수

    매개변수로 주어진 범위 안에 존제하는 픽셀을 선택하여 이진화 이미지 생성

    regionprops 함수를 사용하여 이미지에서 각 연결된 영역의 bounding box와 면적 계산 후 for loop를 통해 가장 큰 영역 검출

    만약 bounding box가 비어있지 않으면 중심을 계산후 시각화

```
function [center_x, center_y] = square_detect(frame, th_down, th_up)
    tohsv = rgb2hsv(frame);
    h = tohsv(:,:,1);
    s = tohsv(:,:,2);
    v = tohsv(:,:,3);

    toBinary = (th_down < h) & (h < th_up) & (s > 0.4) & (v > 0.2);
    area = regionprops(toBinary, 'BoundingBox', 'Area');
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
    
    center_x = boundingBox(1) + (0.5 * boundingBox(3));
    center_y = boundingBox(2) + (0.5 * boundingBox(4));
    hold on
    rectangle('Position', boundingBox, 'EdgeColor', '#F59F00', 'LineWidth', 2);
    plot(center_x, center_y, 'o')
    title(['Center X: ', num2str(center_x), ', Center Y: ', num2str(center_y)])
    axis on
    grid on
end
```


## 4. 시도한 알고리즘

1. 0.6m 씩 갔는데 너무 오래걸림
2. 1단계에서 링 중심 잡았는데 시간 오래걸림
3. 4단계 링 중심 잡을때 화면 비율 했는데 항상 잘 잡혀서 걍 뺌
4. 중심 잡을때 오차값 말고 드론 이동 거리를 줄였는데, 최소 이동 가능 거리가 0.2m라 대안으로 오차값을 증가시킴

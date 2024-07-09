2024 미니드론 자율비행 경진대회
===============

- 2024 미니드론 자율비행 경진대회 기술 워크샵
- 주최 : 대한전기학회
- 팀명 : ELCO
- 팀원 : 국민대학교 전자공학부 박가현 김주영 배지완

(사진 1 : 강의실 사진)

## 0. 목차

1. 개요
   - 경로 상세 규격
   - 사용한 Toolbox
   - 간단한 진행 순서
2. 대회 진행 전략
   - 드론이 링과 링 너머 색상 마크의 중심에 위치하도록 조정
   - 오차 범위를 증가시키면서 드론을 이동
   - 드론 카메라 중심의 y좌표를 360이 아닌 200으로 설정
   - 4단계 링을 통과하기 전 y좌표를 비교하는 과정을 생략
3. 단계별 알고리즘
4. 소스 코드
5. 번외 : 시도한 알고리즘

## 1. 개요

### 1.1. 경로 상세 규격

(사진 2 : 경로 사진)

- 가림막 링
  - 1차 링 지름 : 57 cm
  - 2차 링 지름 : 46 cm
  - 3차 링 지름 : 46 cm
  - 4차 링 지름 : 52 cm
  - 링 중심의 높이 : 80 ~ 100 cm
 
- 색상 hsv 값의 범위
  - 빨간색 색상 마크 : 0 ~ 0.07
  - 초록색 색상 마크 : 0.24 ~ 0.34
  - 보라색 색상 마크 : 0.70 ~ 0.79
  - 파란색 가림막 : 0.55 ~ 0.75

### 1.2. 사용한 Toolbox

- image processing toolbox

### 1.3. 간단한 진행 순서

- 1단계 : 이륙 후 링 너머 빨간색 색상 마크와 링의 중심에 위치한 후 앞으로 3.5 m 이동
- 2단계 : 시계 방향으로 130도 회전한 후 앞으로 3.5 m 이동한 후 링 너머 초록색 색상 마크와 링의 중심에 위치한 후 앞으로 1.6 m 이동
- 3단계 : 반시계 방향으로 130도 회전한 후 링 너머 보라색 색상 마크와 링의 중심에 위치한 후 앞으로 2.6 m 이동
- 4-1단계 : 시계 방향으로 215도 회전한 후 링 너머 빨간색 색상 마크와 링의 중심에 위치한 후 앞으로 2.3 m 이동
- 4-2단계 : 링 너머 빨간색 색상 마크의 중심에 위치한 후 앞으로 1.85 m 이동한 후 착륙

## 2. 대회 진행 전략

### 2.1. 드론이 링과 링 너머 색상 마크의 중심에 위치하도록 조정

- 드론이 링과 링 너머 색상 마크의 중심에 위치하도록 조정한 후 드론이 앞으로 이동하도록 했다. 이를 수행하기 위한 알고리즘은 아래와 같다.

- 드론이 링 너머 색상 마크의 중심에 위치하도록 조정했다. 색상 마크의 중심 좌표를 return 하는 square_detect 함수와 드론이 색상 마크 또는 링의 중심에 위치하도록 하는 move_to_center 함수를 이용했다.
  - 드론이 색상 마크를 인식하지 못하는 경우 드론이 링의 중심에 위치하도록 조정했다. 링의 중심 좌표를 return 하는 detect_from_frame 함수와 move_to_center 함수를 이용했다.
    - 드론이 링을 인식하지 못하는 경우 드론이 링을 인식할 때까지 드론을 20 cm 씩 뒤로 이동시켰다.
      
- 드론이 색상 마크의 중심에 위치하면 색상 마크의 중심, 즉 드론의 위치와 링의 중심을 비교한다. 드론의 위치와 링의 중심의 차이가 100 보다 작은 경우 드론이 링과 색상 마크의 중심에 위치했다고 판단한다.
   - 드론의 위치와 링의 중심의 차이가 100 보다 큰 경우 드론이 링의 중심에 위치하도록 조정했다.
 
### 2.2. 오차 범위를 증가시키면서 드론을 이동

- 드론이 이동할 수 있는 최소 거리는 20 cm 이다. 드론이 위치해야 하는 곳에 정확히 위치하기 위해 계속해서 상하 또는 좌우로 이동하는 문제가 발생했다. 위의 문제를 해결하고, 드론이 링 또는 색상 마크의 중심으로 이동하는 데 걸리는 시간을 최소화하기 위해 오차 범위와 관련된 변수를 설정하고, 변수의 값을 증가시키면서 드론을 이동시켰다.

- 드론의 위치와 링 또는 색상 마크의 중심 사이의 오차가 무시할 수 있을 만큼 작으면 드론이 링 또는 색상 마크의 중심에 위치한 것으로 판단했다. 이를 통해 드론이 링 또는 색상 마크의 중심으로 이동하는 데 걸리는 시간을 최소화했다.
- 드론이 이동할 때마다 허용하는 오차 범위를 증가시켰다. 이를 통해 드론이 위치해야 하는 곳에 정확히 위치하기 위해 계속해서 상하 또는 좌우로 이동하는 문제를 해결했다.

### 2.3. 드론 카메라 중심의 y좌표를 360이 아닌 200으로 설정

- 드론 카메라 frame의 x좌표는 0 ~ 960, y좌표는 0 ~ 720 이다. 드론 카메라 중심의 y좌표를 360으로 설정하면 드론이 위치해야 하는 곳에 비해 위쪽에 위치하는 문제가 발생했다. 드론 카메라가 정확히 정면이 아닌 약간 아래쪽을 향하기 때문이다.

- 드론을 위로 조금씩 이동시키면서 드론이 위치해야 하는 곳에 정확히 위치하도록 하는 y좌표를 찾았다. moveup 함수를 이용하여 드론을 위쪽으로 20 cm 씩 이동시키고 imshow 함수를 이용하여 이미지를 표시했다. 위의 과정을 통해 드론 카메라 중심의 y좌표를 200으로 설정하면 드론이 위치해야 하는 곳에 정확히 위치함을 알게 되었다.

### 2.4. 4단계 링을 통과하기 전 y좌표를 비교하는 과정을 생략

- 드론이 주행하는 시간을 최소화하기 위해 4단계 링을 통과하기 전 드론 카메라 중심과 링 너머 색상 마크의 중심의 y좌표를 비교하는 과정을 생략했다.

- 위의 과정은 드론이 착륙 지점에 정확히 착지하도록 하기 위한 것이기 때문에 y좌표를 비교하는 과정은 필수적이지 않은 것으로 판단했다.

## 3. 단계별 알고리즘

( 표1 : 단계별 알고리즘을 나타낸 블럭도 )
 
## 4. 소스 코드

### 4.1. 0단계 : 필요한 변수 선언

- 변수 drone 및 드론 카메라 중심 좌표를 나타내는 변수 center_point 선언한다.
- 변수 cameraObj 선언한다.
- 허용 오차를 나타내는 변수 dif 선언, 40으로 초기화한다.

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

### 4.2. 1단계 : 드론을 링 너머 빨간색 색상 마크와 링의 중심에 위치시킨 후 링 통과

- square_detect 함수를 이용하여 링 너머 빨간색 색상 마크의 중심 좌표를 찾는다. 빨간색 색상 마크의 hsv 값 범위를 0 ~ 0.06 으로 생각한다.
   - 색상 마크가 인식되지 않은 경우 : detect_from_frame 함수를 이용하여 링의 중심 좌표를 찾는다. move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
        - 링이 인식되지 않은 경우 : 드론을 뒤로 이동시킨 후 다시 링을 인식한다. 이 과정은 드론이 링을 인식할 때까지 반복한다.
- move_to_center 함수를 이용하여 드론이 색상 마크의 중심에 위치하도록 조정한다. 이 과정은 드론 카메라 중심과 색상 마크의 중심 사이의 오차가 허용된 오차 범위 내에 포함될 때까지 반복한다. 오차 범위는 55로 초기화하고, 드론이 한 번 이동할 때마다 15씩 증가한다.
- 색상 마크의 중심, 즉 드론의 위치와 링의 중심의 차이가 100보다 작은 경우 드론이 색상 마크와 링의 중심에 위치했다고 판단한다.
   - 차이가 100보다 큰 경우 : move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
- 드론을 앞으로 3.5 m 이동시킨다.
  
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

### 4.3. 2단계 : 드론이 시계 방향으로 130도 회전 및 링 너머 초록색 색상 마크와 링

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

1. 0.6m씩 이동하면서 링의 중심/색상 마크의 중심을 찾은 방식으로 알고리즘을 구성했다. 높은 정확도와 경로를 이탈해도 곧바로 중심을 찾는 모습을 볼 수 있었지만 시간이 너무 오래 걸리는 단점이 있다.
2. 링/색상 마크의 중점을 잡을 때, 너무 작아 제대로 인식이 되지 않는 경우가 존제했다. 따라서 인식된 링/색상 마크의 크기가 화면 비율에서 일정 값 이하로 되면 전진 후 다시 인식을 하게끔 해 배경에 생기는 다른 boundong box들도 예방이 가능했다. 위 방법을 사용하여 알고리즘을 만들었지만, 더 나은 방법이 존제해 사용하지 않았다.
3. 텔로 카메라와 링/색상마크의 중심을 잡을 때 조금씩 움직이며 중점을 찾는다. 그러나 인식하고하 하는 물체가 너무 가까이 있으면 미세한 움직임이라도 화면상에서는 좌표 변화가 너무 커 한번 중심을 찾을 때 마다 이동 거리를 줄였다. 그러나 텔로 최소 이동 거리가 0.2m라 대안으로 텔로 카메라의 중심과 찾는 물체의 중심의 오차값을 늘리는 방식을 선택했다.

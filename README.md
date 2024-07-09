2024 미니드론 자율비행 경진대회
===============

- 2024 미니드론 자율비행 경진대회 기술 워크샵
- 주최 : 대한전기학회
- 팀명 : ELCO
- 팀원 : 국민대학교 전자공학부 박가현, 김주영, 배지완

![image1](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/bfc8ef0f-27da-4f9c-8f44-191ae07e1588)

## 0. 목차

1. 개요
   - 1.1. 경로 상세 규격
   - 1.2. 사용한 Toolbox
   - 1.3. 간단한 진행 순서
2. 대회 진행 전략
   - 2.1. 드론이 링과 링 너머 색상 마크의 중심에 위치하도록 조정
   - 2.2. 오차 범위를 증가시키면서 드론을 이동
   - 2.3. 드론 카메라 중심의 y좌표를 360이 아닌 200으로 설정
   - 2.4. 4단계 링을 통과하기 전 y좌표를 비교하는 과정을 생략
3. 단계별 알고리즘
4. 소스 코드
5. 번외 : 시도한 알고리즘
   - 5.1. 드론이 앞으로 0.6 m 이동하고 링 너머 색상 마크 혹은 링의 중심을 찾는 과정을 반복
   - 5.2. 드론 카메라의 frame 대비 색상 마크 혹은 링의 크기의 비율 계산
   - 5.3. 드론이 색상 마크 혹은 링의 중심에 위치하기 위해 이동할 때마다 이동 거리를 감소

## 1. 개요

### 1.1. 경로 상세 규격

![본선경로](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/d1be7afb-e357-4df9-b37f-0e154b694d6d)

- 가림막 링
  - 1차 링 지름 : 57 cm
  - 2차 링 지름 : 46 cm
  - 3차 링 지름 : 46 cm
  - 4차 링 지름 : 52 cm
  - 링 중심의 높이 : 80 ~ 100 cm
 
- 색상 hsv 값의 h 범위
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

![blockdiagram](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/72c5c787-be55-4ed5-a607-34249bb67d63)
 
## 4. 소스 코드

### 4.1. 0단계 : 필요한 변수 선언

- 변수 drone 및 드론 카메라 중심 좌표를 나타내는 변수 center_point을 선언한다.
- 변수 cameraObj을 선언한다.
- 허용 오차를 나타내는 변수 dif 선언, 40으로 초기화한다.

```
clear;
drone = ryze('Tello');

takeoff(drone);
pause(1);

% 드론 카메라 중심의 y 좌표를 200 으로 설정
center_point = [480, 200];
cameraObj = camera(drone);
dif = 40; 
```

### 4.2. 1단계 : 드론을 링 너머 빨간색 색상 마크와 링의 중심에 위치시킨 후 링 통과

![stage1](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/f2931e0c-2bf6-4e08-9484-e6448d5d55bf)

- 색상 마크의 중심 좌표를 변수 centroid, 드론 카메라 중심과 색상 마크의 중심 사이의 거리를 변수 dis에 저장한다.
- 링의 중심 좌표를 변수 centroid1, 드론 카메라 중심과 링의 중심 사이의 거리를 변수 dis1에 저장한다.
- square_detect 함수를 이용하여 링 너머 빨간색 색상 마크의 중심 좌표를 찾는다. 빨간색 색상 마크의 hsv 값의 h 범위를 0 ~ 0.06 으로 생각한다.
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
 
    % 링 너머 빨간색 색상 마크가 인식되지 않은 경우 드론 카메라 중심과 링의 중심이 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No red square detected.');

        % 링이 인식되지 않은 경우 드론이 뒤로 이동한 후 다시 링을 인식
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

    % 드론 카메라 중심이 링 너머 빨간색 색상 마크의 중심과 일치하도록 조정
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        % 빨간색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 작은 경우
        % 드론이 빨간색 색상 마크와 링의 중심에 위치했다고 판단
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        % 빨간색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 큰 경우
        % 드론 카메라 중심과 링의 중심이 일치하도록 조정
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 3.5, 'Speed', 0.85);
pause(1.5);
```

### 4.3. 2단계 : 드론이 시계 방향으로 130도 회전 및 링 너머 초록색 색상 마크와 링의 중심에 위치

![stage2](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/56a82a42-c633-4449-b8ea-8bb9dc8d60a6)

- 드론을 시계 방향으로 130도 회전시킨 후 앞으로 3.5 m 이동시킨다.
  - 드론이 2단계에서 이동해야 하는 거리는 5.1 m 이지만 드론이 정지하지 않고 이동할 수 있는 거리는 최대 5 m 이다. 따라서 드론을 3.5 m, 1.6 m 로 나누어 이동시켰다.
  - 드론을 3.5 m 보다 적게 이동시키면 이후 2단계 링을 인식할 때 4단계 링도 함께 인식되어 2단계 링의 중심 좌표가 제대로 추출되지 않는 문제가 발생했다. 따라서 4단계 링이 드론 카메라에 인식되지 않는 적절한 거리인 3.5 m 을 선택했다.
![image2](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/d30ec816-1acd-4ec8-b505-0355c91e12cd)
- square_detect 함수를 이용하여 링 너머 초록색 색상 마크의 중심 좌표를 찾는다. 초록색 색상 마크의 hsv 값의 h 범위를 0.24 ~ 0.34 로 생각한다.
   - 색상 마크가 인식되지 않은 경우 : detect_from_frame 함수를 이용하여 링의 중심 좌표를 찾는다. move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
        - 링이 인식되지 않은 경우 : 드론을 뒤로 이동시킨 후 다시 링을 인식한다. 이 과정은 드론이 링을 인식할 때까지 반복한다.
- move_to_center 함수를 이용하여 드론이 색상 마크의 중심에 위치하도록 조정한다. 이 과정은 드론 카메라 중심과 색상 마크의 중심 사이의 오차가 허용된 오차 범위 내에 포함될 때까지 반복한다. 오차 범위는 40으로 초기화하고, 드론이 한 번 이동할 때마다 15씩 증가한다.
- 색상 마크의 중심, 즉 드론의 위치와 링의 중심의 차이가 100보다 작은 경우 드론이 색상 마크와 링의 중심에 위치했다고 판단한다.
   - 차이가 100보다 큰 경우 : move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
- 드론을 앞으로 1.6 m 이동시킨다.
    
```
turn(drone, deg2rad(130));
pause(2);
 
moveforward(drone, 'Distance', 3.5, 'Speed', 1);
pause(1);

dif = 40;
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0.24, 0.34);
    [x1, y1, boundingBox] = detect_from_frame(frame);
 
    % 링 너머 초록색 색상 마크가 인식되지 않은 경우 드론 카메라 중심과 링의 중심이 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No green square detected.');

        % 링이 인식되지 않은 경우 드론이 뒤로 이동한 후 다시 링을 인식
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

    % 드론 카메라 중심이 링 너머 초록색 색상 마크의 중심과 일치하도록 조정
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        % 초록색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 작은 경우
        % 드론이 초록색 색상 마크와 링의 중심에 위치했다고 판단
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        % 초록색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 큰 경우
        % 드론 카메라 중심과 링의 중심이 일치하도록 조정
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 1.6, 'Speed', 1);
pause(1.5);
```

### 4.4. 3단계 : 드론이 반시계 방향으로 130도 회전 및 링 너머 보라색 색상 마크와 링의 중심에 위치

![stage3](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/c2674feb-3ad5-4326-b9eb-596c0c9dc42c)

- square_detect 함수를 이용하여 링 너머 보라색 색상 마크의 중심 좌표를 찾는다. 보라색 색상 마크의 hsv 값의 h 범위를 0.70 ~ 0.79 로 생각한다.
   - 색상 마크가 인식되지 않은 경우 : detect_from_frame 함수를 이용하여 링의 중심 좌표를 찾는다. move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
        - 링이 인식되지 않은 경우 : 드론을 뒤로 이동시킨 후 다시 링을 인식한다. 이 과정은 드론이 링을 인식할 때까지 반복한다.
- move_to_center 함수를 이용하여 드론이 색상 마크의 중심에 위치하도록 조정한다. 이 과정은 드론 카메라 중심과 색상 마크의 중심 사이의 오차가 허용된 오차 범위 내에 포함될 때까지 반복한다. 오차 범위는 30으로 초기화하고, 드론이 한 번 이동할 때마다 15씩 증가한다.
- 색상 마크의 중심, 즉 드론의 위치와 링의 중심의 차이가 100보다 작은 경우 드론이 색상 마크와 링의 중심에 위치했다고 판단한다.
   - 차이가 100보다 큰 경우 : move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
- 드론을 앞으로 2.6 m 이동시킨다.
   
```
turn(drone, deg2rad(-130));
pause(1);

dif = 30;
while true
    frame = snapshot(cameraObj);
    imshow(frame);
    dif = dif + 15;

    [x, y] = square_detect(frame, 0.70, 0.79);

    [x1, y1, boundingBox] = detect_from_frame(frame);
 
    % 링 너머 보라색 색상 마크가 인식이 되지 않은 경우 드론 카메라 중심과 링의 중심 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No purple square detected.');

        % 링이 인식이 되지 않은 경우 드론이 뒤로 이동한 후 다시 링을 인식
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

    % 드론 카메라 중심이 링 너머 보라색 색상 마크의 중심과 일치하도록 조정
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        % 보라색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 작은 경우
        % 드론이 보라색 색상 마크와 링의 중심에 위치했다고 판단
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        % 보라색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 큰 경우
        % 드론 카메라 중심과 링의 중심이 일치하도록 조정
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 2.6, 'Speed', 1);
pause(1);
```

### 4.5. 4-1단계 : 드론이 시계 방향으로 215도 회전 및 링 너머 빨간색 색상 마크와 링 중심에 위치

![stage4_1](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/4820bcb0-10bc-4476-992e-6501f39d03e4)

- 드론이 시계 방향으로 215도 회전한 후 square_detect 함수를 이용하여 링 너머 빨간색 색상 마크의 중심 좌표를 찾는다. 빨간색 색상 마크의 hsv 값의 h 범위는 0 ~ 0.05, 0.95 ~ 1 이기 때문에 두 가지 중 특정 범위로 생각하면 색상 마크가 제대로 인식되지 않는 문제가 발생했다. 따라서 두 가지 범위 중 색상 마크가 제대로 인식 되는 범위를 선택했다.
   - 색상 마크가 인식되지 않은 경우 : detect_from_frame 함수를 이용하여 링의 중심 좌표를 찾는다. move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
        - 링이 인식되지 않은 경우 : 드론을 뒤로 이동시킨 후 다시 링을 인식한다. 이 과정은 드론이 링을 인식할 때까지 반복한다.
- move_to_center 함수를 이용하여 드론이 색상 마크의 중심에 위치하도록 조정한다. 이 과정은 드론 카메라 중심과 색상 마크의 중심 사이의 오차가 허용된 오차 범위 내에 포함될 때까지 반복한다. 오차 범위는 55로 초기화하고, 드론이 한 번 이동할 때마다 15씩 증가한다.
- 색상 마크의 중심, 즉 드론의 위치와 링의 중심의 차이가 100보다 작은 경우 드론이 색상 마크와 링의 중심에 위치했다고 판단한다.
   - 차이가 100보다 큰 경우 : move_to_center 함수를 이용하여 드론이 링의 중심에 위치하도록 조정한다.
- 드론을 앞으로 2.3 m 이동시킨다.
  - 드론이 링을 통과하기 전이면서도 링 너머 빨간색 색상 마크가 제대로 인식되는 거리가 최대 2.3 m 라고 판단했다.   

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
 
    % 링 너머 빨간색 색상 마크가 인식되지 않은 경우 드론 카메라 중심과 링의 중심이 일치하도록 조정
    if isnan(x) || isnan(y)
        disp('No red square detected.');

        % 링이 인식되지 않은 경우 드론이 뒤로 이동한 후 다시 링을 인식
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

    % 드론 카메라 중심이 링 너머 빨간색 색상 마크의 중심과 일치하도록 조정
    move_to_center(drone, x, y, dif);
 
    centroid = [x, y];
    dis = centroid - center_point;
    centroid1 = [x1, y1];
    dis1 = centroid1 - center_point;

    if abs(dis(1)) <= dif && abs(dis(2)) <= dif
        % 빨간색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 작은 경우
        % 드론이 빨간색 색상 마크와 링의 중심에 위치했다고 판단
        if abs(dis1(1)) <= 100 && abs(dis1(2)) <= 100
            disp('Centered successfully!');
            break;
        % 빨간색 색상 마크의 중심 (드론의 위치) 와 링의 중심의 차이가 100 보다 큰 경우
        % 드론 카메라 중심과 링의 중심이 일치하도록 조정
        else
            move_to_center(drone, x1, y1, dif);
        end
    end
end

moveforward(drone, 'Distance', 2.3, 'Speed', 0.9);
pause(1);
```

### 4.6. 4-2단계 : 드론이 링 너머 빨간색 색상 마크에 위치한 후 링 통과 후 착륙

![stage4_2](https://github.com/gahyunparkk/drone_ELCO/assets/133209913/490d42e7-af71-48f4-b6e5-f771609b3da8)

- square_detect 함수를 이용하여 링 너머 빨간색 색상 마크의 중심 좌표를 찾는다. 빨간색 색상 마크의 hsv 값의 h 범위를 0 ~ 0.06 으로 생각한다.
   - 4-2단계에서는 드론 카메라 중심과 링의 중심을 비교하지 않는다. 드론이 링과 매우 가까운 거리에 위치하기 때문에 드론 카메라에 링이 제대로 인식되지 않아 링의 중심 좌표가 제대로 추출되지 않기 때문이다.
- move_to_center 함수를 이용하여 드론이 색상 마크의 중심에 위치하도록 조정한다. 이 과정은 드론 카메라 중심과 색상 마크의 중심 사이의 오차가 허용된 오차 범위 내에 포함될 때까지 반복한다. 오차 범위는 40으로 초기화하고, 드론이 한 번 이동할 때마다 15씩 증가한다.
  - 드론 카메라 중심과 색상 마크 중심의 y좌표는 비교하지 않는다. 4-1단계를 통해 드론 카메라 중심과 색상 마크 중심의 y좌표가 이미 같도록 조정되어 있다고 판단했기 때문이다.
- 드론이 앞으로 1.55 m 이동한 후 착륙한다.

```
% 드론 카메라 중심이 링 너머 빨간색 색상 마크의 중심과 일치하도록 조정
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

### 4.7. 함수 detect_from_frame : 파란색 가림막 링의 중심 좌표를 return 하는 함수

- 파란색 가림막의 영역을 찾는다. 파란색 가림막의 hsv 값의 h 범위를 0.55 ~ 0.65 로 생각하고, s 범위가 0.5 보다 높다고 생각한다. 위의 hsv 값의 범위에 해당하는 픽셀을 선택한 후 이진화된 이미지를 반전시킨다.
- regionprops 함수를 이용하여 반전된 이미지에서 각각의 연결된 영역의 bounding box와 면적을 계산한다.
- bounding box 내에서 원을 찾은 후 크기가 가장 큰 원의 중심 좌표를 구하고 그 결과를 시각화한다.

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

### 4.8. 함수 move_to_center : 드론을 색상 마크 혹은 가림막 링의 중심 좌표로 이동시키는 함수

- 드론의 중심 좌표인 (480, 200)과 매개변수로 주어진 색상 마크 혹은 가림막 링의 중심 좌표의 차이를 구한다.
  - 차이가 허용된 오차 범위인 40보다 작은 경우 : 드론이 색상 마크 혹은 링의 중심에 위치했다고 판단한다. "Find Center Point"를 출력한다.
  - 차이가 40보다 큰 경우 : 드론이 상하좌우로 0.2 m 씩 이동한다.

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

### 4.8. 함수 square_detect : 색상 마크의 중심 좌표를 return 하는 함수

- 매개변수로 주어진 색상 마크의 h 범위 내에 존재하는 픽셀을 선택하여 이진화 이미지를 생성한다.
- regionprops 함수를 이용하여 이미지에서 각 연결된 영역의 bounding box와 면적을 계산한다. for loop 문을 이용하여 크기가 가장 큰 영역을 검출한다.
  - bounding box가 비어있지 않은 경우 중심을 계산하여 시각화한다.

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

## 5. 번외 : 시도한 알고리즘

- 드론이 주어진 경로를 주행하는데 가장 효율적인 코드를 고민하면서 다음과 같은 알고리즘을 고안했다. 드론이 경로를 주행하는 데 소요되는 시간을 최소화하기 위해 다음과 같은 알고리즘은 최종적으로 사용하지 못했다.

### 5.1. 드론이 앞으로 0.6 m 이동하고 링 너머 색상 마크 혹은 링의 중심을 찾는 과정을 반복

- 드론을 주어진 경로를 이탈하지 않고 정확하게 링의 중심의 통과시키고 싶었다. 이에 드론이 앞으로 0.6 m 이동하고 링 너머 색상 마크 혹은 링의 중심을 찾은 과정을 계속해서 반복하는 알고리즘을 고안했다.
- 위의 알고리즘은 드론이 경로를 주행하는 데 너무 많은 시간을 소요하는 문제가 있었다.

### 5.2. 드론 카메라의 frame 대비 색상 마크 혹인 링의 크기의 비율 계산

- 색상 마크 혹은 링의 중심 좌표를 찾을 때 색상 마크 혹은 링의 크기가 너무 작아 드론 카메라에 제대로 인식되지 않는 문제가 발생했다. 이에 드론 카메라의 frame 대비 인식된 색상 마크 혹은 링의 크기가 특정한 값보다 작은 경우 다시 인식을 시도하는 알고리즘을 고안했다.
- 위의 알고리즘은 불필요한 bounding box가 발생하는 문제도 예방할 수 있었다. 그러나 최종 소스 코드에서 사용한 알고리즘이 더욱 낫다고 판단했다.

### 5.3. 드론이 색상 마크 혹은 링의 중심에 위치하기 위해 이동할 때마다 이동 거리를 감소

- 드론이 색상 마크 혹은 링의 중심에 위치하기 위해 이동한다. 이때, 드론이 색상 마크 혹은 링과 가깝게 위치한 경우 드론이 비교적 적은 거리를 이동했음에도 드론 카메라의 frame 상에는 좌표 변화가 크다. 이에 드론이 이동할 때마다 이동 거리를 감소시키는 알고리즘을 고안했다.
- 드론이 이동할 수 있는 거리는 최소 0.2 m 이기 때문에 위의 알고리즘은 한계가 존재했다. 이에 드론 카메라 중심과 색상 마크 혹은 링의 중심의 차이를 허용된 오차 범위와 비교하는 새로운 알고리즘을 고안해 문제를 해결했다.

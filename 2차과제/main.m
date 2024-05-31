clear;
droneObj = ryze('Tello');

% 드론 이륙
takeoff(droneObj);
pause(2);

% roll 제어 - 좌측 비행
moveleft(droneObj, 'Distance', 1.5);
pause(2);

% yaw 제어 - 오른쪽으로 30도 회전
turn(droneObj, deg2rad(30));
pause(2);

% pitch 제어 - 전면 비행
moveforward(droneObj, 'Distance', 1);
pause(2);

% yaw 제어 - 오른쪽으로 60도 회전
turn(droneObj, deg2rad(60));
pause(2);

% pitch 제어 - 전면 비행
moveforward(droneObj, 'Distance', 0.5);
pause(2);

% 사진 촬영
cameraObj = camera(droneObj);
frame = snapshot(cameraObj);
imshow(frame);

% yaw 제어 - 왼쪽으로 30도 회전
turn(droneObj, deg2rad(-30));
pause(2);

% roll 제어 - 좌측 비행
moveright(droneObj, 'Distance', 1.0);
pause(2);

% 착륙
land(droneObj);

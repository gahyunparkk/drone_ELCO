[x, y] = detect("사진5.jpg");
disp(['Center X: ', num2str(x)]);
disp(['Center Y: ', num2str(y)]);

function [center_x, center_y] = detect(input)

    image = imread(input);
    th_down = 0.30;
    th_up = 0.40;

    tohsv = rgb2hsv(image); %rgb to hsv
    h = tohsv(:,:,1);
    s = tohsv(:,:,2);
    toBinary = (th_down<h)&(h<th_up)&(s>0.5);
    filtered = imcomplement(toBinary);

    area = regionprops(filtered,'BoundingBox','Area');
    tmpArea = 0;
    for j = 1:length(area)
        tmpBox = area(j).BoundingBox; 
        if(tmpBox(3) == 1079 || tmpBox(4) == 810) %BoundingBox 예외 처리
            continue
        
        else
            if tmpArea <= area(j).Area 
                tmpArea = area(j).Area;
                boundingBox = area(j).BoundingBox;
            end
        end
    end
    figure, imshow(image)
    hold on
    rectangle('Position', [boundingBox(1),boundingBox(2),boundingBox(3),boundingBox(4)],'EdgeColor','#F59F00','LineWidth',2);
    % 중앙 값 추출
    center_x = boundingBox(1) + (0.5 * boundingBox(3)); 
    center_y = boundingBox(2) + (0.5 * boundingBox(4)); 
    plot(center_x, center_y,'o')
    axis on
    grid on
end

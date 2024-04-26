if(month == 4 || month == 6 || month == 9 || month == 11)
    if(day > 30)
        month = month + 1;
        day = day - 30; 
    end
elseif(month == 2)
    if(day > 28) 
        month = month + 1;
        day = day - 28;
    end
else
    if(day > 31)
        month = month + 1;
        day = day - 31;
    end
end

if month > 12
    year = year + 1;
    month = month - 12;
end

fprintf('%d시간 후의 시간: %d년 %d월 %d일 %d시\n',time, year, month, day, hour);

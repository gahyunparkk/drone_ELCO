if month > 12
  year = year + 1;
  month = month - 12;
end

fprintf('%d시간 후의 시간: %d년 %d월 %d일 %d시\n',time, year, month, day, hour);

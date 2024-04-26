
year = input('연도를 입력하세요 : ');
month = input('월을 입력하세요 : ');
day = input('일을 입력하세요 : ');
hour = input('시간을 입력하세요 : ');
time = input('시간 단위의 숫자를 입력하세요 : ');

=======

hour = hour + time;
while hour >= 24
    day = day +1;
    hour = hour - 24;
end
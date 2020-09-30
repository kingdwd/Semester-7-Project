% Speed bag files
bag = rosbag('speed/speed_0-2/speed_0-2_006.bag');

%bagselectticks_left = bag.select('Topic', '/ticks_left');
bagselectticks_right = bag.select('Topic', '/ticks_right');
bagselectspeedSet = bag.select('Topic', '/set_accelerator_position');


%ticks_left = bagselectticks_left.timeseries;
ticks_right = bagselectticks_right.timeseries;
speed_set_point = bagselectspeedSet.timeseries;



vec1 = ticks_right.data;
vec2 = ticks_right.time-bag.StartTime;

startPos = 2;

for i = 1:length(vec1)
    if(vec1(i) ~= vec1(i+1))
       break; 
    else
        startPos = startPos + 1;
    end
end

vec3 = vec1((startPos - -25):length(vec1));
vec4 = vec2((startPos - -25):length(vec2));

%plot(ticks_left.time-bag.StartTime, ticks_left.data, 'b');
hold on;
%plot(speed_set_point.time-bag.StartTime,speed_set_point.data,'r*');

set1 = speed_set_point.time-bag.StartTime;
set2 = speed_set_point.data;

vec4 = vec4 - vec4(1);

%plot(vec4, vec3);

deriv = [];
deriv(1) = 0;

for i = 2:(length(vec4))
    deriv(i) = (vec3(i) - vec3(i - 1)) / (vec4(i) - vec4(i - 1));
end

deriv = transpose(deriv);
smoothDeriv = smooth(deriv, 0.125, 'rloess');

dderiv = [];
dderiv(1) = 0;

for i = 2:(length(vec4))
    dderiv(i) = (smoothDeriv(i) - smoothDeriv(i - 1)) / (vec4(i) - vec4(i - 1));
end

dderiv = transpose(dderiv);
smoothDderiv = smooth(dderiv, 0.125, 'rloess');

plot(vec4, deriv, 'g-');
plot(vec4, smoothDeriv, 'r-.');

plot(vec4, dderiv, 'm-');
plot(vec4, smoothDderiv, 'b-.');






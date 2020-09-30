bag1 = rosbag('steering/speed1/steer_0-p5500_001.bag');
bagselectSteeringPos1 = select(bag1, 'Topic', '/steering_wheel_position');
bagselectSteeringSet1 = select(bag1, 'Topic', '/set_steering_angle');

bag2 = rosbag('steering/speed1/steer_0-p5500_002.bag');
bagselectSteeringPos2 = select(bag2, 'Topic', '/steering_wheel_position');
bagselectSteeringSet2 = select(bag2, 'Topic', '/set_steering_angle');

bag3 = rosbag('steering/speed1/steer_0-p5500_003.bag');
bagselectSteeringPos3 = select(bag3, 'Topic', '/steering_wheel_position');
bagselectSteeringSet3 = select(bag3, 'Topic', '/set_steering_angle');

tsSteeringPos1 = timeseries(bagselectSteeringPos1, 'Data');
tsSteeringSet1 = timeseries(bagselectSteeringSet1, 'Data');

tsSteeringPos2 = timeseries(bagselectSteeringPos2, 'Data');
tsSteeringSet2 = timeseries(bagselectSteeringSet2, 'Data');

tsSteeringPos3 = timeseries(bagselectSteeringPos3, 'Data');
tsSteeringSet3 = timeseries(bagselectSteeringSet3, 'Data');

steeringVecPosData1 = tsSteeringPos1.data;
steeringVecPosData2 = tsSteeringPos2.data;
steeringVecPosData3 = tsSteeringPos3.data;



startPos1 = 2;
startPos2 = 2;
startPos3 = 2;

for i = 1:length(steeringVecPosData1)
    if(steeringVecPosData1(i) ~= steeringVecPosData1(i+1))
       break; 
    else
        startPos1 = startPos1 + 1;
    end
end

for i = 1:length(steeringVecPosData2)
    if(steeringVecPosData2(i) ~= steeringVecPosData2(i+1))
       break; 
    else
        startPos2 = startPos2 + 1;
    end
end

for i = 1:length(steeringVecPosData3)
    if(steeringVecPosData3(i) ~= steeringVecPosData3(i+1))
       break; 
    else
        startPos3 = startPos3 + 1;
    end
end

vec1 = steeringVecPosData1((startPos1 - 10):length(steeringVecPosData1));
vec2 = steeringVecPosData2((startPos2 - 10):length(steeringVecPosData2));
vec3 = steeringVecPosData3((startPos3 - 10):length(steeringVecPosData3));

hold on;

plot(vec1, 'g');
plot(vec2, 'r-.');
plot(vec3, 'b--');


%step = stepDataOptions;

%step = stepDataOptions('InputOffset',0,'StepAmplitude',tsSteeringSet.data(1));

%plot(tsSteeringPos.time-bag.StartTime, tsSteeringPos.data);
%plot(tsSteeringSet.time-bag.StartTime-(tsSteeringPos.time(1)-bag.StartTime), tsSteeringSet.data);
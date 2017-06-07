[training,delimiterOut] = importdata('mushroom-training.txt');

h = 10;
learning_rate = 0.0032;

w1 = zeros(h,100);
w2 = zeros(1,h);
b1 = zeros(h,1);
b2 = 0;

a = zeros(500,1);

for iteration = 1:500
    
    gradW1 = zeros(h,100);
    gradW2 = zeros(1,h);
    gradB1 = zeros(h,1);
    gradB2 = 0;

    error = 0;
    error_rate = 0;
    
    for i = 1:7000
        tmp = training(i,:);
        t = tmp(1);
        y0 = tmp(2:101).';
        x1 = b1 + w1*y0;
        y1 = 1./(1+exp(-x1));
        x2 = b2 + w2*y1;
        y2 = 1./(1+exp(-x2));
        
        error = error + ((t-y2)^2)/2;
        
        if (y2 < 0.5 && t == 1) || (y2 >= 0.5 && t == 0)
            error_rate = error_rate + 1;
        end

        d2 = (1./(1+exp(-x2)).*(1-(1./(1+exp(-x2)))))*(y2-t);
        d1 = (1./(1+exp(-x1)).*(1-(1./(1+exp(-x1))))).*((w2.')*d2);

        gradW1 = gradW1 + d1*(y0.');
        gradW2 = gradW2 + d2*(y1.');
        gradB1 = gradB1 + d1;
        gradB2 = gradB2 + d2;
    end

    w1 = w1 - learning_rate*gradW1;
    w2 = w2 - learning_rate*gradW2;
    b1 = b1 - learning_rate*gradB1;
    b2 = b2 - learning_rate*gradB2;
    
    %error_rate = error_rate/7000;
    
    a(iteration,1) = error;
    
    fprintf('error rate: %d , iteration: %d\n',error_rate,iteration);
end

[testing,delimiterOut] = importdata('mushroom-testing.txt');
error_rate = 0;
    
for i = 1:1000
    tmp = testing(i,:);
    t = tmp(1);
    y0 = tmp(2:101).';
    x1 = b1 + w1*y0;
    y1 = 1./(1+exp(-x1));
    x2 = b2 + w2*y1;
    y2 = 1./(1+exp(-x2));

    if (y2 < 0.5 && t == 1) || (y2 >= 0.5 && t == 0)
        error_rate = error_rate + 1;
    end
end

error_rate = error_rate/1000;
error_rate;

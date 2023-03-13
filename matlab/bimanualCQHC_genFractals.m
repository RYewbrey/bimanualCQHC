x = -1:0.001:1; %-1:0.01:1;
y = x;
[X,Y] = meshgrid(x);
n = 8;%how many lines there are
al = 0; %0.8 %0 for straight lines
F =  min(1,0.1*1./(X.^2+Y.^2)).*(sin(n*atan2(X-al*(X.^2+Y.^2).*Y, Y+al*(X.^2+Y.^2).*X)))
%surf(X,Y,F);
%image(F,'CDataMapping','scaled')
figure
imshow(F)

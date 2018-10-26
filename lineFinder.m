function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)

fh1 = figure(); %opens a figure with original image to draw lines on
imshow(orig_img);

sz = size(hough_img); %finds size of the hough accumulator and original image
sz2 = size(orig_img);

rho_max = sqrt((sz2(1).^2 + sz2(2).^2)); %determines maximum rho

hough_rows = linspace(-rho_max, rho_max, sz(1) + 1); %creates rho bins
hough_cols = linspace(0, pi, sz(2) + 1); %creates theta bins

for i = 1:sz(1) %iterate through the hough accumulator array
    for j = 1:sz(2)
        if(hough_img(i,j) >= hough_threshold) %will only draw a line if the votes in the hough_img is >= the threshold

            theta = (hough_cols(j + 1) + hough_cols(j))./2; %take midpoint between theta bins
            rho = (hough_rows(i + 1) + hough_rows(i))./2; %take midpoint between rho bins
            
            xlim = [0 sz2(2)]; %sets minimum and maximum x values to calculate y with
            y1 = (xlim(1)*sin(theta) + rho)./cos(theta); %calculates y when x = j, the point coming from the hough_img
            y2 = (xlim(2)*sin(theta) + rho)./cos(theta);  %calculates y with an arbitrary x to calculate slope
            
            A = [xlim(1) xlim(2)]; %array stores x values
            B = [y1 y2]; %array stores y values
            
            m = (B(2)-B(1))/(A(2)-A(1)); %slope
            n = B(2) - A(2)*m; %y intercept
            y3 = m*xlim(1) + n; %y when x is 0
            y4 = m*xlim(2) + n; %y when x is maximum
            hold on;
            line([xlim(1) xlim(2)],[y3 y4], 'Color', 'blue', 'LineWidth', 2); %draws the line
            hold off;
        end
    end
end

figure(fh1);

% The figure needs to be undocked
set(fh1, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh1);
truesize(fh1, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh1);
frame = getframe(fh1);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
line_detected_img = frame.cdata;
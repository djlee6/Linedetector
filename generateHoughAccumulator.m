function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)

[height, width, dim] = size(img); %determines size of img

rho_max = sqrt((height.^2 + width.^2)); %determines maximum rho

hough_rows = linspace(-rho_max, rho_max, rho_num_bins + 1); %creates rho bins
hough_cols = linspace(0, pi, theta_num_bins + 1); %creates theta bins

hough_accumulator = zeros(rho_num_bins, theta_num_bins); %creates an array to store votes

[row, col] = find(img == 255); %finds edge pixels

for j = 1:length(row) %iterate through edge pixels
    for k = 1:length(hough_cols) - 1 %iterate through theta bins
        theta = (hough_cols(k + 1) + hough_cols(k))./2; %take midpoint between theta bins
        rho = row(j).*cos(theta) - col(j).*sin(theta); %calculate rho from edge coordinates and theta bins
        for i = 1:length(hough_rows) - 1
            if((rho < hough_rows(i + 1)) && (rho >= hough_rows(i)))
                hough_accumulator(i, k) = hough_accumulator(i, k) + 1; %increment accumulator array 
            end
        end
    end
end

max_votes = max(max(hough_accumulator)); %finds maximum number of votes
scalar = 255./max_votes; %creates a scalar to set the votes from 0 to 255

hough_img = scalar.*hough_accumulator; %sets the values of the accumulator between 0 and 255
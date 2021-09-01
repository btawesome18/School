% APPM 2360 - Project 2
% Authors: Brain Trybus, Rishi Mayekar, Ivan Werne
% Purpose: Image processing and modification using matrix math


%% Import Image
% Planes 1, 2 and 3 are R, G, B respectively
IMG = imread('square.jpg');

IMG = double(IMG);
[R, C, ~] = size(IMG);

%% Show that Svec works

Stest = Svec(5);

I = Stest*Stest;


%% Compress the grayscale image.

IMG_gray = IMG;
exp_factor = 1.2; % The factor by which to change the exposure

% For loop, which takes the average of all the color values each pixel
for i = 1:R
    for j = 1:C
        % Average out the RGB values
        sum = IMG(i,j,1) + IMG(i,j,2) + IMG(i,j,3);
        avg = sum/3;
        IMG_gray(i,j,1) = avg;
        IMG_gray(i,j,2) = avg;
        IMG_gray(i,j,3) = avg;
    end
end
IMG_gray1D = IMG_gray(:,:,1);

S = Svec(R);

imagesc(uint8(IMG_gray));
%Transform one layer
Y = (S*IMG_gray1D*S);

imagesc(uint8(Y));

p=0.4;
n=R;
%Delete less important data
for i = 1:n
    for j = 1:n
        if(i+j > p*2*n)
            Y(i,j) = 0;
        end
        
    end
end

%Transform layer back to image.
Y = S*Y*S;

%Make gray by coping layer.
Y1= zeros(R,R,3);
Y1(:,:,1)=Y;
Y1(:,:,2)=Y;
Y1(:,:,3)=Y;
%Display image
imagesc(uint8(Y1));

%% Transforms image and saves to cell

%Transform all 3 layers
DST = IMG;
DST(:,:,1) = S*IMG(:,:,1)*S;
DST(:,:,2) = S*IMG(:,:,2)*S;
DST(:,:,3) = S*IMG(:,:,3)*S;

%Copy to cell matrix
DSTcell{1}=DST;
DSTcell{2}=DST;
DSTcell{3}=DST;
DSTcell{4}=DST;
DSTcell{5}=DST;

%% Cuts off extra data with the given p value.

p=linspace(0.1,0.9,5);
n=R;

for i = 1:n
    for j = 1:n
        if(i+j > p(1)*2*n)
            DST = DSTcell{1};
            DST(i,j,1) = 0;
            DST(i,j,2) = 0;
            DST(i,j,3) = 0;
            DSTcell{1} = DST;
        end
        if(i+j > p(2)*2*n)
            DST = DSTcell{2};
            DST(i,j,1) = 0;
            DST(i,j,2) = 0;
            DST(i,j,3) = 0;
            DSTcell{2} = DST;
        end
        if(i+j > p(3)*2*n)
            DST = DSTcell{3};
            DST(i,j,1) = 0;
            DST(i,j,2) = 0;
            DST(i,j,3) = 0;
            DSTcell{3} = DST;
        end
        if(i+j > p(4)*2*n)
            DST = DSTcell{4};
            DST(i,j,1) = 0;
            DST(i,j,2) = 0;
            DST(i,j,3) = 0;
            DSTcell{4} = DST;
        end
        if(i+j > p(5)*2*n)
            DST = DSTcell{5};
            DST(i,j,1) = 0;
            DST(i,j,2) = 0;
            DST(i,j,3) = 0;
            DSTcell{5} = DST;
        end
    end
end
%% Transform and save the compressed images.

DST = DSTcell{1};
imagesc(uint8(DST))
IMG(:,:,1) = S*DST(:,:,1)*S;
IMG(:,:,2) = S*DST(:,:,2)*S;
IMG(:,:,3) = S*DST(:,:,3)*S;
IMG;
fileName = strcat('squareCompressedP1.jpg');
imwrite(uint8(IMG),fileName);

DST = DSTcell{2};
IMG(:,:,1) = S*DST(:,:,1)*S;
IMG(:,:,2) = S*DST(:,:,2)*S;
IMG(:,:,3) = S*DST(:,:,3)*S;
IMG;
fileName = strcat('squareCompressedP2.jpg');
imwrite(uint8(IMG),fileName);

DST = DSTcell{3};
IMG(:,:,1) = S*DST(:,:,1)*S;
IMG(:,:,2) = S*DST(:,:,2)*S;
IMG(:,:,3) = S*DST(:,:,3)*S;
IMG;
fileName = strcat('squareCompressedP3.jpg');
imwrite(uint8(IMG),fileName);

DST = DSTcell{4};
IMG(:,:,1) = S*DST(:,:,1)*S;
IMG(:,:,2) = S*DST(:,:,2)*S;
IMG(:,:,3) = S*DST(:,:,3)*S;
IMG;
fileName = strcat('squareCompressedP4.jpg');
imwrite(uint8(IMG),fileName);

DST = DSTcell{5};
IMG(:,:,1) = S*DST(:,:,1)*S;
IMG(:,:,2) = S*DST(:,:,2)*S;
IMG(:,:,3) = S*DST(:,:,3)*S;
IMG;
fileName = strcat('squareCompressedP5.jpg');
imwrite(uint8(IMG),fileName);

%% Functions

function S = Svec(num)

S = zeros(num,num);
    for i = 1:num
        for j = 1:num
            
            S(i,j) = sin((pi*(i-1/2)*(j-1/2))/num);
            
        end
    end

S = S*sqrt(2/num);
end



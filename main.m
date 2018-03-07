%%%%%%%%%%%%%%%%%%%%% Main file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         To detect and show the largest and the smallest discs in the image
%  
% Input Variables:
%         im        Input image that is going to be operated
%         M, N      Number of rows(M) and columns(N)
%         im_close  Image after closing operation
%         X         Image after closing and opening operation
%         X_ero     Image after eroded by disc structuring element
%         X_c       Image background of the image(complement of image)
%         X_b       Image background after eroded by cavity structuring element
%         XL        Image after intersect X_c and X_b will appear the
%                       positions of the desired discs
%         Xk        
% Output:
%         Xf         Image with only the largest and the smalles discs
% Process Flow:
%         1. Input image and set it into binary image with athreshold.
%         2. First do closing and then opening it with 3*3 circular structuring element
%             to filter out the salt-and-pepper noise.
%         3. Create a disc that is a bit larger than the smallest disc and
%               a cavity that is a bit smaller than the largest disc.
%         4. Erode the image with the cavity and erode the image
%               background(complement of the image) with the disc.
%         5. By doing the last two steps, we are able to find out the
%               middle-sized discs.
%         6. With the positions we obtained in 5., we then set the
%               corresponding positions on the image X and its surrounding pixels
%               to be '255' (white) to filter out the unwanted discs and acquire the image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

clc
clear 
close all
imtool close all

im = imread('RandomDisks-P10.jpg');
% imshow(im);

im = im(:,:,1);
[M, N] = size(im);

for i=1:M
    for j=1:N
        if(im(i,j) > 120)
            im(i,j) = 255;
        else
            im(i,j) = 0;
        end
    end
end
% imshow(im);


%% Hit-or-Miss transform before filtering
r1 = 10;
r2 = 30;
[A, B] = stru_ele(r1); % create the desired disc
[A2,B2] = stru_ele(r2); % create the desired cavity

% Hit
X_ero = erosion(im,A); % Conducting hit operation
% figure();
% imshow(X_ero);

% Miss
Xc = 255 - im;
Xb = erosion(Xc, B2);
% figure();
% imshow(Xb);

% intersect both image to get the positions of the desired discs
XL = Xb + X_ero;

% white out the frame
XL([1:r1],:) = 255;
XL([636-r1: 636],:) = 255;
XL(:,[1:r1]) = 255;
XL(:,[808-r1: 808]) = 255;
imshow(XL);

% Find the positions of the black pixels on the transformed image and then
% filter out the corresponding positions on the original image.
Z = im;
a = 30;
for i = 1+a:M-a
    for j = 1+a:N-a
        if XL(i, j) == 0
            Z(i-a:i+a, j-a:j+a) = 255;
        end
    end
end
           
figure();
imshow(Z);
%% Filtering the salt and pepper noise
[A, B] = stru_ele(1); % create a struct element to filter out the noise
%First perform closing function
im_close = dilation(im, A);
im_close = erosion(im_close,A);
% imshow(im_close);

% Opening function to get back original disk size
im_open = erosion(im_close,A);
X = dilation(im_open,A);
X([1,2],:) = 255;
X([635, 636],:) = 255;
X(:,[1,2]) = 255;
X(:,[807, 808]) = 255;
figure();
imshow(X);


%% Performing hit-or-miss transform
r1 = 10;
r2 = 30;
[A, B] = stru_ele(r1); % create the desired disc
[A2,B2] = stru_ele(r2); % create the desired cavity

% Hit
X_ero = erosion(X,A); % Conducting hit operation
% figure();
% imshow(X_ero);

% Miss
Xc = 255 - X;
Xb = erosion(Xc, B2);
% figure();
% imshow(Xb);

% intersect both image to get the positions of the desired discs
XL = Xb + X_ero;

% white out the frame
XL([1:r1],:) = 255;
XL([636-r1: 636],:) = 255;
XL(:,[1:r1]) = 255;
XL(:,[808-r1: 808]) = 255;
imshow(XL);

% % Find the positions of the black pixels on the transformed image and then
% % filter out the corresponding positions on the original image.
Z = X;
a = 30;
for i = 1+a:M-a
    for j = 1+a:N-a
        if XL(i, j) == 0
            Z(i-a:i+a, j-a:j+a) = 255;
        end
    end
end
           
figure();
imshow(Z);

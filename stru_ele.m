%%%%%%%%%%%%%%% Function structuring element %%%%%%%%%%%%%%%%%
% Purpose:
%       Create structuring elements that are used in Hit-or-Miss transform
% Input variables:
%       r    radius of the disk that is later used to determine the object
%               size
% Output variables:
%       A    the disk that will later be used to determine the object size
%       B    the element that will later be used to the background
%      
% Process Flow:
%       1. Create a disc using meshgrid and set the value greater than the
%          square of the radius to be black
%       2.Subtract with the background to get the structuring elemnet with
%           cavity.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, B] = stru_ele(r)
xx = -r:r;
yy = -r:r;
[XX, YY] = meshgrid(xx, yy);
A = 255 - zeros(size(XX));
A((XX.^2+YY.^2)<=r^2) = 0;

% % Create structuring element B
B = 255 - A;
end

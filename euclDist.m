function d = euclDist( xyt )
%x = EUCLDIST(XYT) returns Euclidean distances between points
% ===== AUX Function =====
%
%   XYT array with X,Y x T dimensions

% DICOT (CyCelS lab, IISER Pune)

xyt= double(xyt);
n = size(xyt,1);
d= [];
for s = 1:n-1 % slow [Y] _implement_array_operation
    d= [d;((xyt(s+1,1)-xyt(s,1))^2 + (xyt(s+1,2)-xyt(s,2))^2)^0.5];
end
end

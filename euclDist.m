%Chaitanya Athale 07-02-2013
%Function takes a time series of x and y coords
%time encoded in rows
%output: euclidean distance of n-1 time pts given n=total time
function d = euclDist( xyt )
 xyt= double(xyt);
n = size(xyt,1);
 d= [];
 for s = 1:n-1
     d= [d;((xyt(s+1,1)-xyt(s,1))^2 + (xyt(s+1,2)-xyt(s,2))^2)^0.5];
 end

 end
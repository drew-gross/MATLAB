function [ plist ] = points_on_line( p1, p2 )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
     deltax = p2(1) - p1(1);
     deltay = p2(2) - p1(2);
     
     plist = [];
     
     error = 0;
     
     y = p1(2);
     x = p1(1);
     
     if(deltax == 0)
         while ((y - p2(2)) ~= 0)
             plist = [plist ; x y];
             y = y + sign(deltay);
         end
     else
         deltaerr = abs (deltay / deltax);    % Assume deltax != 0 (line is not vertical)
 
         %While we havn't iterated through all the points
         while (x - p2(1)) ~= 0
             plist = [plist ; x y];
 
             error = error + deltaerr;
             while error >= 0.5
                 y = y + sign(deltay);
                 plist = [plist ; x y];
                 error = error - 1.0;
             end
 
             x = x + sign(deltax);
         end
     end
end
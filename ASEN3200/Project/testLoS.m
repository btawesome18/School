function inLoS = testLoS(r_site,r_sc,elevation_limit)
%DESCRIPTION: Determines whether the spacecraft is within line-of-sight
%(LoS) of the site given an elevation limit
%
%INPUT:
% r_site            The position vector of the site (km, 3x1)
% r_sc              The position vector of the spacecraft (km, 3x1)
% elevation_limit   Lower elevation limit (above the horizon) (rad)
%
%OUTPUT: 
% inLoS             A boolean flag (0 or 1); 1 indicates the spacecraft and
%                   the site have line-of-sight

inLoS = 0;

siteHat = r_site/norm(r_site);
vec = r_sc-r_site;
vecHat = vec/norm(vec);
angle = asin(dot(siteHat,vecHat));

if (angle>elevation_limit)
    inLoS = 1;
end


end
%1) Compute whether the site and spacecraft have line of sight (hint, I
%suggest drawing a picture and writing this constraint as an inequality
%using a dot product)
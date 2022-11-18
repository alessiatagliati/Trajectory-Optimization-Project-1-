function [alphaorto] = ortoangle(xA,yA,zA,xB,yB,zB)
normA = sqrt(xA^2 + yA^2 + zA^2)
normB = sqrt(xB^2 + yB^2 + zB^2)

alphaorto = acos((xA*xB + yA*yB + zA*zB)/(normA*normB)) %radians
end
function [givry] = givrycorrection(lambdaA,lambdaB,phiA,phiB)
phim = 0.5*(phiA+phiB);

givry = abs(lambdaA-lambdaB)*0.5*sind(phim) %degrees
end
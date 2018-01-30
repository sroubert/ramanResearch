function [heterogeneity] = calcHet(results)

hist = histfit(results,11);

[sig,mu] = gaussfit(hist(2).XData,hist(2).YData);

heterogeneity = 2*sig*sqrt(2)*log(2);

end
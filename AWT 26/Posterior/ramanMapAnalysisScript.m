function ramanMapAnalysisScript()

ramanFiles = dir('*.txt');

results = {};

pmmaFile = '/Users/SRoubert/Documents/Research/Posterior/PMMA/pmmaAWT26_Copy.txt';

pmma = pmmanormalizer2(dlmread(pmmaFile));

for j = 1:length(ramanFiles)
    
    ramanData = dlmread(ramanFiles(j).name);
    % dlmread('C:\Users\Jonah\Downloads\Summer 2017 (5)\Summer 2017\PMW 3\Anterior\lineScan_Copy.csv') ;
    
    ind1 = 1 ;
    [n1, ~] = size( ramanData ) ;
    mats = {} ;
    xandY = {} ;
    tempResults = [];
    
    while ind1 <= n1
        
        a1 = find( ramanData(:,1) == ramanData(ind1,1) & ramanData(:,2) == ramanData(ind1,2) ) ;
        mats{end+1} = ramanData(a1,3:4) ;
        
        ind1 = a1(end) + 1 ;
        
    end
    
    for b = 1 : length(mats)
        tempResults = [tempResults; ramanAnalysis6withindexeditET2017_updated_11_16_17(mats{b},pmma)];
    end
    
    results{end+1} = tempResults;
    
end


subplot(2,3,1)

% %histogram to see heterogeneity of output
% h1 = histfit(tempResults(:,1),11); %two parts: data in histogram & curve
% 
% %only interested in curve
% [minMatProlineFitSigma,minMatProlineFitMu] = gaussfit(h1(2).XData, h1(2).YData);

fwhmMinMat = calcHet(tempResults(:,1));
title('HydroxPro')

subplot(2,3,2)

fwhmAm3 = calcHet(tempResults(:,2));
title('Am3')

subplot(2,3,3)

fwhmAm1 = calcHet(tempResults(:,3));
title('Am1')

subplot(2,3,4)

fwhmCryst = calcHet(tempResults(:,4));
title('Cryst')

subplot(2,3,5)

fwhmCarbPhos = calcHet(tempResults(:,5));
title('CarbPhos')

subplot(2,3,6)

fwhmCollMat = calcHet(tempResults(:,6));
title('CollMat')

ramanHet = [fwhmMinMat fwhmAm3 fwhmAm1 fwhmCryst fwhmCarbPhos fwhmCollMat];

%2*minMatProlineFitSigma*sqrt(2)*log(2)
%another measure

% subplot(2,3,2)
% 
% %histogram to see heterogeneity of output
% h2 = histfit(tempResults(:,),11); %two parts: data in histogram & curve
% 
% %only interested in curve
% [minMatProlineFitSigma,minMatProlineFitMu] = gaussfit(h1(2).XData, h1(2).YData);
% 
% fwhmMinMat = 2*minMatProlineFitSigma*sqrt(2)*log(2)
% %another measure


ramanParamAvg = mean( tempResults(:,1:6) );
ramanPeaks = mean( tempResults(:,7:12) );
ramanParamStd = std ( tempResults(:,:) );

ramanOutput = [ramanParamAvg; ramanPeaks;
    ramanHet];

assignin('base','ramanOuput',ramanOutput)


end

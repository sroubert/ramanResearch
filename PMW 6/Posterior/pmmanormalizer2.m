function [output] = pmmanormalizer2(pmma)
%This function baselines and normalizes a Raman pmma spectrum taken with the
%Renishaw InVia Raman instrument. Column 1 should be wavenumbers, and
%column 2 should be intensity

%finding indices for baselining and normalizing
wnindex=pmma(:,1);

wn1818index=find(wnindex<1818,1);
wn1795index=find(wnindex<1795,1);
wn811index=find(wnindex<811,1);
wn773index=find(wnindex<726,1);
wn813index=find(wnindex<813,1);

%smoothing with a moving average
pmma(:,2) = smooth(pmma(:,2));

%linear baselining from the values at ~800 and ~1800

%how is this linear baselining? Finding the baseline value by finding the
%minimum value and then making that the "zero"?

[lowNum, lowBase] = min(pmma(wn1818index:wn1795index, 2));
[highNum, highBase] = min(pmma(wn811index:wn773index, 2));

%why this change?
lowBase = lowBase + (wn1818index-1);
highBase = highBase + (wn811index-1);

%two values stored, the minimum wavenumber along low base and high base,
%why? Then the nums consist of the intensity
bases = [pmma(lowBase, 1) pmma(highBase, 1)];
nums = [lowNum highNum];

fitBits = polyfit(bases, nums, 1);
baseline = polyval(fitBits, pmma(:, 1));

pmma(:, 2) = pmma(:, 2) - baseline;

%normalizing to 813.2 wavenumber
normalizer = pmma(wn813index, 2);
for i=1:length(pmma(:,1))
    pmma(i, 2) = pmma(i, 2)/normalizer;
end

output = pmma;

end
        

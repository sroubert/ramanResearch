%The following script analyzes raman samples of bone centered at 1300
%utilizing the ramanAnalysisExternal & pmmanormalizer2 functions.

%%
%dealing with PMMA

%extract the .txt file of the PMMA sample you're working with in the
%region. Example: using the PMMA scan of region 1 for all the raman samples
%in that region.

%extract
PMMA = dlmread('pmmaAnterior.txt');

%normalize
normPMMA = pmmanormalizer2(PMMA);

%%
%analysis

sample1Region1 = ramanAnalysis6withindexeditET2017_updated_7_7_17_with_norm(normPMMA)


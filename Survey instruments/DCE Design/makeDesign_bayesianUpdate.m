%%%make choices

%designate the dimensions of the choice set

numAttributes = 5;  %this should match the number of variables/attributes below
numSets = 20;  %this should be DIVISIBLE evenly by the number of levels of all attributes

%designate the variables here, and their attributes

var1 = [0 .25 .5 .75 1]; %soil cons fraction
var2 = [0.9 1 1.1 1.2]; %earnings typical year (% of status quo)
var3 = [0.4 0.6 0.8 0.9]; %earnings bad year (% of typical earnings)
var4 = [0.1 0.3 0.5]; % fraction of effort for own farm
var5 = [0.1 0.3 0.5]; % fraction of effort for community farm

%designate the signs of the attributes: -1 means increasing attributes are
%expected to DECREASE utility; 1 means increasing attributes are expected
%to INCREASE utility; 0 indicates you have no idea

varSigns = [0 1 1 -1 -1];

varSignMat = ones(numSets,1) * varSigns;

%define the number of alternatives

alternative1 = zeros(numSets,numAttributes);
alternative2 = zeros(numSets,numAttributes);

%fill out the alternatives with candidate levels
for indexI = 1:numSets;
   alternative1(indexI,:) = [var1(ceil(indexI/numSets*length(var1))) ...
       var2(ceil(indexI/numSets*length(var2))) ...
       var3(ceil(indexI/numSets*length(var3))) ...
       var4(ceil(indexI/numSets*length(var4))) ...
       var5(ceil(indexI/numSets*length(var5)))];
   alternative2(indexI,:) = [var1(ceil(indexI/numSets*length(var1))) ...
       var2(ceil(indexI/numSets*length(var2))) ...
       var3(ceil(indexI/numSets*length(var3))) ...
       var4(ceil(indexI/numSets*length(var4))) ...
       var5(ceil(indexI/numSets*length(var5)))];
    
end

%make an index of each alternative, to be used in randomizations

currentPermutation1 = zeros(numSets, numAttributes);
currentPermutation2 = zeros(numSets, numAttributes);
currentPermutation1(:) = 1:prod(size(currentPermutation1));
currentPermutation2(:) = 1:prod(size(currentPermutation2));

%for clarity, write out (in comments here) the terms used for the utility
%function:

%V = f(     V1,V2,V3,V4,V5, ...   (main effects)


%           (5 terms in total)

%now create the multiplier matrix for constructing this from variables

numTerms = 5;
utilityMat = zeros(numAttributes,numTerms);
utilityMat(1:5,1:5) = eye(5);
%utilityMat([1 2],8) = 1;
%utilityMat([2 3],9) = 1;
%utilityMat([1 3],10) = 1;

utilityMat = logical(utilityMat);
%enter the priors for all terms in the utility function

priors = [0 0 0 0 0];


%%%% start loop

numIteration = 100000;
best = 1000000000000;
for indexI = 1:numIteration
    
    %%%%%%randomize design, check that it is good
    stillLooking = 1;
    
    numTries = 0;
    while(stillLooking)
        badChoices = 0;
        numTries = numTries + 1;
        
       for indexJ = 1:numAttributes
           currentPermutation1(:,indexJ) = currentPermutation1(randperm(numSets),indexJ);
           currentPermutation2(:,indexJ) = currentPermutation2(randperm(numSets),indexJ);
       end
       
       currentAlternative1 = alternative1(currentPermutation1);
       currentAlternative2 = alternative1(currentPermutation2);
       
       signDiff = sign(currentAlternative1 - currentAlternative2);
       signDiff = varSignMat .* signDiff;  %this orders all attributes consistently from favorable to unfavorable

       %if all signs are 0, the two choices are the same - bad
       
       %also, if all signs across a row are the same or 0, this is a strictly
       %dominated choice (i.e., one alternative will always be
       %preferred).  
       
       %in any of these cases, we have to discard this whole set of options
       %(can't pick and choose the ones we like within these options,
       %have to start over)

       dominatedChoices = sum(abs(sum(signDiff,2)) ==  sum(abs(signDiff),2));

       if(dominatedChoices > 0) 
           badChoices = 1;
       end
       
       %%%%%ADD IN ANY OTHER RULES HERE THAT ARE SPECIFIC TO YOUR UTILITY
       %%%%%FUNCTION!!!!
       
       
       % %additional rule - requirements (cols 1-4) can't all be zero
       % GoodWorseThanBad = sum(currentAlternative1(:,2) > currentAlternative1(:,3)) + sum(currentAlternative2(:,2) > currentAlternative2(:,3));
       % if(GoodWorseThanBad > 0)
       %     badChoices = 1;
       % end
       
       if(badChoices == 0) %i.e., all choices passed this criteria
           stillLooking = 0; %we've got a good set, move on
       end
    end
    

    %now we need the full utility model with all terms, not just the
    %variables themselves
    
    
    currentAlternative1_utility = currentAlternative1;
    currentAlternative2_utility = currentAlternative2;
    
    currentUtility1 = ones(numSets, numTerms);
    currentUtility2 = ones(numSets, numTerms);
    for indexJ = 1:size(utilityMat,1)
        currentRow = utilityMat(indexJ,:);
        numColumns = sum(currentRow);
        currentUtility1(:,currentRow) = currentUtility1(:,currentRow) .* (currentAlternative1_utility(:,indexJ) * ones(1,numColumns));
        currentUtility2(:,currentRow) = currentUtility2(:,currentRow) .* (currentAlternative2_utility(:,indexJ) * ones(1,numColumns));
    end
    
    %%%%%%calculate d-error

    v_js_1 = currentUtility1 * priors';
    v_js_2 = currentUtility2 * priors';

    exp_v_1 = exp(v_js_1);
    exp_v_2 = exp(v_js_2);

    sumExpV_1 = exp_v_1 + exp_v_2;
    sumExpV_2 = sumExpV_1;

    p_js_1 = exp_v_1 ./ sumExpV_1;
    p_js_2 = exp_v_2 ./ sumExpV_2;

    x_p_1 =  (p_js_1 * ones(1, numTerms)) .* currentUtility1;
    x_p_2 =  (p_js_2 * ones(1, numTerms)) .* currentUtility2;

    sum_x_p_1 = x_p_1 + x_p_2;
    sum_x_p_2 = sum_x_p_1;

    mat_1 = (currentUtility1 - sum_x_p_1) .* ((p_js_1.^0.5) * ones(1,numTerms));
    mat_2 = (currentUtility2 - sum_x_p_2) .* ((p_js_2.^0.5) * ones(1,numTerms));

    mat_full = zeros(numSets * 2, numTerms);
    mat_full(1:2:end,:) = mat_1;
    mat_full(2:2:end,:) = mat_2;

    fisher = mat_full'*mat_full;

    avc = inv(fisher);

    dError = det(avc)^(1/numTerms);

    
    if(dError < best)
       bestAlt1 = currentAlternative1;
       bestAlt2 = currentAlternative2;
       best = dError;
       
       data = zeros(numSets * 2, numAttributes);
       data(1:2:end,:) = currentAlternative1;
       data(2:2:end,:) = currentAlternative2;
       
       fprintf(['Found Good Set Iteration ' num2str(indexI) ' after ' num2str(numTries) ' tries, D-error = ' num2str(dError) ', Saving.' ' \n']);

       save bestChoiceData_updated data signDiff best
    end
    
end

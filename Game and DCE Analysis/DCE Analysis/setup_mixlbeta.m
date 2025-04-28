clear all
load bestChoiceData_updated.mat
dce_data = readtable('dce_choices.xlsx');
dce_post_data = readtable('dce_post_choices.xlsx');

%the variable 'data' has the choice sets from 1 to 15 in order, with option
%1 on one row and option 2 on the next, for a total of 30 rows

%we need to make a dataset with one row for each choice option, with vars:
%id - unique id of each respondent (should have 15 repeats)
%group - unique id of each choice event (should have 3 repeats)
%choice - 0 if not selected; 1 if selected
%frac_vanilla - attribute 1
%frac_mixed - attribute 2
%value_mixed - attribute 3


dce_post_data.rightKey = dce_post_data.x_ENTERTHECHOICESETIDENTIFIERNUMBERYOUWROTEDOWNFORTHISPARTICIPA;
dce_data.leftKey = str2double(dce_data.earnings_ID_pair);

joinedData = innerjoin(dce_data,dce_post_data,"LeftKeys","leftKey","RightKeys","rightKey");

baseKsh = 10000;
fullArray = zeros(height(joinedData) * 4 * 3, 8);

set1 = str2double(joinedData.set1_dce_data);
set2 = str2double(joinedData.set2_dce_data);
set3 = str2double(joinedData.set3_dce_data);
set4 = str2double(joinedData.set4_dce_data);
set5 = str2double(joinedData.set1_dce_post_data);
set6 = str2double(joinedData.set2_dce_post_data);
set7 = str2double(joinedData.set3_dce_post_data);
set8 = str2double(joinedData.set4_dce_post_data);

set1_mult = ceil(set1/ 20);
set2_mult = ceil(set2/ 20);
set3_mult = ceil(set3/ 20);
set4_mult = ceil(set4/ 20);
set5_mult = ceil(set5/ 20);
set6_mult = ceil(set6/ 20);
set7_mult = ceil(set7/ 20);
set8_mult = ceil(set8/ 20);

set1 = mod(set1, 20);
set2 = mod(set2, 20);
set3 = mod(set3, 20);
set4 = mod(set4, 20);
set5 = mod(set5, 20);
set6 = mod(set6, 20);
set7 = mod(set7, 20);
set8 = mod(set8, 20);

set1(set1 == 0) = 20;
set2(set2 == 0) = 20;
set3(set3 == 0) = 20;
set4(set4 == 0) = 20;
set5(set5 == 0) = 20;
set6(set6 == 0) = 20;
set7(set7 == 0) = 20;
set8(set8 == 0) = 20;

earnings = joinedData.earnings;
bad_earnings = joinedData.bad_earnings;
time_self = joinedData.TimeSpentDoingFarmingForSelf /10;
time_share = joinedData.TimeSpentDoingFarmingForSharedGroup /10;
cons_frac = joinedData.ThankYou_NowIHaveOneLastQuestionToAskThatWillSetUsUpForOurExper;

temp = zeros(size(cons_frac));
temp(strmatch('none', cons_frac)) = 0;
temp(strmatch('a quarter', cons_frac)) = 0.25;
temp(strmatch('a half', cons_frac)) = 0.5;
temp(strmatch('three quarters', cons_frac)) = 0.75;
temp(strmatch('nearly all or all', cons_frac)) = 1;
cons_frac = temp;

joinedData.choice1 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FROMT;
joinedData.choice2 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_1;
joinedData.choice3 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_2;
joinedData.choice4 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_3;
joinedData.choice5 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_4;
joinedData.choice6 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_5;
joinedData.choice7 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_6;
joinedData.choice8 = joinedData.x_INTRODUCEBOTHHYPOTHETICALOPTIONS_INCLUDINGALLATTRIBUTES_FRO_7;

temp = zeros(size(joinedData.choice1));
temp(strmatch('Option 1', joinedData.choice1)) = 1;
temp(strmatch('Option 2', joinedData.choice1)) = 2;
temp(strmatch('Status Quo', joinedData.choice1)) = 3;
joinedData.choice1 = temp;

temp = zeros(size(joinedData.choice2));
temp(strmatch('Option 1', joinedData.choice2)) = 1;
temp(strmatch('Option 2', joinedData.choice2)) = 2;
temp(strmatch('Status Quo', joinedData.choice2)) = 3;
joinedData.choice2 = temp;

temp = zeros(size(joinedData.choice3));
temp(strmatch('Option 1', joinedData.choice3)) = 1;
temp(strmatch('Option 2', joinedData.choice3)) = 2;
temp(strmatch('Status Quo', joinedData.choice3)) = 3;
joinedData.choice3 = temp;

temp = zeros(size(joinedData.choice5));
temp(strmatch('Option 1', joinedData.choice5)) = 1;
temp(strmatch('Option 2', joinedData.choice5)) = 2;
temp(strmatch('Status Quo', joinedData.choice5)) = 3;
joinedData.choice5 = temp;

temp = zeros(size(joinedData.choice6));
temp(strmatch('Option 1', joinedData.choice6)) = 1;
temp(strmatch('Option 2', joinedData.choice6)) = 2;
temp(strmatch('Status Quo', joinedData.choice6)) = 3;
joinedData.choice6 = temp;

temp = zeros(size(joinedData.choice7));
temp(strmatch('Option 1', joinedData.choice7)) = 1;
temp(strmatch('Option 2', joinedData.choice7)) = 2;
temp(strmatch('Status Quo', joinedData.choice7)) = 3;
joinedData.choice7 = temp;

temp = zeros(size(joinedData.choice8));
temp(strmatch('Option 1', joinedData.choice8)) = 1;
temp(strmatch('Option 2', joinedData.choice8)) = 2;
temp(strmatch('Status Quo', joinedData.choice8)) = 3;
joinedData.choice8 = temp;

temp = zeros(size(joinedData.choice4));
temp(strmatch('Option 1', joinedData.choice4)) = 1;
temp(strmatch('Option 2', joinedData.choice4)) = 2;
temp(strmatch('Status Quo', joinedData.choice4)) = 3;
joinedData.choice4 = temp;

earnings = str2double(earnings);
bad_earnings = str2double(bad_earnings);

id_size = 24;
group_size = 5;

id = 1;
group = 1;
for indexI = 1:height(joinedData)
    %label all 15 rows for this person
    fullArray((indexI - 1)*id_size + 1: indexI*id_size,1) = joinedData.leftKey(id);
    id = id + 1;

    %label the 3 rows of all 8 choice sets for this person
    fullArray((indexI - 1)*id_size + 1:(indexI-1)*id_size + 3,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 4:(indexI-1)*id_size + 6,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 7:(indexI-1)*id_size + 9,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 10:(indexI-1)*id_size + 12,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 13:(indexI-1)*id_size + 15,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 16:(indexI-1)*id_size + 18,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 19:(indexI-1)*id_size + 21,2) = group;
    group = group + 1;
    fullArray((indexI - 1)*id_size + 22:(indexI-1)*id_size + 24,2) = group;
    group = group + 1;

    %add in the appropriate choice set values from the 'data' variable
    fullArray((indexI - 1)*id_size + 1:(indexI-1)*id_size + 2,4:8) = data((set1(indexI)-1)*2+1:set1(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 4:(indexI-1)*id_size + 5,4:8) = data((set2(indexI)-1)*2+1:set2(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 7:(indexI-1)*id_size + 8,4:8) = data((set3(indexI)-1)*2+1:set3(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 10:(indexI-1)*id_size + 11,4:8) = data((set4(indexI)-1)*2+1:set4(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 13:(indexI-1)*id_size + 14,4:8) = data((set5(indexI)-1)*2+1:set5(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 16:(indexI-1)*id_size + 17,4:8) = data((set6(indexI)-1)*2+1:set6(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 19:(indexI-1)*id_size + 20,4:8) = data((set7(indexI)-1)*2+1:set7(indexI)*2,:);
    fullArray((indexI - 1)*id_size + 22:(indexI-1)*id_size + 23,4:8) = data((set8(indexI)-1)*2+1:set8(indexI)*2,:);



    %add in the appropriate status quo values
    fullArray((indexI - 1)*id_size + [3 6 9 12 15 18 21 24], 4) = cons_frac(indexI);
    fullArray((indexI - 1)*id_size + [3 6 9 12 15 18 21 24], 5) = earnings(indexI);
    fullArray((indexI - 1)*id_size + [3 6 9 12 15 18 21 24], 6) = bad_earnings(indexI);
    fullArray((indexI - 1)*id_size + [3 6 9 12 15 18 21 24], 7) = time_self(indexI);
    fullArray((indexI - 1)*id_size + [3 6 9 12 15 18 21 24], 8) = time_share(indexI);

    %add in the choice made
    fullArray((indexI - 1)*id_size + joinedData.choice1(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 3 + joinedData.choice2(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 6 + joinedData.choice3(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 9 + joinedData.choice4(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 12 + joinedData.choice5(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 15 + joinedData.choice6(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 18 + joinedData.choice7(indexI),3) = 1;
    fullArray((indexI - 1)*id_size + 21 + joinedData.choice8(indexI),3) = 1;

end

fullArray(1:id_size:end,5) = fullArray(1:id_size:end,5) .* set1_mult * baseKsh;
fullArray(2:id_size:end,5) = fullArray(2:id_size:end,5) .* set1_mult * baseKsh;
fullArray(4:id_size:end,5) = fullArray(4:id_size:end,5) .* set2_mult * baseKsh;
fullArray(5:id_size:end,5) = fullArray(5:id_size:end,5) .* set2_mult * baseKsh;
fullArray(7:id_size:end,5) = fullArray(7:id_size:end,5) .* set3_mult * baseKsh;
fullArray(8:id_size:end,5) = fullArray(8:id_size:end,5) .* set3_mult * baseKsh;
fullArray(10:id_size:end,5) = fullArray(10:id_size:end,5) .* set4_mult * baseKsh;
fullArray(11:id_size:end,5) = fullArray(11:id_size:end,5) .* set4_mult * baseKsh;
fullArray(13:id_size:end,5) = fullArray(13:id_size:end,5) .* set5_mult * baseKsh;
fullArray(14:id_size:end,5) = fullArray(14:id_size:end,5) .* set5_mult * baseKsh;
fullArray(16:id_size:end,5) = fullArray(16:id_size:end,5) .* set6_mult * baseKsh;
fullArray(17:id_size:end,5) = fullArray(17:id_size:end,5) .* set6_mult * baseKsh;
fullArray(19:id_size:end,5) = fullArray(19:id_size:end,5) .* set7_mult * baseKsh;
fullArray(20:id_size:end,5) = fullArray(20:id_size:end,5) .* set7_mult * baseKsh;
fullArray(22:id_size:end,5) = fullArray(22:id_size:end,5) .* set8_mult * baseKsh;
fullArray(23:id_size:end,5) = fullArray(23:id_size:end,5) .* set8_mult * baseKsh;

fullArray(1:id_size:end,6) = round(fullArray(1:id_size:end,6) .* fullArray(1:id_size:end,5) / 1000) * 1000;
fullArray(2:id_size:end,6) = round(fullArray(2:id_size:end,6) .* fullArray(2:id_size:end,5) / 1000) * 1000;
fullArray(4:id_size:end,6) = round(fullArray(4:id_size:end,6) .* fullArray(4:id_size:end,5) / 1000) * 1000;
fullArray(5:id_size:end,6) = round(fullArray(5:id_size:end,6) .* fullArray(5:id_size:end,5) / 1000) * 1000;
fullArray(7:id_size:end,6) = round(fullArray(7:id_size:end,6) .* fullArray(7:id_size:end,5) / 1000) * 1000;
fullArray(8:id_size:end,6) = round(fullArray(8:id_size:end,6) .* fullArray(8:id_size:end,5) / 1000) * 1000;
fullArray(10:id_size:end,6) = round(fullArray(10:id_size:end,6) .* fullArray(10:id_size:end,5) / 1000)* 1000;
fullArray(11:id_size:end,6) = round(fullArray(11:id_size:end,6) .* fullArray(11:id_size:end,5) / 1000) * 1000;
fullArray(13:id_size:end,6) = round(fullArray(13:id_size:end,6) .* fullArray(13:id_size:end,5) / 1000)* 1000;
fullArray(14:id_size:end,6) = round(fullArray(14:id_size:end,6) .* fullArray(14:id_size:end,5) / 1000) * 1000;
fullArray(16:id_size:end,6) = round(fullArray(16:id_size:end,6) .* fullArray(16:id_size:end,5) / 1000)* 1000;
fullArray(17:id_size:end,6) = round(fullArray(17:id_size:end,6) .* fullArray(17:id_size:end,5) / 1000) * 1000;
fullArray(19:id_size:end,6) = round(fullArray(19:id_size:end,6) .* fullArray(19:id_size:end,5) / 1000)* 1000;
fullArray(20:id_size:end,6) = round(fullArray(20:id_size:end,6) .* fullArray(20:id_size:end,5) / 1000) * 1000;
fullArray(22:id_size:end,6) = round(fullArray(22:id_size:end,6) .* fullArray(22:id_size:end,5) / 1000)* 1000;
fullArray(23:id_size:end,6) = round(fullArray(23:id_size:end,6) .* fullArray(23:id_size:end,5) / 1000) * 1000;

fullArray(:,9) = 2;
fullArray(1:id_size:end,9) = 1;
fullArray(2:id_size:end,9) = 1;
fullArray(3:id_size:end,9) = 1;
fullArray(4:id_size:end,9) = 1;
fullArray(5:id_size:end,9) = 1;
fullArray(6:id_size:end,9) = 1;
fullArray(7:id_size:end,9) = 1;
fullArray(8:id_size:end,9) = 1;
fullArray(9:id_size:end,9) = 1;
fullArray(10:id_size:end,9) = 1;
fullArray(11:id_size:end,9) = 1;
fullArray(12:id_size:end,9) = 1;

fullTable = array2table(fullArray, 'VariableNames',{'id','group','choice','cons_frac','earnings','bad_earnings', 'time_self', 'time_share','pre_post'});
writetable(fullTable,'choice_data_stata.csv');
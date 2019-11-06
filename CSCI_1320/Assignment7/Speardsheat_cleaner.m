[~,~,data]=xlsread("quiz_results.xlsx");



for(i = 7:23)
    
    key(1,(i-6)) = data{2,i};
    
    
end    

for(i = 3:103)
    
    studentID((i-2),:) = data(i,2);
    easyScoreCell((i-2),:) = data(i,5);
    
end    

easyScore = cell2mat(easyScoreCell);


QuizPick = data(3:103,7:23);

clear easyScoreCell;
clear data;
clear i;

save("clean.mat");

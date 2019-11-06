load("clean.mat");

student_quizSum = zeros(1,101);

for i = 1:101
    quizRow = 0;
    for j = 1:17
        if (QuizPick{i,j}==key(j))
            
            quizRow = quizRow + 1;            
        end
        
    end
    student_quizSum(i)=quizRow;
end

quizPercent = (60/17)*student_quizSum;
eassyPercent = (40/15)*easyScore;
eassyPercent = eassyPercent';

scoreF = eassyPercent + quizPercent;
LetterGrade = cell(1,101);
for i = 1:101
   if(scoreF(i) >= 93)
       LetterGrade{i} = 'A';
   elseif (scoreF(i)>=90)
       LetterGrade{i} = 'A-';
   elseif (scoreF(i)>=87)
       LetterGrade{i} = 'B+';
   elseif (scoreF(i)>=83)
       LetterGrade{i} = 'B';
   elseif (scoreF(i)>=80)
       LetterGrade{i} = 'B-';
   elseif (scoreF(i)>=77)
       LetterGrade{i} = 'C+';
   elseif (scoreF(i)>=73)
       LetterGrade{i} = 'C';
   elseif (scoreF(i)>=70)
       LetterGrade{i} = 'C-';
   elseif (scoreF(i)>=67)
       LetterGrade{i} = 'D+';
   elseif (scoreF(i)>=63)
       LetterGrade{i} = 'D';
   elseif (scoreF(i)>=60)
       LetterGrade{i} = 'D-';
   else 
      LetterGrade{i} = 'F';
   end 
end
for i = 1:101
   
    fprintf('Student: %s Got %s \n',studentID{i},LetterGrade{i});
    
end
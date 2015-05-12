clear all;
close all;
clc;
while(1==1)
    choice=menu('Gender Detection',...
                'Choose Database & Calculate Recognition Rate',...
                'Recognize from audio file',...
                'Recognize by recording',...
                'Exit');
    if (choice ==1)
       gendata();
    end
    if (choice == 2)
        gendetect();
    end
        if (choice == 3)
                genderrec();
        end 
        if (choice == 4)
        clear choice choice2
        return;
    end    
end
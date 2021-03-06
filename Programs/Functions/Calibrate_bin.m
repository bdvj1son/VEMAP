function [p_L,p_R,r_L,r_R] = Calibrate_bin(CalData_L,CalData_R,CalPoints_L,CalPoints_R)

color = {'b' 'g' 'r' 'y' 'o' 'bl'};
ReselectCalibMean = 0;
hFig=figure;
screen_size = get(0, 'ScreenSize');
set(hFig,'Position',[0 0 screen_size(3) screen_size(4)]);
LEpt1 = 1; LEpt2 = 500;
REpt1 = 1; REpt2 = 500;
    
while ReselectCalibMean ~= 3

    % Left Eye
    CalibSP1 = subplot(2,2,1);
    hold on
    for i = 1:length(CalData_L)
    plot(CalData_L{i}(2,:),color{i})
    end
    title('Left Eye  Horizontal')
    ylim([-5 5])
    ylabel('Volts')
    xlabel('Samples')
    
    % Right Eye
    CalibSP2 = subplot(2,2,2);
    hold on
    for i = 1:length(CalData_R)
    plot(CalData_R{i}(1,:),color{i})
    end
    title('Right Eye Horizontal')
    ylim([-5 5])
    ylabel('Volts')
    xlabel('Samples')
    
    subplot(2,2,3)
    cla

    LE_MeanCalibVolts(1,:) = [mean(CalData_L{1}(2,LEpt1:LEpt2)),...
        mean(CalData_L{2}(2,LEpt1:LEpt2)),...
        mean(CalData_L{3}(2,LEpt1:LEpt2))];
    
    [LE_R,LE_PVAL] = corrcoef(LE_MeanCalibVolts(1,:),CalPoints_L);
    LE_CorrCoef(1,:) = LE_R(1,2);
    LE_CalibFit(1,:) = polyfit(LE_MeanCalibVolts(1,:),CalPoints_L,1);
    f = polyval(LE_CalibFit(1,:),LE_MeanCalibVolts(1,:));
    
    plot(LE_MeanCalibVolts(1,:),CalPoints_L);
    hold on
    plot(LE_MeanCalibVolts(1,:),f,'r');
    R = mat2str(LE_CorrCoef(1));
    m = mat2str(LE_CalibFit(1,1));
    b = mat2str(LE_CalibFit(1,2));
    title({['R^2 = ',R(1:5),'        y = ',...
        m(1:4),'x + ',b(1:4)]})
    ylabel('Degrees')
    xlabel('Volts')
    
    % Right Eye
    subplot(2,2,4)
    cla
    RE_MeanCalibVolts(1,:) = [mean(CalData_R{1}(1,REpt1:REpt2)),...
        mean(CalData_R{2}(1,REpt1:REpt2)),...
        mean(CalData_R{3}(1,REpt1:REpt2))];
    [RE_R,RE_PVAL] = corrcoef(RE_MeanCalibVolts(1,:),CalPoints_R);
    RE_CorrCoef(1,:) = RE_R(1,2);
    RE_CalibFit(1,:) = polyfit(RE_MeanCalibVolts(1,:),CalPoints_R,1);
    f = polyval(RE_CalibFit(1,:),RE_MeanCalibVolts(1,:));
    
    plot(RE_MeanCalibVolts(1,:),CalPoints_R);
    hold on
    plot(RE_MeanCalibVolts(1,:),f,'r');
    R = mat2str(RE_CorrCoef(1));
    m = mat2str(RE_CalibFit(1,1));
    b = mat2str(RE_CalibFit(1,2));
    title({['R^2 = ',R(1:5),'        y = ',...
        m(1:4),'x + ',b(1:4)]})
    ylabel('Degrees')
    xlabel('Volts')
    
    
    % Menu
    ReselectCalibMean = menu('Reselect data to calculate calibration mean',...
         'Left Eye Horiz','Right Eye Horiz','Done');

        if ReselectCalibMean == 1
%             gcf(CalibSP1)
            [TmpX,TmpY] = ginput(2);
            LEpt1= round(TmpX(1));
            LEpt2= round(TmpX(2));  
        elseif ReselectCalibMean == 2
%             gcf(CalibSP2)
            [TmpX,TmpY] = ginput(2);
            REpt1= round(TmpX(1));
            REpt2= round(TmpX(2));
        end

    
%     if strcmp(CalibOption,'Type') == 1
%         if ReselectCalibMean == 1
%             TmpX = inputdlg('Input new range for calibration','New Calibration Range');
%             TmpX = str2num(TmpX{:});
%             LEpt1= TmpX(1);
%             LEpt2= TmpX(2);
%         end
%         
%         if ReselectCalibMean == 2
%             TmpX = inputdlg('Input new range for calibration','New Calibration Range');
%             TmpX = str2num(TmpX{:});
%             REpt1= TmpX(1);
%             REpt2= TmpX(2);
%         end
%     end
end

% Output Data
p_L = LE_CalibFit;
p_R = RE_CalibFit;
r_L = LE_CorrCoef';
r_R = RE_CorrCoef';

close
end
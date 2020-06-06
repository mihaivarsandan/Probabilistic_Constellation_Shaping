function [Results] = Display(Results,TX,Channel,DSP,Signal)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here


%% OUTPUT
switch Results.Transmission_Goal
    case{'BER'}
%         if TX.QAM.Probabilistic_Shaping==1 
%         figure()
%         size([real(Signal.Symbols_TX_Complex{1}(1,:));imag(Signal.Symbols_TX_Complex{1}(1,:))])
%         size(imag(Signal.Symbols_TX_Complex{1}(1,:)))
%         hist3([real(Signal.Symbols_TX_Complex{1}(1,:));imag(Signal.Symbols_TX_Complex{1}(1,:))].',[8,8])
%         end
        
% %         %figure()
%         semilogy(Results.BER_Theoretical,'-o')
%         xlabel('$E_b/N_o(dB)$','Interpreter','latex')
%         ylabel('BER')
%         ylim([10e-6,1])
%         hold on
%         semilogy(Results.BER_Practice)
        
%         figure()
        %plot(Results.MI+ones(size(Results.MI))*(6-Results.MI(26)),'-o')
        plot(Results.MI,'-o')
        hold on
        %plot(Results.Shannon)
        xlabel('$E_b/N_o(dB)$','Interpreter','latex')
        ylabel('MI')
        hold on
        
%         figure()
%         plot(Results.H_X,'-o')
%         hold on
%         plot(Results.H_Y)
%         xlabel('$E_b/N_o(dB)$','Interpreter','latex')
%         ylabel('Entropy')
        
        
    case{'Test'}
        if TX.PS.Laser_Noise_Debug==1
            figure()
            plot(TX.PS.phase_deviation(1,:))
            drawnow()
            
            Constellation_plot(DSP.Symbols_before_Compensation)
            Constellation_plot(DSP.Symbols_after_Compensation)
            
            figure()
            semilogy(DSP.Phase_Comp_Taps,Results.BER_Theoretical*ones(size(Results.BER_Practice)))
            hold on
            semilogy(DSP.Phase_Comp_Taps,Results.BER_Practice)
            ylim([10e-3,1])
            drawnow()
        end
        
        if Channel.SSFT==1
            Constellation_plot(DSP.Symbols_before_StaticEqual)
            Constellation_plot(DSP.Symbols_after_StaticEqual)
        end
        
        if Channel.Dispersion_debug==1
            Constellation_plot(DSP.Symbols_before_AdaptEqual)
            Constellation_plot(DSP.Symbols_after_AdaptEqual)
            
            figure()
            plot(DSP.Equaliser_error)
            drawnow()
        end
        
        
            
        
    case{'Pure'}
        if TX.QAM.Probabilistic_Shaping==1 
        figure()
        size([real(Signal.Symbols_TX_Complex{1}(1,:));imag(Signal.Symbols_TX_Complex{1}(1,:))])
        size(imag(Signal.Symbols_TX_Complex{1}(1,:)))
        hist3([real(Signal.Symbols_TX_Complex{1}(1,:));imag(Signal.Symbols_TX_Complex{1}(1,:))].',[8,8])
        end
        
        if TX.PS.Laser_Noise_Debug==1
%             figure()
%             plot(TX.PS.phase_deviation(1,:))
%             drawnow()
            
            Constellation_plot(DSP.Symbols_before_Compensation)
            Constellation_plot(DSP.Symbols_after_Compensation)
        end
        
        if Channel.SSFT==1
            Constellation_plot(DSP.Symbols_before_StaticEqual)
            Constellation_plot(DSP.Symbols_after_StaticEqual)
        end
        
        if Channel.Dispersion_debug==1
            Constellation_plot(DSP.Symbols_before_AdaptEqual)
            Constellation_plot(DSP.Symbols_after_AdaptEqual)
            
            figure()
            plot(DSP.Equaliser_error)
            drawnow()
        end
        
        
    otherwise
        error('Please select a valid goal for the transmission')
end
end


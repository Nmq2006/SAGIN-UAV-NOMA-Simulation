    function [h_SU_best_OMA, h_UD1_best_OMA, h_UD2_best_OMA, idx] = ...
             select_best_uav_OMA(h_SU, h_UD1, h_UD2, gamma_SU_OMA)
        
        % Chọn UAV có chất lượng chặng S -> UAV tốt nhất
        [~, idx] = max(gamma_SU_OMA);
               
        % Lấy hệ số kênh của chiếc UAV được chọn
        h_SU_best_OMA  = h_SU(idx);
        h_UD1_best_OMA = h_UD1(idx);
        h_UD2_best_OMA = h_UD2(idx);
    end

    function [h_SU_best, h_UD1_best, h_UD2_best, idx] = ...
             select_best_uav(h_SU, h_UD1, h_UD2, gamma_x1_SU, gamma_x2_SU)
             % bottleneck cho UAV 
                eta = min(gamma_x1_SU, gamma_x2_SU);
             % chọn best UAV 
                [~, idx] = max(eta);
             % lấy hệ số kênh
                h_SU_best  = h_SU(idx);
                h_UD1_best = h_UD1(idx);
                h_UD2_best = h_UD2(idx);
    end
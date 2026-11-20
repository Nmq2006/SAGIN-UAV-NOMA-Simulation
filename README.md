# SAGIN-UAV-NOMA Simulation Project

A Monte Carlo simulation and performance analysis framework for Space-Air-Ground Integrated Networks (**SAGIN**) assisted by **UAV Relay** and Non-Orthogonal Multiple Access (**NOMA**).

The project contains theoretical analyses (Closed-form and Asymptotic expressions) alongside Monte Carlo validation across 7 distinct Outage Probability (OP) evaluation scenarios.

---

## Project Structure

```
SAGIN-UAV-NOMA-Simulation/
├── MoPhong1/                     # Scenario 1: Outage Probability vs. SNR (Theory vs. Monte Carlo for D1, D2)
│   ├── calculate_channel_params.m# Channel parameter calculation
│   ├── CF_OP_D1.m                # Closed-form theoretical OP expression for D1
│   ├── CF_OP_D2.m                # Closed-form theoretical OP expression for D2
│   ├── select_best_uav.m         # Best-UAV relay selection algorithm
│   └── main.m                    # Main execution script for Scenario 1
│
├── MoPhong2/                     # Scenario 2: Impact of the number of UAV relays (N)
│   ├── CF_OP_D1.m / CF_OP_D2.m   # Theoretical OP evaluation over varying N
│   ├── sim_OP.m                  # Multi-UAV Monte Carlo simulation
│   └── main.m                    # Main execution script for Scenario 2
│
├── MoPhong3/                     # Scenario 3: High-SNR Asymptotic Analysis
│   ├── ASYM_OP_D1.m              # High-SNR asymptotic expression for D1
│   ├── ASYM_OP_D2.m              # High-SNR asymptotic expression for D2
│   └── main.m                    # Comparison: Closed-form vs. Asymptotic vs. Simulation
│
├── MoPhong4/                     # Scenario 4: Impact of power allocation coefficients (alpha_1 / alpha_2)
│   ├── CF_OP_D1.m / CF_OP_D2.m   # Theoretical OP evaluation over power ratios
│   └── main.m                    # Main execution script for Scenario 4
│
├── MoPhong5/                     # Scenario 5: Impact of UAV location and link distance (d)
│   ├── distance.m                # 3D spatial distance calculation
│   ├── lambda_gain.m             # Distance-dependent channel gain computation
│   └── main.m                    # Main execution script for Scenario 5
│
├── MoPhong6/                     # Scenario 6: Performance comparison between NOMA and OMA
│   ├── CF_OP_D1_OMA.m            # Theoretical closed-form for D1 under OMA
│   ├── CF_OP_D2_OMA.m            # Theoretical closed-form for D2 under OMA
│   ├── sim_OP_NOMA.m             # Monte Carlo simulation for NOMA scheme
│   ├── sim_OP_OMA.m              # Monte Carlo simulation for OMA baseline
│   └── main.m                    # Comparative evaluation script (NOMA vs. OMA)
│
├── MoPhong7/                     # Scenario 7: Evaluation of UAV Relay benefits (SAGIN-UAV vs. Direct Link)
│   ├── CF_OP_D1_noUAV.m          # Theoretical direct link (no UAV) analysis for D1
│   ├── CF_OP_D2_noUAV.m          # Theoretical direct link (no UAV) analysis for D2
│   ├── sim_OP_NOMA.m             # Simulation with UAV relaying assistance
│   ├── sim_OP_noUAV.m            # Simulation of direct satellite-to-ground link
│   └── main.m                    # Comparative evaluation script (UAV-assisted vs. No-UAV)
│
└── README.md                     # Project documentation
```

---

## Prerequisites

- **Software:** MATLAB R2020b or later.
- **Font Support:** `Times New Roman` (pre-configured in scripts for publication-ready figures).

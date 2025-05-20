# Optimization of calculation of VRMS for real-time applications in embedded systems within Industry 4.0 framework

This project demonstrates and compares three algorithms for computing the **velocity RMS (VRMS)** value from a synthetic acceleration signal. The signal consists of a single sine component at 159.2 Hz, sampled at 32 kHz.

## Signal Description

- **Sampling frequency**: 32,000 Hz
- **Signal duration**: 1 second
- **Frequency component**: 159.2 Hz
- **Theoretical velocity amplitude**:  
  \[
  A_v = \frac{9810}{2\pi f} = 9.8072 \, \text{mm/s}
  \]
- **Theoretical VRMS value**:  
  \[
  VRMS_{theoretical} = \sqrt{\frac{1}{2}} \cdot A_v = 6.9348 \, \text{mm/s}
  \]

---

## Script 1: Classical Time-Domain Integration

This approach uses time-domain numerical integration of the acceleration signal.

### Key Steps

1. High-pass filtering of the signal (Butterworth, order 4, 10 Hz).
2. Time-domain integration to obtain velocity.
3. DC offset removal post-integration.
4. Calculation of RMS.

### Output

- **Analytical VRMS**: `6.934754288239017 mm/s`
- **Calculated VRMS**: `6.980024376200330 mm/s`

### Accuracy

- **Error vs Theoretical**: `+0.65%`

---

## Script 2: Frequency-Domain Algorithm

This method transforms the acceleration signal using FFT, scales it to velocity, and integrates in the frequency domain.

### Key Steps

1. FFT of the signal.
2. One-sided scaling and conversion to velocity spectrum.
3. Band-pass selection from 10 Hz to 1000 Hz.
4. RMS computation using Parseval’s theorem.

### Output

- **Analytical VRMS**: `6.934754288239017 mm/s`
- **Calculated VRMS**: `6.958540507182517 mm/s`

### Accuracy

- **Error vs Theoretical**: `+0.34%`

---

## Script 3: Proposed Robust Algorithm

A robust frequency-domain method that includes:
- Downsampling,
- Fragmentation,
- Windowing,
- Min selection of VRMS across overlapping windows.

### Parameters

- Downsampling factor: `4`
- Window length: `4096 samples`
- Fragments: `4`
- Overlap: applied manually
- Windowing: Tukey, α = 0.2

### Output

- **Analytical VRMS**: `6.934754288239017 mm/s`
- **VRMS (no window)**: `6.944205362809169 mm/s`
- **VRMS (with Tukey window)**: `6.487143417476240 mm/s`
- **Final VRMS (minimum)**: `6.487143417476240 mm/s`

### Accuracy

- **Error vs Theoretical**:
  - No window: `+0.14%`
  - With window: `-6.46%`

---

## Summary Table

| Method          | VRMS [mm/s] | Error [%] |
|-----------------|-------------|-----------|
| Time-domain     | 6.9800      | +0.65     |
| Frequency-domain| 6.9585      | +0.34     |
| Proposed (raw)  | 6.9442      | +0.14     |
| Proposed (Tukey)| 6.4871      | −6.46     |
| Theoretical     | 6.9348      | –         |

---

## Conclusions

- All methods produce results close to the theoretical VRMS.
- The **time-domain** and **frequency-domain** methods perform similarly.
- The **proposed algorithm** offers robustness via windowing and fragment selection, potentially at a slight cost to accuracy due to windowing loss.

---

## Notes

- All scripts assume the signal is ideal and noise-free.
- The Tukey window smooths spectral leakage but reduces amplitude slightly.


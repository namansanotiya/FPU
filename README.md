# FPU — Floating Point Unit (IEEE-754)

A hardware implementation of IEEE-754 single-precision (32-bit) Floating Point Unit in Verilog.

## Operations
| op | Operation |
|----|-----------|
| 00 | Add |
| 01 | Subtract |
| 10 | Multiply |
| 11 | FMA (Fused Multiply-Add) |

## Project Structure
```
FPU/
├── rtl/
│   ├── fp_defs.vh
│   ├── fp_unpack.v
│   ├── fp_pack.v
│   ├── lzc48.v
│   ├── fp_round_nearest_even.v
│   ├── fp_add_simple.v
│   ├── fp_mul_simple.v
│   ├── fp_fma_simple.v
│   └── simple_fpu_top.v
├── tb/
│   └── tb_simple_fpu.v
├── docs/
└── README.md
```

## Datapath
INPUT → UNPACK → SPECIAL CASE CHECK → ARITHMETIC → NORMALIZE → ROUND → PACK

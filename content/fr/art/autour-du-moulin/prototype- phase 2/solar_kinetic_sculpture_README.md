---
title: "Expansion du liquide"
date: 2026-07-02
image:
draft: false
---

# Solar Kinetic Sculpture — Project SoulGem
*Session notes for continuity — upload this at the start of a new session*

---

## Project Concept

A kinetic sculpture powered entirely by solar energy. The sun heats a small sealed vessel containing ethanol, causing it to vaporize and inflate an expansion element (currently a latex balloon). At night the ethanol condenses back to liquid and the balloon deflates. The system is fully autonomous, sealed, requires no refueling, and cycles continuously with the sun — a perpetual movement illusion.

---

## Solar Collector

- **Found object:** BBQ bowl bottom, inverted, lined with reflective material
- **Dimensions:** 21.5" diameter, 4.5" deep
- **Shape:** Roughly spherical (not parabolic), non-flattened bottom
- **Reflective lining:** Starting with mylar / emergency blanket (upgradeable to polished aluminum or mirror pieces)
- **Goal:** Not a sharp focal point (which would require solar tracking) but a diffuse **focal zone** — forgiving of sun angle changes throughout the day

---

## Optical Calculations

| Parameter | Value |
|---|---|
| Bowl radius (R) | 10.75 inches (0.273 m) |
| Bowl depth (d) | 4.5 inches |
| Focal length (f = R²/2d) | ~12.8 inches above bowl center |
| Hot zone diameter | ~3-4 inches |

The thermal vessel should sit approximately **12.8 inches above the center of the bowl**, and be **2-3 inches in diameter** to fit within the hot zone.

---

## Solar Energy Calculations

- Aperture area: 0.234 m²
- Raw solar power intercepted (at 1000 W/m²): **234W**

| Reflective Surface | Reflectivity | Usable heat at focal zone (after ~70% concentration efficiency) |
|---|---|---|
| Crumpled aluminum foil | ~70% | ~115 W |
| Mylar / flat foil | ~85% | **~140 W** ← working figure |
| Polished aluminum | ~90% | ~148 W |
| Mirror glass | ~95% | ~155 W |

**Working figure: 140W**

Note: difference between mylar and mirror is modest. Mylar is a strong starting point.

---

## Fluid Choice

- **Ethanol 99%+ (anhydrous)** — not 80% alcohol
- 80% alcohol contains 20% water which raises boiling point, reduces vapor production, and degrades over cycles as water accumulates in the liquid phase
- Anhydrous ethanol available at hardware stores or pharmacies in Canada

---

## Thermodynamic Calculations

**To vaporize ethanol:**
- Sensible heat (20°C to 78°C): ~142 J/g
- Latent heat of vaporization: ~841 J/g
- Total: ~1000 J/g

**To inflate a 2.5L balloon (via ideal gas law at 78°C / 351K):**
- n = PV/RT = ~0.087 moles
- Mass of ethanol = 0.087 × 46 g/mol = **~4 grams**

**Key insight:** Only ~4 grams of ethanol are needed to inflate a 2.5L balloon. The 140W available is massively more than required — the system has a lot of thermal headroom and will respond quickly to sun.

---

## Bill of Materials (work in progress)

**Solar Collector**
- BBQ bowl bottom — 21.5" diameter, 4.5" deep
- Reflective lining — mylar/emergency blanket (starting point)

**Thermal Vessel** *(exact dimensions still to be determined)*
- Small copper cylinder — ~2-3" diameter (to fit focal zone)
- Blackened exterior
- Sealed permanently
- Contains ~5-10ml of ethanol 99%+

**Expansion Element**
- Latex balloon (starting point — to be refined based on aesthetic and durability needs)
- Alternatives considered: plumbing expansion vessel (more durable, already pressure-rated)

**Connecting Element**
- Tubing between vessel and balloon — copper or silicone, heat resistant

**Fluid**
- Ethanol 99%+ (anhydrous) — ~10ml

---

## Still To Determine

- Exact vessel dimensions (height, wall thickness)
- How vessel is supported at focal height (~12.8" above bowl)
- Support structure design (found object)
- How balloon is housed and displayed
- Sealing method for closed system
- Whether to upgrade from balloon to more durable expansion element

---

## Design Principles

- **All found objects** wherever possible
- **Simpler is better**
- **Fully autonomous** — no refueling, no tracking, no electricity
- **Sealed closed system** — ethanol cycles between liquid and vapor indefinitely
- Scale: to be determined by expansion element choice

---

*Continue from here in next session*

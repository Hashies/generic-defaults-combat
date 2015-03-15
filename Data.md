This is the weapons data sheet as of [revision 161](https://code.google.com/p/generic-defaults-combat/source/detail?r=161).

## Trajectory and Ballistics information ##
| **Weapon** | **Caliber** | **Velocity** (in"/sec) | **RPM** | **Trajectory Decimal** |
|:-----------|:------------|:-----------------------|:--------|:-----------------------|
| M249     | 5.56mm    | 33,000                      | ~900  |   No Data Yet                  |
| M240     | 7.62mm    | 26,400                      | ~860  | 0.00000053086                  |
| PKM      | 7.62mm    | 29,700                      | ~600  | No Data Yet                  |
| M2HB     | 12.7mm    | 29,700                      | ~460  | 0.00000043209                  |
| GAU-19   | 12.7mm    | 29,700                      | ~1100 | 0.00000043209                  |
| KPV      | 14.5mm    | 39,600                      | ~420  | 0.00000028395                  |
| M197     | 20mm      | 23,100                      | ~700  | 0.00000067901                  |
| M242     | 25mm      | 36,300                      | ~300  | 0.00000033333                  |
| GAU-12   | 25mm      | 36,300                      | ~1200 | 0.00000033333                  |
| M230     | 30mm      | 19,800                      | ~600  | 0.00000092592                  |
| 2A42     | 30mm      | 33,000                      | ~200  | 0.00000037037                  |
| MK19     | 40mm      | 9,000                       | ~300  | 0.00000308641                  |
| L/60     | 40mm      | 19,800                      | ~120  | 0.00000098765                  |
| UB-16    | 57mm      | 13,200 - _26,400_           | ~60   | Inconsistent                  |
| M260     | 70mm      | 13,200 - _16,500_           | ~300  | Inconsistent                  |
| UB-8     | 80mm      | 13,200 - _26,400_           | ~300  | Inconsistent                  |
| Mortar   | 81mm      | 5,280                       | ~20   | No Data Yet                  |
| RAM      | 81mm      | 2,640 - _4,620_             | ~30   |  See Below                  |
| GML      | 84mm      | 7,920                       | ~12   | Inconsistent                  |
| M101     | 105mm     | 13,200                      | ~8    | 0.00000246913                  |
| M256     | 120mm     | 19,800 **or** 36,300          | ~8    | No Data Yet                 |



### ACCURATE TRAJECTORY ALGORITHM FOR ALL CONSTANT VELOCITY ROUNDS: ###

Add Pitch = (atan(DECIMAL\*DISTANCE\*cos(TURRETPITCH))



### APPROXIMATE FOR RAM ###

((DISTANCE/400)^0.96)+(15000/DISTANCE)
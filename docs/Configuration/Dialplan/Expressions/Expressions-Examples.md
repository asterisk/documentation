---
title: Expressions Examples
pageid: 4620379
---



| Expression | Result | Note |
| --- | --- | --- |
| `"One Thousand Five Hundred" =~ "(T[^ ])"` | Thousand |  |
| `"One Thousand Five Hundred" =~ "T[^ ]"` | 8 |  |
| `"One Thousand Five Hundred" : "T[^ ]"` | 0 |  |
| `"8015551212" : "(...)"` | 801 |  |
| `"3075551212":"...(...)"` | 555 |  |
| `! "One Thousand Five Hundred" =~ "T[^ ]"` | 0 | Because it applies to the string, which is non-null, which it turns to "0", and then looks for the pattern in the "0", and doesn't find it |
| `!( "One Thousand Five Hundred" : "T[^ ]+" )` | 1 | Because the string doesn't start with a word starting with T, so the match evals to 0, and the ! operator inverts it to 1 |
| `2 + 8 / 2` | 6 | Because of operator precedence; the division is done first, then the addition |
| `2+8/2` | 6 | Spaces aren't necessary |
| `(2+8)/2` | 5 |  |
| `(3+8)/2` | 5.5 |  |
| `TRUNC((3+8)/2)` | 5 |  |
| `FLOOR(2.5)` | 2 |  |
| `FLOOR(-2.5)` | -3 |  |
| `CEIL(2.5)` | 3 |  |
| `CEIL(-2.5)` | -2 |  |
| `ROUND(2.5)` | 3 |  |
| `ROUND(3.5)` | 4 |  |
| `ROUND(-2.5)` | -3 |  |
| `RINT(2.5)` | 2 |  |
| `RINT(3.5)` | 4 |  |
| `RINT(-2.5)` | -2 |  |
| `RINT(-3.5)` | -4 |  |
| `TRUNC(2.5)` | 2 |  |
| `TRUNC(3.5)` | 3 |  |
| `TRUNC(-3.5)` | -3 |  |

Of course, all of the above examples use constants, but would work the same if any of the numeric or string constants were replaced with a variable reference, e.g. `${CALLERID(num)}`.


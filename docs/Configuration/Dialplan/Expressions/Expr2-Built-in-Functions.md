---
title: Expr2 Built-in Functions
pageid: 4620372
---

In 1.6 and above, we upgraded the $[] expressions to handle floating point numbers. Because of this, folks counting on integer behavior would be disrupted. To make the same results possible, some rounding and integer truncation functions have been added to the core of the Expr2 parser. Indeed, dialplan functions can be called from $[..] expressions without the ${...} operators. The only trouble might be in the fact that the arguments to these functions must be specified with a comma. If you try to call the MATH function, for example, and try to say 3 + MATH(7\*8), the expression parser will evaluate 7\*8 for you into 56, and the MATH function will most likely complain that its input doesn't make any sense.

We also provide access to most of the floating point functions in the C library. (but not all of them).

While we don't expect someone to want to do Fourier analysis in the dialplan, we don't want to preclude it, either.

Here is a list of the 'builtin' functions in Expr2. All other dialplan functions are available by simply calling them (read-only). In other words, you don't need to surround function calls in $[...] expressions with ${...}. Don't jump to conclusions, though! - you still need to wrap variable names in curly braces!

* COS(x) x is in radians. Results vary from -1 to 1.
* SIN(x) x is in radians. Results vary from -1 to 1.
* TAN(x) x is in radians.
* ACOS(x) x should be a value between -1 and 1.
* ASIN(x) x should be a value between -1 and 1.
* ATAN(x) returns the arc tangent in radians; between -PI/2 and PI/2.
* ATAN2(x,y) returns a result resembling y/x, except that the signs of both args are used to determine the quadrant of the result. Its result is in radians, between -PI and PI.
* POW(x,y) returns the value of x raised to the power of y.
* SQRT(x) returns the square root of x.
* FLOOR(x) rounds x down to the nearest integer.
* CEIL(x) rounds x up to the nearest integer.
* ROUND(x) rounds x to the nearest integer, but round halfway cases away from zero.
* RINT(x) rounds x to the nearest integer, rounding halfway cases to the nearest even integer.
* TRUNC(x) rounds x to the nearest integer not larger in absolute value.
* REMAINDER(x,y) computes the remainder of dividing x by y. The return value is x - n\*y, where n is the value x/y, rounded to the nearest integer. If this quotient is 1/2, it is rounded to the nearest even number.
* EXP(x) returns e to the x power.
* EXP2(x) returns 2 to the x power.
* LOG(x) returns the natural logarithm of x.
* LOG2(x) returns the base 2 log of x.
* LOG10(x) returns the base 10 log of x.

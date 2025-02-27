---
title: Operators
pageid: 4620368
---

Operators are listed below in order of increasing precedence. Operators with equal precedence are grouped within { } symbols.

* `expr1 | expr2`  
 Return the evaluation of `expr1` if it is neither an empty string nor zero; otherwise, returns the evaluation of `expr2`.
* `expr1 & expr2`  
 Return the evaluation of `expr1` if neither expression evaluates to an empty string or zero; otherwise, returns zero.
* `expr1 {=, >, >=, <, <=, !=} expr2`  
 Return the results of floating point comparison if both arguments are numbers; otherwise, returns the results of string comparison using the locale-specific collation sequence. The result of each comparison is 1 if the specified relation is true, or 0 if the relation is false.
* `expr1 {+, -} expr2`  
 Return the results of addition or subtraction of floating point-valued arguments.
* `expr1 {\*, /, %} expr2`  
 Return the results of multiplication, floating point division, or remainder of arguments.
* `- expr1`  
 Return the result of subtracting `expr1` from 0. This, the unary minus operator, is right associative, and has the same precedence as the `!` operator.
* `! expr1`  
 Return the result of a logical complement of `expr1`. In other words, if `expr1` is null, 0, an empty string, or the string "0", return a 1. Otherwise, return a 0. It has the same precedence as the unary minus operator, and is also right associative.
* `expr1 : expr2`  
 The `:` operator matches `expr1` against `expr2`, which must be a regular expression. The regular expression is anchored to the beginning of the string with an implicit `^`.
 If the match succeeds and the pattern contains at least one regular expression match group `()`, the string corresponing to `\1` is returned; otherwise the matching operator returns the number of characters matched. If the match fails and the pattern contains a regular expression match group the null string is returned; otherwise 0.
 Normally, the double quotes wrapping a string are left as part of the string. This is disastrous to the : operator. Therefore, before the regex match is made, beginning and ending double quote characters are stripped from both the pattern and the string.
* `expr1 =~ expr2`  
 Exactly the same as the `:` operator, except that the match is not anchored to the beginning of the string. Pardon any similarity to seemingly similar operators in other programming languages! The `:` and `=~` operators share the same precedence.
* `expr1 ? expr2 :: expr3`  
 Traditional Conditional operator. If `expr1` is a number that evaluates to 0 (false), `expr3` is result of the this expression evaluation. Otherwise, `expr2` is the result. If `expr1` is a string, and evaluates to an empty string, or the two characters `""`, then `expr3` is the result. Otherwise, `expr2` is the result. In Asterisk, all 3 exprs will be "evaluated"; if `expr1` is "true", `expr2` will be the result of the "evaluation" of this expression. `expr3` will be the result otherwise. This operator has the lowest precedence.
* `expr1 ~~ expr2`  
 Concatenation operator. The two exprs are evaluated and turned into strings, stripped of surrounding double quotes, and are turned into a single string with no invtervening spaces. This operator is new to trunk after 1.6.0; it is not needed in existing `extensions.conf` code. Because of the way asterisk evaluates `$[ ]` constructs (recursively, bottom-up), no ` ` is ever present when the contents of a `[]` is evaluated. Thus, tokens are usually already merged at evaluation time. But, in AEL, various exprs are evaluated raw, and `[]` are gathered and treated as tokens. And in AEL, no two tokens can sit side by side without an intervening operator. So, in AEL, concatenation must be explicitly specified in expressions. This new operator will play well into future plans, where expressions (`$[ ]` constructs) are merged into a single grammar.

Parentheses are used for grouping in the usual manner.

Operator precedence is applied as one would expect in any of the C or C derived languages.

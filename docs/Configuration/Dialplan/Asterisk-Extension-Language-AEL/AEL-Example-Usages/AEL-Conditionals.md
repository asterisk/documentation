---
title: AEL Conditionals
pageid: 4816897
---

AEL supports if and switch statements, like AEL, but adds ifTime, and random. Unlike the original AEL, though, you do NOT need to put curly braces around a single statement in the "true" branch of an if(), the random(), or an ifTime() statement. The if(), ifTime(), and random() statements allow optional else clause.

context conditional {
 \_8XXX => {
 Dial(SIP/${EXTEN});
 if ("${DIALSTATUS}" = "BUSY") 
 {
 NoOp(yessir);
 Voicemail(${EXTEN},b); 
 }
 else 
 Voicemail(${EXTEN},u);
 ifTime (14:00-23:59|sat-sun|\*|\*) 
 Voicemail(${EXTEN},b); 
 else 
 { 
 Voicemail(${EXTEN},u); 
 NoOp(hi, there!); 
 } 
 random(51) NoOp(This should appear 51% of the time); 
 random( 60 ) 
 { 
 NoOp( This should appear 60% of the time ); 
 }
 else
 { 
 random(75) 
 { 
 NoOp( This should appear 30% of the time! );
 }
 else 
 {
 NoOp( This should appear 10% of the time! ); 
 }
 }
 } 
 \_777X => {
 switch (${EXTEN}) {
 case 7771:
 NoOp(You called 7771!); 
 break; 
 case 7772: 
 NoOp(You called 7772!); 
 break; 
 case 7773: 
 NoOp(You called 7773!); 
 // fall thru-
 pattern 777[4-9]:
 NoOp(You called 777 something!); 
 default: NoOp(In the default clause!);
 } 
 }
}
The conditional expression in if() statements (the "${DIALSTATUS}" = "BUSY" above) is wrapped by the compiler in $[] for evaluation.

Neither the switch nor case values are wrapped in $[ ]; they can be constants, or ${var} type references only.

AEL generates each case as a separate extension. case clauses with no terminating 'break', or 'goto', have a goto inserted, to the next clause, which creates a 'fall thru' effect.

AEL introduces the ifTime keyword/statement, which works just like the if() statement, but the expression is a time value, exactly like that used by the application GotoIfTime(). See Asterisk cmd GotoIfTime

The pattern statement makes sure the new extension that is created has an '\_' preceding it to make sure asterisk recognizes the extension name as a pattern.

Every character enclosed by the switch expression's parenthesis are included verbatim in the labels generated. So watch out for spaces!

NEW: Previous to version 0.13, the random statement used the "Random()" application, which has been deprecated. It now uses the RAND() function instead, in the GotoIf application.


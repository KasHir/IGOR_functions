IGOR Procedure
====

Thsi is IGOR sciprt to escape boring operations.

##How to Use

###1. LOAD `myProcedure.ipf` to your Igor Experiment.

###2. MAKE a table of data name lists in Igor

 | ref | smp |
 | --- | --- |
 | ref0001 | smp0001 |
 | ref0002 | smp0002 |
 | ref0003 | smp0003 |

###3. Make a macro or a function and WRITE some codes
to call functions for batch procedure.

"your data path" depends on your computer.

```
init("your data path");

loopFunc("ref")
loopFunc("smp")
loopForTrans("ref", "smp", "e05_s0", "e05_s1")

create_TDS_GraphsSet("e05_ref_and_e05_smp", "ref", "smp")
create_TDS_FFT_GraphsSet("e05_ref_and_e05_smp", "ref", "smp")
```


##Link
- functions list
 - [Loop functions list](doc/functionsList_Loop.md)
 - [Display Graphs functions list](doc/functionsList_DisplayGraphs.md)
 - [General functions list](doc/functionsList_General.md)
 - [function dependence](doc/img/function_dependence.gif)


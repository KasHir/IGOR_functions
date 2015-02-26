IGOR Procedure
====

Thsi is IGOR sciprt to escape boring operations.

##How to Use

###1. Save files of this repository to a same directory.

###2. Save 4 column data as txt file to example.

`example` is default directory.
You can change directory as long as you rewrite code.

see: [about_data_format.md](example/about_data_format.md)

###3. Open `tds.pxp` file

###4. Define file list as wave data

e.g.

| ref | smp |
| --- | --- |
| ref0001 | smp0001 |
| ref0002 | smp0002 |
| ref0003 | smp0003 |

files: `ref0001.txt`, `ref0002.txt`, `smp0001.txt`...

###5. Rewrite code

###6. Run from Igor command line (Cmd + j / Ctrl + j)

like

```
init("your data path");

loopFunc("ref")
loopFunc("smp")
loopForTrans("ref", "smp", "ref0001", "smp0001")

create_TDS_GraphsSet("ref_and_smp", "ref", "smp")
create_TDS_FFT_GraphsSet("ref_and__smp", "ref", "smp")
```

I suggest to read and understand test code in the build-in code (cmd + j / Ctrl + j)

```
test()
```

### Re-excute

1. Close all of opened graphs and tables _exept for file list table_.

2. Redo step. 6.

### files
Img files will be saved to `save` directory.

##Link
- functions list
 - ~~[Loop functions list](doc/functionsList_Loop.md)~~ old
 - ~~[Display Graphs functions list](doc/functionsList_DisplayGraphs.md)~~ old
 - ~~[General functions list](doc/functionsList_General.md)~~ old
 - ~~[function dependence](doc/img/function_dependence.gif)~~ old


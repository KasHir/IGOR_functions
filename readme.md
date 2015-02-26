IGOR Procedure
====

Thsi is IGOR sciprt to escape boring operations.

##Getting started

1. Save files of this repository to a same directory.

2. Get example files (private files) and Save them to `example` folder.

3. Open `tds.pxp`.

4. Run `test()` from command line (cmd + j / ctrl + j).

5. see `save` folder.

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

###5. Rewrite code to adjust your file path and name

see: `callLoop()` in Loop functions for Batch

####e.g.

```
init("your data path") 	// your data path as string (default: example)

loopFunc("ref")	// waveName of reference data files list
loopFunc("smp")	// waveName of sample data files list
loopForTrans("ref", "smp", "r0", "s0")	// r0 and s0 are arbitrary

create_TDS_GraphsSet("ref_and_smp", "ref", "smp")	// 2 data as 1 graph
create_TDS_FFT_GraphsSet("ref_and_smp", "ref", "smp") // 2 data as 1 graph
```

###6. Run from Igor command line (Cmd + j / Ctrl + j)

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


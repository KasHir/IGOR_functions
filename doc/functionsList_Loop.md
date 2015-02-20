Loop Functions List
====

##create_TDS_GraphsSet(graphName, listNameR, listNameS)
This creates TDS graphs (2 data as a one graph) from all List and create img files.

Default X Axix and Y Axix ranges are Auto.

Anyway, it works but code is still not good.

###example
```
create_TDS_GraphsSet("GraphName", "ref", "smp")
```

img file: `refName_vs_smpName_TDS.png`


##create_TDS_FFT_GraphsSet(graphName, listNameR, listNameS)
This creates FFT graphs (2 data as a one graph) from all List.

Default X Axix range is from 0 to 1.2.

Anyway, it works but code is still not good.

###example
```
create_TDS_FFT_GraphsSet("GraphName", "ref", "smp")
```


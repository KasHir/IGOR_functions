Functions List
====

##Loop functions for Batch procedure

|loop()|

###function loop()


###loadtextFileAsTDS(fileName);
###displayTDSGraph(fileName);
###displayTDS_FFT(fileName);
###displayTDS_FFT_Range(fileName, 0, 1.2);
###displayTDS_FFT_Log(fileName);

###displayTrans(sample, ref, sampleID, refID)
###calcTrans(sampleFileNameList, refSampleNameList, IDofSample, IDofRef)
###saveFunc(fileName, "_TDS.png")



###function loadTextFileFor4col(rootPath, fileName, w0, w1, w2, w3)

####example
file: `C:Users:usrname:Documents:sample0001.txt`

```
loadTextFileFor4col("C:Users:usrname:Documents:", "sample0001", "_Time", "_X", "_Y", "_Z")
```

####detail
This is file load function for 4 columns file.
If you need much more or less data columns, you can make another function like this function.

| argument | type | comments | example |
| --- | --- | --- | --- |
| rootPath | string | file path | "C:Users:usrname:Documents:" |
| fileName | string | fileName. extension like ".txt" is not neeeded. | "sample0001" |
| w0 | string | Name of wave (1st column). This name is up to you. *It requires unique name.* ||
| w1 | string | Name of wave (2nd column).||
| w2 | string | Name of wave (3rd column).||
| w3 | string | Name of wave (4th column).||


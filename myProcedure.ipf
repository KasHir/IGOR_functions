#pragma rtGlobals=1		// Use modern global access method.

function call()
	print "called"
end

///////////////////////////////////////////////////
/// Loop functions for Batch
///////////////////////////////////////////////////
function callLoop()
	init("C:Users:kas:Documents:lab:intern:TDTS:2015-02-12:");
	
	loopFunc("ref")
	loopFunc("smp")
	loopForTrans("ref", "smp", "e05_s0", "e05_s1")
end

function loopFunc(listName)
	string listName// = "ref";

	variable xMin, xMax
	
	variable i	
	wave/T nameWave = $listName
	variable last = Dimsize($listName,0)

	for(i=0;i<last;i+=1)
		
		// load files
		//  ! ! ! If data has been ALREADY LOADED, you should COMMENT OUT "loadtextFileAsTDS ! ! !
		string fileName = nameWave[i];
		print fileName
		loadtextFileAsTDS(fileName);	// 
		
		
		// make and save TDS Graphs
		
		displayTDSGraph(fileName);
		
		xMin = -0.006
		xMax = 0.008
		SetAxis left xMin, xMax
		
		saveFunc(fileName, "_TDS.png")
		
		
		// make and save TDS FFT Graph as Log
		
		displayTDS_FFT_Log(fileName);
			
		//xMin = 0
		//xMax = 4
		//SetAxis bottom xMin, xMax
		
		//xMin = 0.000000001
		//xMax = 0.1
		//SetAxis left xMin, xMax
		
		saveFunc(fileName, "_FFT_Log.png");

	endfor
end

function loopForTrans(listNameR, listNameS, ID_ref, ID_sample)
	string listNameR	// reference data fileList
	string listNameS	// sample data fileList
	string ID_ref 		//
	string ID_sample	// like sampleNumber
	
	variable xMin, xMax
	
	variable i	
	wave/T nameWaveR = $listNameR
	wave/T nameWaveS = $listNameS
	
	variable last = Dimsize($listNameR,0)
	for(i=0;i<last;i+=1)
		string fileNameR = nameWaveR[i];
		string fileNameS = nameWaveS[i]; 

		calcTrans(fileNameS, fileNameR, ID_sample +"_"+ num2str(i+1), ID_ref+"_"+ num2str(i+1))
		string fileName = displayTrans_ID(ID_sample+"_"+ num2str(i+1), ID_ref+"_"+ num2str(i+1))
				
		saveFunc(fileName, ".png")
	endfor
end

//////////////////////////////////////////////////
///// Public Functions (can be called from Macro)
//////////////////////////////////////////////////
function saveFunc(fileName, extension)
	string fileName, extension
	SavePICT/O/P=IGOR/E=-5/B=288 as fileName+extension
end

function init(path)
	string path
	string/G rootPath = path;
	string/G label_time = "_Time";
	string/G label_X = "_X";
	string/G label_Y = "_Y";
	string/G label_Aux = "_Aux";	
end

function loadTextFileAsTDS(fileName)
	string fileName;
	string/G rootPath, label_time, label_X, label_Y, label_Aux	// init()
	
	loadTextFileFor4col(rootPath, fileName, label_time, label_X, label_Y, label_Aux);
end


/// @display //////////////////////////////

function displayTDSGraph(fileName)
	string fileName
	string x, y;
	string/G label_time, label_X;

	x = fileName + label_time;
	y = fileName + label_X;

	Display $y vs $x as fileName+"_TD";

	styleTDS();
end


function displayTDS_FFT(fileName)
	string fileName;
	string/G label_time, label_X;
	string t = fileName+label_time;	// time data
	string x = fileName+label_X;		// data before FFT
	
	string FFTwaveName = TDS_FFT(fileName, t, x);
	string graphName = FFTwaveName;
	Display $FFTwaveName as graphName;
	
	styleFFT();
	
	variable fftScale = getFftScale(t, FFTwaveName);
	SetScale/P x 0,fftScale,"", $FFTwaveName;
end

function displayTDS_FFT_Range(fileName, xMin,xMax)
	string fileName;
	variable xMin, xMax;
	string/G label_time, label_X;
	string t = fileName+label_time;	// time data
	string x = fileName+label_X;		// data before FFT
	
	string FFTwaveName = TDS_FFT(fileName, t, x);
	string graphName = FFTwaveName + "_LimitedRange";
	Display $FFTwaveName as graphName;
	
	styleFFT();
	
	variable fftScale = getFftScale(t, FFTwaveName);
	SetScale/P x 0,fftScale,"", $FFTwaveName
	
	SetAxis bottom xMin,xMax;
end

function displayTDS_FFT_Log(fileName)
	string fileName;
	string/G label_time, label_X;
	string t = fileName+label_time;	// time data
	string x = fileName+label_X;		// data before FFT
		
	string FFTwaveName = TDS_FFT(fileName, t, x);
	string graphName = FFTwaveName + "_Log";
	Display $FFTwaveName as graphName;
	
	styleFFT();
	
	variable fftScale = getFftScale(t, FFTwaveName);
	SetScale/P x 0,fftScale,"", $FFTwaveName;
	
	ModifyGraph log(left)=1;DelayUpdate
end


//////////////////////////////////////////////

function/S TDS_FFT(fileName, t, x)
	string fileName, t, x;
	
	string FFTwaveName = x + "_FFT"
	FFT/OUT=4/PAD={512}/DEST=$x+"_FFT" $x;DelayUpdate
	
	return FFTwaveName;
end

/// @trans ////////////////////////////////

function displayTDS_Trans_Range(transWave, fileName, xMin,xMax)
	string transWave
	string fileName
	variable xMin, xMax;
	string/G label_time, label_X;
	string t = fileName+label_time;	// time data
	string x = fileName+label_X;		// data before FFT
	
	string FFTwaveName = transWave//TDS_FFT(fileName, t, x);
	string graphName = FFTwaveName + "_LimitedRange";
	Display $FFTwaveName as graphName;
	
	styleTrans();
	
	variable fftScale = getFftScale(t, transWave);
	SetScale/P x 0,fftScale,"", $FFTwaveName
	
	SetAxis bottom xMin,xMax;
	setAxis left 0, 1.5;
end

///////////////////////////////////////////////////

function calcTrans(sample, ref, sampleID, refID)
	string sample, ref, sampleID, refID
	string fftID = "_X_FFT"
	
	wave sampleWave = $sample+fftID
	wave refWave = $ref+fftID
	variable dim = Dimsize(sampleWave,x)
	Make /N=(dim)/D/O testWave; //Edit testWave;
	testWave = sampleWave / refWave
	
	string myWave =transName(sampleID, refID)
	Rename testWave,$myWave;
end

function/S displayTrans_ID(sampleID, refID)
	string sampleID, refID
	string transData = transName(sampleID, refID)
	
	Display $transData as transData;
	
	styleTrans()
	SetScale/P x 0,10/Dimsize($transData,0),"", $transData
	
	SetAxis bottom 0, 1.2;
	setAxis left 0, 1.5;
	
	return transData
end

function/S transName(sampleID, refID)
	string sampleID, refID
	return "Trans_"+sampleID+ "_vs_"+refID
end


//////////////////////////////////////////////////
///// Private Functions (should not be called from Macro)
//////////////////////////////////////////////////



//////////////////////////////////////////////////
///// Graph Style Tempate
//////////////////////////////////////////////////
function styleFFT()
 	Label bottom "THz"
	Label left "X_signal_FFT (Mag. sqrd)"
	ModifyGraph zero=0
	ModifyGraph lstyle=0
	ModifyGraph tick=2,mirror=1
	ModifyGraph mode=4,marker=8,mrkThick=0.2
	ModifyGraph width={Aspect,1.2}
	GraphSizeForMsPpt()
end

function styleTDS()
	Label bottom "Time (ps)"
	Label left "X_signal (V)"
	ModifyGraph zero=0
	ModifyGraph lstyle=0
	ModifyGraph tick=2,mirror=1
	ModifyGraph width={Aspect,1.2}
	GraphSizeForMsPpt()
end

function styleTrans()
 	Label bottom "THz"
	Label left "Transmittance (Mag. sqrd)"
	ModifyGraph zero=0
	ModifyGraph lstyle=0
	ModifyGraph tick=2,mirror=1
	ModifyGraph mode=4,marker=8,mrkThick=0.2
	ModifyGraph width={Aspect,1.2}
	GraphSizeForMsPpt()
end


//////////////////////////////////////////
//  Graph Style Template private functions
function graphSizeForMsPpt()
	ModifyGraph height=226.772,gfSize=18
end

//////////////////////////////////////////////////
///// General Functions 
//////////////////////////////////////////////////
function getFftScale(t, x)
	string t;	// waveName of time data
	string x;	// waveName of FFT data
	
	wave timeData = $t;
	variable dataPoints = DimSize($x, 0); 
	variable step = round((timeData[1] - timeData[0])*100)/100;	 // 0.05
	variable fftScale = (1/step) / dataPoints/2;
	
	return fftScale;
end

function loadTextFileFor4col(rootPath, fileName, w0, w1, w2, w3)
	string rootPath;
	string fileName;
	string w0, w1, w2, w3;

	string myWave0 = fileName+w0;
	string myWave1 = fileName+w1;
	string myWave2 = fileName+w2;
	string myWave3 = fileName+w3;

	// check if wave name is unique or not
	if (CheckName(myWave0, 1) != 0 || CheckName(myWave1, 1) != 0 ||  CheckName(myWave2, 1) != 0 ||  CheckName(myWave3, 1) != 0 )
		Abort "ERROR: wong wave name. probably the name of wave has been already loaded. you should eliminate an existed wave or use another name."
	else
		// file load
		// @TODO: check if the file exists or not
		LoadWave/A/G/D/W/E=0/K=0 rootPath+fileName+".txt";
		
		Rename wave0,$mywave0;
		Rename wave1,$mywave1;
		Rename wave2,$mywave2;
		Rename wave3,$mywave3;
	endif
end

function refresh()
	KillWaves/A/Z
end

Window Table1() : Table
	PauseUpdate; Silent 1		// building window...
	Edit/W=(13.5,117.5,518.25,327.5)
	ModifyTable format=1
EndMacro

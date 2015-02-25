#pragma rtGlobals=1		// Use modern global access method.

function call()
	print "called"
end

function create_TDS_GraphsSet(graphName, listNameR, listNameS)
	string graphName
	string listNameR
	string listNameS
	
	string x, y;
	string/G label_time, label_X;

	wave/T nameWaveR = $listNameR
	wave/T nameWaveS = $listNameS
	variable last = Dimsize($listNameR,0)
	
	variable xMin, xMax
	
	variable i	
	for(i=0;i<last;i+=1)
		// make a graph of Ref
		x = nameWaveR[i] + label_time;
		y = nameWaveR[i] + label_X;
		
		string FFTwaveNameR = TDS_FFT(nameWaveR[i], nameWaveR[i]+label_time, nameWaveR[i]+label_X);
		Display $y vs $x as graphName+"_TDS_set_"+num2str(i);
		styleTDS();
		ModifyGraph lstyle($y)=3
		
		// append Sample data to the graph
		x = nameWaveS[i] + label_time;
		y = nameWaveS[i] + label_X;
		
		AppendToGraph/C=(0,0,0) $y vs $x
		ModifyGraph lstyle($y)=0
		
		saveFunc(nameWaveS[i]+"_and_"+nameWaveR[i], "_TDS.png");
	endfor
end

function create_TDS_FFT_GraphsSet(graphName, listNameR, listNameS)
	string graphName
	string listNameR
	string listNameS

	string x, y;
	string/G label_time, label_X;

	wave/T nameWaveR = $listNameR
	wave/T nameWaveS = $listNameS
	variable last = Dimsize($listNameR,0)
	
	variable xMin, xMax
	
	variable i	
	for(i=0;i<last;i+=1)
		x = nameWaveS[i] + label_time;
		y = nameWaveS[i] + label_X;
		
		// make a graph of Ref
		string FFTwaveNameR = TDS_FFT(nameWaveR[i], nameWaveR[i]+label_time, nameWaveR[i]+label_X);
		Display $FFTwaveNameR as graphName+"_FFT_set_"+num2str(i);
		variable fftScale = getFftScale(nameWaveR[i]+label_time, FFTwaveNameR);
		SetScale/P x 0,fftScale,"", $FFTwaveNameR;
		styleFFT();
			
		// append Sample data to the graph
		string FFTwaveNameS = TDS_FFT(nameWaveS[i], nameWaveS[i]+label_time, nameWaveS[i]+label_X);
		AppendToGraph/C=(0,0,0) $FFTwaveNameS
		fftScale = getFftScale(nameWaveS[i]+label_time, FFTwaveNameS);
		SetScale/P x 0,fftScale,"", $FFTwaveNameS;
		
		// set X axix range	
		xMin = 0
		xMax = 1.2
		SetAxis bottom xMin, xMax
		
		saveFunc(nameWaveS[i]+"_and_"+nameWaveR[i], "_FFT_SET.png");
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
	FFT/OUT=4/PAD={1024}/DEST=$x+"_FFT" $x;DelayUpdate
	
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

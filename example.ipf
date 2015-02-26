#pragma rtGlobals=1		// Use modern global access method.


// =======================================
//  Loop functions for Batch
// =======================================
function callLoop()
	init(getHomePath()+"example:");
	
	loopFunc("ref")
	loopFunc("smp")
	loopForTrans("ref", "smp", "e05_s0", "e05_s1")
	
	create_TDS_GraphsSet("e05_ref_and_e05_smp", "ref", "smp")
	create_TDS_FFT_GraphsSet("e05_ref_and_e05_smp", "ref", "smp")
end

function loopFunc(listName)
	string listName// e.g. "ref";

	string graphName	// as save name
	variable xMin, xMax
	
	variable i	
	wave/T nameWave = $listName
	variable last = Dimsize($listName,0)

	for(i=0;i<last;i+=1)
		
		// load files
		string fileName = nameWave[i];
		print fileName
		loadtextFileAsTDS(fileName);
		
		//---------------------------------
		// make and save TDS Graphs
		
		// 1. display
		graphName = displayTDSGraph(fileName);
		
		// 2. option
		xMin = -0.006
		xMax = 0.008
		SetAxis left xMin, xMax
		
		// 3. save Image File
		//saveFunc(graphName, ".png")
		

		//----------------------------------
		// make and save TDS FFT Graph as Log
		
		// 1. display
		graphName = displayTDS_FFT_Range(fileName, 0, 1.0);
		
		// 2. option
		
		// 3. save Image File
		saveFunc(graphName, ".png")
		
		//----------------------------------
		// make and save TDS FFT Graph as Log
		
		// 1. display
		graphName =  displayTDS_FFT_Log(fileName);
			
		// 2. option
		//xMin = 0
		//xMax = 4
		//SetAxis bottom xMin, xMax
		
		//xMin = 0.000000001
		//xMax = 0.1
		//SetAxis left xMin, xMax
		
		// 3. save Image File
		//saveFunc(graphName, ".png");

	endfor
end

function loopForTrans(listNameR, listNameS, ID_ref, ID_sample)
	string listNameR	// reference data fileList
	string listNameS	// sample data fileList
	string ID_ref 		//
	string ID_sample	// like sampleNumber
	
	string graphName	// as save name
	variable xMin, xMax
	
	variable i	
	wave/T nameWaveR = $listNameR
	wave/T nameWaveS = $listNameS
	
	variable last = Dimsize($listNameR,0)
	for(i=0;i<last;i+=1)
		string fileNameR = nameWaveR[i];
		string fileNameS = nameWaveS[i]; 

		//----------------------------------
		// make and save Transmittans Graph
		
		// 1. display
		graphName = displayTrans_ID(fileNameS, fileNameR, ID_sample+"_"+ num2str(i+1), ID_ref+"_"+ num2str(i+1))
		
		// 2. option
		
		// 3. save Image File
		//saveFunc(graphName, ".png")
	endfor
end

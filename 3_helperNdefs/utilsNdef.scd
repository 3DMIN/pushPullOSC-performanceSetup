/*
m.helpers[\myCooolHelper] = Ndef(\myCooolHelper);

Ndef(\myCooolHelper, {
	LFSaw.ar(0.1)
});
*/

m.helpers[\inputsPreProcessing] = Ndef(\inputsPreProcessing);

Ndef(\inputsPreProcessing).ar(2);
Ndef(\inputsPreProcessing).addSpec(\preGainPush, [0.0 ,2.0,\amp] );
Ndef(\inputsPreProcessing).addSpec(\preGainPull, [0.0 ,2.0,\amp] );
Ndef(\inputsPreProcessing).addSpec(\postGainPush, [0.0 ,2.0,\amp] );
Ndef(\inputsPreProcessing).addSpec(\postGainPull, [0.0 ,2.0,\amp] );
Ndef(\inputsPreProcessing).addSpec(\swapLag, [0.0 ,2.0] );

Ndef(\inputsPreProcessing, { | swapLag = 0.06, preGainPush = 1.0, preGainPull = 1.0, postGainPush = 1.0 , postGainPull = 1.0 |

	var rawIns = SoundIn.ar([0,1]) ;

	var invertB = ( rawIns * [1, -1] * [preGainPush, preGainPull] ); //invert one of the signals (trim gain to cancel out digital noize and feedback)

	var ampTrack = Amplitude.ar(invertB,0.003,0.003);

	var cancel = ( ampTrack[0] - ampTrack[1] );

	var fbkIn = LocalIn.ar(2, 0);
	var pushOrPull =
	[ ( (cancel + fbkIn[0]) > 0.0001) , ( (cancel - fbkIn[1]) < -0.0001) ];

	var highPass = HPF.ar(HPF.ar(invertB.sum, 90),90); //test high pass fq with good sound system.
	var outputs = highPass * pushOrPull.lag(swapLag)   * [postGainPush, postGainPull]; // recreations of push and pull signals (adjust volume of push and pull again!)

	LocalOut.ar( (pushOrPull * 0.003) ); // positiv feedback as hystheresis for flipflop

	outputs;
	//rawIns ;
	//invertB.sum !2;
});

/*
Ndef(\testTone, {|freq = 300, amp = 0.1| (SinOsc.ar(freq) * DC.ar([0.0, 1.0 ])* amp ) ; }).play;
Ndef(\testTone).edit;
*/



////////////////static patterns /////////////////

(
// normal pattern:

m.helpers[\allPatterns] = ();
(
m.helpers[\allPatterns][\mode0] = ();

m.helpers[\allPatterns][\mode0].layer0 =
	[
	[[1,0,0,0],[1,0,0,1],[1,0,1,0],
	[1,0,1,1],[1,1,0,0],[1,1,0,1],
	[1,1,1,0],[1,1,1,1],[1,0,0,0]].flatten,
	{0}.dup(36) //zero padding (fill up with zeros 1,0,1,1 -> 1,0,0,0,1,0,1,0)
	].flop.flatten;

m.helpers[\allPatterns][\mode0].layer1  =
	[
	[[0,0,1,0],[0,0,1,0],[0,0,1,0],
	[0,1,0,0],[0,0,1,1],[0,0,1,0],
	[0,0,0,1],[1,0,0,0],[0,1,1,1]].flatten,
	{0}.dup(36)
	].flop.flatten;

m.helpers[\allPatterns][\mode0].layer2  =
	[
	[[0,1,0,1],[1,1,1,1],[1,0,1,0],
	[0,1,0,1],[0,1,0,1],[0,0,0,1],
	[1,0,1,1],[1,1,0,0],[0,1,0,1]].flatten,
	{0}.dup(36)
	].flop.flatten;

m.helpers[\allPatterns][\mode0].layer3  =
	[
	[[1,0,1,0],[0,1,0,1],[0,1,0,1],
	[0,0,1,0],[1,0,0,0],[1,0,1,0],
	[0,1,0,1],[0,0,1,1],[1,0,1,0]].flatten,
	{0}.dup(36)
	].flop.flatten;

m.helpers[\allPatterns][\mode0].blank = {0}.dup(72);

m.helpers[\allPatterns][\mode0].complete =
	[m.helpers[\allPatterns][\mode0].layer0
	++ m.helpers[\allPatterns][\mode0].layer1
	++ m.helpers[\allPatterns][\mode0].layer2
	++ m.helpers[\allPatterns][\mode0].layer3
	++ m.helpers[\allPatterns][\mode0].blank ].flatten;

m.helpers[\allPatterns][\mode0].patBuf = Buffer.loadCollection(s, m.helpers[\allPatterns][\mode0].complete );
);

// triolic pattern:
(
m.helpers[\allPatterns][\mode1] = ();

m.helpers[\allPatterns][\mode1].layer0 =
	[
	[[1,0,0],[1,0,0],[1,0,1],
	[1,1,0],[1,1,1],[0,1,1],
	[0,1,0],[0,0,1],[0,0,1]].flatten,
	{0}.dup(27) //zero padding (fill up with zeros 1,0,1 -> 1,0,0,0,1,0)
	].flop.flatten;

m.helpers[\allPatterns][\mode1].layer1  =
	[
	[[0,1,0],[0,0,1],[0,0,1],
	[0,1,0],[1,0,0],[1,0,0],
	[0,0,1],[1,0,0],[1,1,1]].flatten,
	{0}.dup(27)
	].flop.flatten;

m.helpers[\allPatterns][\mode1].layer2  =
	[
	[[0,1,0],[1,1,1],[1,0,1],
	[0,1,0],[0,1,0],[0,0,0],
	[1,0,1],[1,1,0],[0,1,0]].flatten,
	{0}.dup(27)
	].flop.flatten;

m.helpers[\allPatterns][\mode1].layer3  =
	[
	[[1,0,1],[0,1,0],[0,1,0],
	[0,0,1],[1,0,0],[1,0,1],
	[0,1,0],[0,1,1],[1,0,1]].flatten,
	{0}.dup(27)
	].flop.flatten;

m.helpers[\allPatterns][\mode1].blank = {0}.dup(54);

m.helpers[\allPatterns][\mode1].complete =
	[m.helpers[\allPatterns][\mode1].layer0
	++ m.helpers[\allPatterns][\mode1].layer1
	++ m.helpers[\allPatterns][\mode1].layer2
	++ m.helpers[\allPatterns][\mode1].layer3
	++ m.helpers[\allPatterns][\mode1].blank ].flatten;

m.helpers[\allPatterns][\mode1].patBuf = Buffer.loadCollection(s, m.helpers[\allPatterns][\mode1].complete );
);

// random fills // make syour own non random patterns like obove if you like
(
m.helpers[\allPatterns][\mode2] = ();
m.helpers[\allPatterns][\mode2].layer0 = [{2.rand}.dup(72), {0}.dup(72)].flop.flatten;
m.helpers[\allPatterns][\mode2].layer1 = [{2.rand}.dup(72), {0}.dup(72)].flop.flatten;
m.helpers[\allPatterns][\mode2].layer2 = [{2.rand}.dup(72), {0}.dup(72)].flop.flatten;
m.helpers[\allPatterns][\mode2].layer3 = [{2.rand}.dup(72), {0}.dup(72)].flop.flatten;
m.helpers[\allPatterns][\mode2].blank = {0}.dup(144);

m.helpers[\allPatterns][\mode2].complete =
	[m.helpers[\allPatterns][\mode2].layer0
	++ m.helpers[\allPatterns][\mode2].layer1
	++ m.helpers[\allPatterns][\mode2].layer2
	++ m.helpers[\allPatterns][\mode2].layer3
	++ m.helpers[\allPatterns][\mode2].blank ].flatten;

m.helpers[\allPatterns][\mode2].patBuf = Buffer.loadCollection(s, m.helpers[\allPatterns][\mode2].complete );
);

// random triolic fills
(
m.helpers[\allPatterns][\mode3] = ();
m.helpers[\allPatterns][\mode3].layer0 = [{2.rand}.dup(54), {0}.dup(54)].flop.flatten;
m.helpers[\allPatterns][\mode3].layer1 = [{2.rand}.dup(54), {0}.dup(54)].flop.flatten;
m.helpers[\allPatterns][\mode3].layer2 = [{2.rand}.dup(54), {0}.dup(54)].flop.flatten;
m.helpers[\allPatterns][\mode3].layer3 = [{2.rand}.dup(54), {0}.dup(54)].flop.flatten;
m.helpers[\allPatterns][\mode3].blank = {0}.dup(108);

m.helpers[\allPatterns][\mode3].complete =
	[m.helpers[\allPatterns][\mode3].layer0
	++ m.helpers[\allPatterns][\mode3].layer1
	++ m.helpers[\allPatterns][\mode3].layer2
	++ m.helpers[\allPatterns][\mode3].layer3
	++ m.helpers[\allPatterns][\mode3].blank ].flatten;

m.helpers[\allPatterns][\mode3].patBuf = Buffer.loadCollection(s, m.helpers[\allPatterns][\mode3].complete );
);

//thumb patterns have a duration of 1 bar in a 1/16 grid
//the idea is, that they are fixed to serve as a fundament of a "song" e.g. constant base drum and/or snare
(
m.helpers[\allPatterns][\pushPat] = ();
m.helpers[\allPatterns][\pushPat] .song1 =[ [[1,0,0,0],[0,0,0,1],[1,0,0,0],[0,0,0,0]].flatten, {0}.dup(16) ].flop.flatten;
m.helpers[\allPatterns][\pushPat] .song2 =[ [[1,0,0,0],[0,0,0,1],[1,0,0,0],[0,0,0,1]].flatten, {0}.dup(16) ].flop.flatten;
m.helpers[\allPatterns][\pushPat] .song3 =[ [[1,0,0,0],[0,0,0,1],[1,0,1,0],[0,1,0,0]].flatten, {0}.dup(16) ].flop.flatten;

m.helpers[\allPatterns][\pushPat].complete =
	[m.helpers[\allPatterns][\pushPat].song1
	++ m.helpers[\allPatterns][\pushPat].song2
	++ m.helpers[\allPatterns][\pushPat].song3
].flatten;

m.helpers[\allPatterns][\pushPat].patBuf = Buffer.loadCollection(s, m.helpers[\allPatterns][\pushPat].complete );

m.helpers[\allPatterns][\pullPat] = ();
m.helpers[\allPatterns][\pullPat] .song1 =[ [[0,0,0,0],[1,0,0,0],[0,0,0,0],[1,0,0,0]].flatten, {0}.dup(16) ].flop.flatten;
m.helpers[\allPatterns][\pullPat] .song2 =[ [[0,0,0,0],[1,0,0,0],[0,0,0,0],[1,0,1,1]].flatten, {0}.dup(16) ].flop.flatten;
m.helpers[\allPatterns][\pullPat] .song3 =[ [[0,0,0,1],[1,0,0,0],[1,0,0,1],[0,1,1,1]].flatten, {0}.dup(16) ].flop.flatten;

m.helpers[\allPatterns][\pullPat].complete =
	[m.helpers[\allPatterns][\pullPat].song1
	++ m.helpers[\allPatterns][\pullPat].song2
	++ m.helpers[\allPatterns][\pullPat].song3
].flatten;
m.helpers[\allPatterns][\pullPat].patBuf = Buffer.loadCollection(s, m.helpers[\allPatterns][\pullPat].complete );
);
);


////////////////////////////

///main clock ramp duration is 4 bars
m.helpers[\syncMain] = Ndef(\syncMain);
 Ndef(\syncMain).ar(3);

(
//Ndef(\syncMain).clear;
Ndef(\syncMain).addSpec(\bpm, [60, 180, \lin]);
Ndef(\syncMain, {|t_reset = 0, bpm = 80|

	var beatDur =  60 / bpm.lag(0.1);
	var currLoopDur = beatDur * 16; // 4 bars
	var numSamples = currLoopDur * SampleRate.ir;
	var indexPhasor = Phasor.ar(t_reset, 1, 0, numSamples -1, 0);
	var normPhasor = indexPhasor / numSamples; //
	var rampStartTrg = Trig.ar( (1 - (indexPhasor > 0)), 0.001);

	[normPhasor, rampStartTrg, K2A.ar(beatDur)];
	// -> outputs [ a phasor (range is 0...1.0  and 4 bars long) , trigger at start of each cycle, duration of one Beat ]
});
);


///sub clock modules. ramp duration is 1 bar (output 0) and 1 beat (output 2). out 1 and 3 are cycle start trigs
m.helpers[\syncSubClks] = Ndef(\syncSubClks);
Ndef(\syncSubClks).ar(4);
(
//Ndef(\syncSubClks).clear;
Ndef(\syncSubClks, {
	var mainRamp = Ndef(\syncMain).ar(1,0); // 4 bars
	// 1 bar
	var barPos = (mainRamp * 4) % 1.0;
	var barStartTrg = Trig.ar( (1 - (barPos > 0.0005)), 0.001);
	// 1 beat (4/4)
	var beatPos = (mainRamp * 16) % 1.0;
	var beatStartTrg = Trig.ar( (1 - (beatPos > 0.0005)), 0.001);

	[barPos, barStartTrg, beatPos, beatStartTrg];
});
);


m.helpers[\pushPat] = Ndef(\pushPat);
Ndef(\pushPat).ar(1);


Ndef(\pushPat).addSpec(\song, [0,2,\lin,1]);
Ndef(\pushPat).addSpec(\play, [0,1,\lin,1]);
Ndef(\pushPat, {|song = 0, play = 0|

	var syncIn = Ndef(\syncSubClks).ar(1, 0); // 1 channel and offset 2 -> barPos ramp
	var patSize = 32;

	var phasor = (syncIn * patSize).trunc(1); // since syncIn will reset somewhere at 0.999.... this counts up from 0 to (patSize -1)
	var offset = (song * patSize) ;
	var index = (phasor + offset);

	var patPlayer = BufRd.ar(1, m.helpers[\allPatterns][\pushPat].patBuf.bufnum,  index, 0, 1) ;
	var shTrg = (HPZ2.ar(phasor) > 0);
	var latchedPatOut = Trig.ar(Latch.ar(patPlayer, shTrg),0.001);

	latchedPatOut * play;
});

m.helpers[\pullPat] = Ndef(\pullPat);
Ndef(\pullPat).ar(1);


Ndef(\pullPat).addSpec(\song, [0,2,\lin,1]);
Ndef(\pullPat).addSpec(\play, [0,1,\lin,1]);
Ndef(\pullPat, {|song = 0, play = 0| //4 is silence

	var syncIn = Ndef(\syncSubClks).ar(1, 0); // 1 channel and offset 2 -> barPos ramp
	var patSize = 32;

	var phasor = (syncIn * patSize).trunc(1); // since syncIn will reset somewhere at 0.999.... this counts up from 0 to (patSize -1)
	var offset = (song * patSize) ;
	var index = (phasor + offset);

	var patPlayer = BufRd.ar(1, m.helpers[\allPatterns][\pullPat].patBuf.bufnum,  index, 0, 1) ;
	var shTrg = (HPZ2.ar(phasor) > 0);
	var latchedPatOut = Trig.ar(Latch.ar(patPlayer, shTrg),0.001);

	latchedPatOut * play;
});



(

//creates 4 pattern modules called syncPat0, syncPat1, ...
(
4.do{|patID|

	var patName = ("syncPat" ++ patID).asSymbol;

    (
        m.helpers[patName] = Ndef(patName);
		Ndef(patName).ar(1);
		//Ndef(patName).clear;

        Ndef(patName).addSpec(\offset, [0,8,\lin,1]);
        Ndef(patName).addSpec(\layer, [0,4,\lin,1]);
        Ndef(patName).addSpec(\mode, [0,3,\lin,1]);

        Ndef(patName, {|layer = 4, offset = 0, mode = 0| //4 is silence

			var syncIn = Ndef(\syncSubClks).ar(1, 2); // 1 channel and offset 2 -> beatPos ramp
			var patSizes = [8, 6, 16, 12];
			var layerSizes = [72, 54, 144, 108];

			var phasors = (syncIn * patSizes).trunc(1); // since syncIn will reset somewhere at 0.999.... this counts up from 0 to (patSize -1)
            var offsets = ((offset * patSizes) + (layer * layerSizes));
            var indices = (phasors + offsets);

			var bufnums = [
				m.helpers[\allPatterns][\mode0].patBuf.bufnum,
				m.helpers[\allPatterns][\mode1].patBuf.bufnum,
				m.helpers[\allPatterns][\mode2].patBuf.bufnum,
				m.helpers[\allPatterns][\mode3].patBuf.bufnum
			];

			var modePlayers = bufnums.collect{ |bfNum, modeID| BufRd.ar(1, bfNum,  indices[modeID], 0, 1) };
            var shTrgs = (HPZ2.ar(phasors) > 0);
            var latchedPatOuts = Trig.ar(Latch.ar(modePlayers, shTrgs),0.001);

            Select.ar(mode, latchedPatOuts);

        });
    );
};
);



(
4.do{|grooveID|

	var grooveName = ("syncGroove" ++ grooveID).asSymbol;
	var grooveFluxName = ("grooveFlux" ++ grooveID).asSymbol;
    var patName = ("syncPat" ++ grooveID).asSymbol;

    (
		m.helpers[grooveName] = Ndef(grooveName);
		Ndef(grooveName).ar(2);
		m.helpers[grooveFluxName] = Influx( [\x, \y] , [\a, \b, \c] );
       // Ndef(grooveName).clear;
        Ndef(grooveName).ar(2);

        Ndef(grooveName).addSpec(\accent, [0,1,\amp]); //lin, amp ? ausprobieren!
		Ndef(grooveName).addSpec(\blendA, [0, 15,\lin]);
		Ndef(grooveName).addSpec(\blendB, [0, 15,\lin]);
		Ndef(grooveName).addSpec(\blendC, [0, 15,\lin]);


        Ndef(grooveName, {|blendA =2.64, blendB = 7.8 , blendC =13.4, accent = 0 |

            var envelopeOut, steppedOut, shPattern, mainSync;
            var rampsUp, rampsDown, trisUp, trisDown;
            var allFigures;

            shPattern = Ndef(patName).ar(1);
			mainSync = Ndef(\syncMain).ar(1,0); // -> [normPhasor, ...skip rest]

            rampsUp = ( mainSync * [2,4,8,16] % 1.0);
            rampsDown = 1- rampsUp;
            trisUp = rampsUp.fold(0.0,0.5) * 2;
            trisDown = rampsDown.fold(0.0,0.5) * 2;

            allFigures=  [rampsUp, rampsDown, trisUp, trisDown].flatten;

			envelopeOut = SelectX.ar(  [ blendA, blendB, blendC ] , allFigures).mean + accent;
            steppedOut = Latch.ar(envelopeOut, shPattern);

            [envelopeOut, steppedOut];
        });


		m.helpers[grooveFluxName].attachMapped(
			Ndef(grooveName),
			Ndef(grooveName).key, [\blendA, \blendB, \blendC]);
		{
		m.helpers[grooveFluxName].set(\x, 1.0.rand2, \y, 1.0.rand2);
		m.helpers[grooveFluxName].rand(1.0).calcOutVals.doAction;
		}.defer(0.3);

    );
};
);

);

nil; // return value
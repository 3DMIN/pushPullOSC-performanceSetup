m.gens[\saw].isNil.if{
	"init %".format(\saw).postln;
};
m.gens[\saw] = Ndef(\saw);


Ndef(\saw).addSpec(\ctlLag      , [0    , 1  , \linear   ]);
Ndef(\saw).addSpec(\amp1        , [0    , 1  , \linear   ]);
Ndef(\saw).addSpec(\amp2        , [0    , 1  , \linear   ]);
Ndef(\saw).addSpec(\amp3        , [0    , 1  , \linear   ]);

Ndef(\saw).addSpec(\isOn1       , [0    , 1  , \linear, 1]);
Ndef(\saw).addSpec(\isOn2       , [0    , 1  , \linear, 1]);
Ndef(\saw).addSpec(\isOn3       , [0    , 1  , \linear, 1]);

Ndef(\saw).addSpec(\modAmp      , [0    , 1  , \linear   ]);

Ndef(\saw).addSpec(\pWidth      , [0.125, 0.5, \linear,  ]);
Ndef(\saw).addSpec(\freq        , ControlSpec(100,  200,  'exp', 0.0, 440, " Hz"));
Ndef(\saw).addSpec(\modFreq     , ControlSpec(100,  125,  'exp', 0.0, 440, " Hz"));
Ndef(\saw).addSpec(\filterFreq  , ControlSpec(50, 5000, 'exp', 0.0, 440, " Hz"));


Ndef(\saw, {
	var src1, src2, src3, output;

	var amp1         =         \amp1.kr(  1  , 0  );
	var amp2         =         \amp2.kr(  1  , 0  );
	var amp3         =         \amp3.kr(  1  , 0  );

	var isOn1        =        \isOn1.kr(  0  , 0  ).lagud(0, 0.5);
	var isOn2        =        \isOn2.kr(  0  , 0  ).lagud(0, 0.5);
	var isOn3        =        \isOn3.kr(  0  , 0  ).lagud(0, 0.5);

	var freq         =         \freq.kr(100  , 0  );
	var modFreq      =      \modFreq.kr(  0.1, 0.2);
	var modAmp       =       \modAmp.kr(  0  , 0.1);
	var filterFreq   =   \filterFreq.kr(100  , 0  );
	var pWidth       =       \pWidth.kr(  0.5, 0  );

	src1 = LFSaw.ar(freq + SinOsc.ar(modFreq, mul: freq * modAmp));
	src1 = RLPF.ar(src1, filterFreq, 0.1);

	src2 = LFPulse.ar(freq * 0.99 + SinOsc.ar(modFreq, mul: freq * 0.48 * modAmp), 0, pWidth);
	src2 = RLPF.ar(src2, filterFreq * 2, 0.03);

	src3 = LFPulse.ar(freq * 0.52 + SinOsc.ar(modFreq * 0.502, mul: freq * 0.501345 * modAmp), 0, pWidth);
	src3 = RLPF.ar(src2, filterFreq *0.52, 0.03);

	output = Mix([
		src1 * amp1* isOn1,
		src2 * amp2* isOn2*0.8,
		src3 * amp3* isOn3*0.8
	]).tanh;

	output!2;
}).play;


////////////// ON OFF ///////////////////////
Ndef(\saw).addHalo(\offFunc, {
	Ndef(\saw).pause;

});

Ndef(\saw).addHalo(\onFunc,  {
	Ndef(\saw).resume;
	m.ctls.pp.setLight(Color.green);

	//Ndef(\reverbAux).set("snd_%".format(name).asSymbol, 0.05); //wie hier mit set?
	//m.pushPull.netAddr.sendMsg("/outputs/rgb/1", ([255,40,0]!8).flatten.as(Int8Array)); //red

});

/////// CAPS ///////////
Ndef(\saw).addHalo(\ppFuncCaps, {|vals, trigs|

	Ndef(\saw).setUni(
		\isOn1, trigs[1],
		\isOn2, trigs[0],
		\isOn3, trigs[2],
		\modFreq, vals[4],
		\modAmp,  vals[5],
		\filterFreq, vals[4]
	)

});



/////// ENCODERS ///////////
Ndef(\saw).addHalo(\ppFuncEncoders, {|key, val, eDict| });

/////// IMU ///////////
Ndef(\saw).addHalo(\ppFuncIMU, {|iDict|
	//"%: imu %".format(\saw, iDict).inform;

	var a = iDict[\acc];
	Ndef(\saw).setBi(
		\freq, a[2] + a[0],
		\amp1,   a[1].neg,
		\amp2,   a[1].neg,
		\amp3,   a[1].neg,
		//\pWidth, a.sum / 3,
		\pWidth, 0.5,
	)


});


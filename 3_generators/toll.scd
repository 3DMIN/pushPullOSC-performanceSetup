m.gens[\toll].isNil.if{
	"init %".format(\toll).postln;
};
m.gens[\toll] = Ndef(\toll);


Ndef(\toll).addSpec(\ctlLag       , [0,       1, \linear   ]);
Ndef(\toll).addSpec(\amp          , [0,       1, \linear   ]);
Ndef(\toll).addSpec(\freq         , [100,  1500, \exp      ]);
Ndef(\toll).addSpec(\isOn0        , [  0,     1, \linear, 1]);
Ndef(\toll).addSpec(\isOn1        , [  0,     1, \linear, 1]);
Ndef(\toll).addSpec(\isOn2        , [  0,     1, \linear, 1]);
Ndef(\toll).addSpec(\lfoFq        , [  5,   180, \exp      ]);
Ndef(\toll).addSpec(\trgFq        , [  1,    25, \exp      ]);
Ndef(\toll).addSpec(\fltHFq0      , [300, 12000, \exp      ]);
Ndef(\toll).addSpec(\fltHFq1      , [200, 16000, \exp      ]);
Ndef(\toll).addSpec(\fltHFq2      , [200,  1200, \exp      ]);
Ndef(\toll).addSpec(\fltLFq0      , [ 35,   300, \exp      ]);
Ndef(\toll).addSpec(\fltLFq1      , [ 65,   500, \exp      ]);
Ndef(\toll).addSpec(\fltLFq2      , [ 55,  6300, \exp      ]);

// (b) synthesis engine
Ndef(\toll, {
	var output;
	var   src0,   src1,   src2;
	var   out0,   out1,   out2;
	var filtH0, filtH1, filtH2;
	var filtL0, filtL1, filtL2;

	var trigger;
	var env;


	var pulseMod;


	var isOn0       =   \isOn0  .kr(   0, \ctlLag.kr(0));
	var isOn1       =   \isOn1  .kr(   0, \ctlLag.kr(0));
	var isOn2       =   \isOn2  .kr(   0, \ctlLag.kr(0));
	var fltHFq0		 =	\fltHFq0.kr(1200, \ctlLag.kr(0));
	var fltHFq1		 =	\fltHFq1.kr(1800, \ctlLag.kr(0));
	var fltHFq2		 =	\fltHFq2.kr(1500, \ctlLag.kr(0));
	var fltLFq0		 =	\fltLFq0.kr( 180, \ctlLag.kr(0));
	var fltLFq1		 =	\fltLFq1.kr( 480, \ctlLag.kr(0));
	var fltLFq2		 =	\fltLFq2.kr(  80, \ctlLag.kr(0));
	var amp          =  \amp    .kr(   1, \ctlLag.kr(0));
	var freq         =  \freq   .kr( 100, \ctlLag.kr(0));
	var trgFq		 =	\trgFq  .kr(   3, \ctlLag.kr(0));
	var lfoFq		 =	\lfoFq  .kr(  12, \ctlLag.kr(0));


	trigger  = TDuty  .ar((trgFq * [1,3,8]).reciprocal, Trig.ar([isOn0, isOn1, isOn2]-0.1), 1);
	pulseMod = LFPulse.ar(lfoFq * [1,2,4] * 0.43728);
	env      = EnvGen .ar(Env.perc(0.01, 1 /(trgFq * [1,3,8]) , 1, -4),trigger);

	src0 = LFSaw.ar([freq     * (1-env[0]), lfoFq    ]).product * pulseMod[0];
	src1 = LFSaw.ar([freq * 3 * (1-env[1]), lfoFq * 3]).product * pulseMod[1];
	src2 = LFSaw.ar([freq * 8 * (1-env[2]), lfoFq * 8]).product * pulseMod[2];

	filtH0 = RHPF.ar(src0, fltHFq0, 1/7);
	filtH1 = RHPF.ar(src1, fltHFq1, 1/7);
	filtH2 = RHPF.ar(src2, fltHFq2, 1/7);

	filtL0 = RLPF.ar(src0, fltLFq0, 1/7);
	filtL1 = RLPF.ar(src1, fltLFq1, 1/7);
	filtL2 = RLPF.ar(src2, fltLFq2, 1/7);

	out0 = (filtH0 + filtL0) * env[0] * amp * isOn0;
	out1 = (filtH1 + filtL1) * env[1] * amp * isOn1;
	out2 = (filtH2 + filtL2) * env[2] * amp * isOn2;

	output = ([out0, out1, out2] * [1, 0.8, 0.5]).sum.clip2(1);

	output!2;
}).play;


////////////// MAPPING ///////////////////////
Ndef(\toll).addHalo(\offFunc, {
	Ndef(\toll).pause;

});

Ndef(\toll).addHalo(\onFunc,  {
	Ndef(\toll).resume;
	m.ctls.pp.setLight(Color.blue);

	//Ndef(\reverbAux).set("snd_%".format(name).asSymbol, 0.05); //wie hier mit set?
	//m.pushPull.netAddr.sendMsg("/outputs/rgb/1", ([255,40,0]!8).flatten.as(Int8Array)); //red

});

/////// CAPS ///////////
Ndef(\toll).addHalo(\ppFuncCaps, {|vals, trigs|

	Ndef(\toll).setUni(
		\isOn0, trigs[0],
		\isOn1, trigs[1],
		\isOn2, trigs[2],
		\trgFq, vals[4],
		\lfoFq,  vals[5]

	)

});

/////// ENCODERS ///////////
Ndef(\toll).addHalo(\ppFuncEncoders, {|key, val, eDict| });


/////// IMU ///////////
Ndef(\toll).addHalo(\ppFuncIMU, {|iDict|
	//"%: imu %".format(\toll, iDict).inform;

	var a = iDict[\acc];
	Ndef(\toll).setBi(
		\amp,         a[1].neg,
		\fltHFq0,     a[2],
		\fltLFq0,     a[0],
		\fltHFq1,     a[2].neg,
		\fltLFq1,     a[0].neg
	)


});


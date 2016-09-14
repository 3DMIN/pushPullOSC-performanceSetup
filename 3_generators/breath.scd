m.gens[\brth].isNil.if{
	"init %".format(\brth).postln;
};
m.gens[\brth] = Ndef(\brth);


(
Ndef(\brth).addSpec(\ffreq, [150, 800, \exp]);
Ndef(\brth).addSpec(\fDecay, [0.01, 2, \exp]);
Ndef(\brth).addSpec(\ffModAmount, [0.0, 1.0, \lin]);
Ndef(\brth).addSpec(\ffModLag, [0.001, 0.5, \lin]);
Ndef(\brth).addSpec(\harmBlend, [0.0, 1.0, \lin]);
Ndef(\brth).addSpec(\fbk, [0.0, 0.7, \amp]);
Ndef(\brth).addSpec(\dryWet, [0.0, 1.0, \amp]);
Ndef(\brth).addSpec(\abOn, [0,1,\amp]);
Ndef(\brth).addSpec(\cOn, [0,1,\amp]);
Ndef(\brth).addSpec(\delOn, [0,1,\amp]);
Ndef(\brth).addSpec(\grooveOn, [0,1,\amp]);

Ndef(\brth, { |ffModLag = 0.1|
	var ffreq, amp, ppIns, harmBlend;
	var dryWet, delDurs, delays, delFBout, delFBin, fbk, totalMix;
	var filtStageA, filtStageB,filtStageC, outABmix;
	var ffMod, ffModAmount;
	var abOn, cOn, delOn, grooveOn;

	ffreq = \ffreq.kr(440, 0.02);

	amp = \amp.kr(1, 0.05);
	ffModAmount = \ffModAmount.kr(1.0, ffModLag);
	harmBlend = \harmBlend.kr(0.5, 0.02);
	fbk = \fbk.kr(0.44, 0.1);
	dryWet = \dryWet.kr(0.5, 0.1);

	abOn = \abOn.kr(0, 0.02);
	cOn = \cOn.kr(0, 0.02);
	delOn = \delOn.kr(0, 0.5);
	grooveOn =\grooveOn.kr(0, 0.02);

	ppIns = Ndef(\inputsPreProcessing).ar(2);
	ffMod = 1 + ( ( Ndef(\syncGroove0).ar(1) ** 2 ) * ffModAmount * grooveOn);
	delDurs = (Ndef(\syncMain).ar(1,2)  * [0.5, 0.25] ).lag(0.1);



	filtStageA =ppIns.collect{|chan, id| BPF.ar(chan, ffreq * [1,3,5,7,9,11] * ffMod, 1/8, [4,1,0.7, 0.6,0.4,0.3]).sum * 5; };
	filtStageB =ppIns.collect{|chan, id| BPF.ar(chan, ffreq * [1,2,4,6,8,10] * ffMod, 1/8, [4,1.2,0.9, 0.7,0.5,0.35]).sum * 5; };
	outABmix = SelectX.ar(harmBlend, [filtStageA,filtStageB]);
	filtStageC = PitchShift.ar(outABmix, 0.2, 0.5);

	delFBin = LocalIn.ar(2);
	totalMix = ((outABmix * abOn) + (filtStageC * cOn) );
	delays = DelayN.ar(totalMix + (delFBin * fbk).rotate(1), 2, delDurs);
	delFBout = LocalOut.ar(delays);
	//totalMix
	(( (delays * dryWet * delOn) + (totalMix .sum !2)  ) * amp * 4).tanh;
}).play;
);

/*
q.helpers[\grooveFlux0].rand(1.0).calcOutVals.doAction;
*/

////////////// MAPPING ///////////////////////
Ndef(\brth).addHalo(\offFunc, {
	//Ndef(\brth).set(\amp, 0);
	Ndef(\brth).pause;
});

Ndef(\brth).addHalo(\onFunc, {
	Ndef(\brth).resume;
	m.ctls.pp.setLight(Color.cyan);
});


/////// CAPS ///////////
Ndef(\brth).addHalo(\ppFuncCaps, {|vals|
	// vals:
	// [ index, middle, ring, little, thumbPush, thumbPull ]

	Ndef(\brth).setUni(
		\abOn, vals[0],
		\cOn, vals[1],
		\delOn, vals[2],
		\grooveOn, (vals[3] > 0.15).asInteger

	)
});

/////// ENCODERS ///////////
Ndef(\brth).addHalo(\ppFuncEncoders, {|key, val, eDict|
	"%: enc[%->%]".format(\brth, key, val).inform;
});

/////// IMU ///////////
// Ndef(\secondSound).addHalo(\imuLastVals, m.ctls.pp.imuDict.deepCopy);
Ndef(\brth).addHalo(\ppFuncIMU, {|iDict|
	// var lastVals = Ndef(\secondSound).getHalo(\imuLastVals);
	//
	// //"%: imu %".format(\secondSound, iDict).inform;

	Ndef(\brth).setBi(\ffreq, iDict[\acc][0]);
	Ndef(\brth).setBi(\harmBlend, iDict[\acc][1]);



});


////// META keyplayer

Ndef(\brth).addHalo(\kpAction_a, {
	"%: a pressed.".format(\brth).inform;
})



//////////////// TESTS /////////////

/*
Ndef(\secondSound).getHalo(\offFunc).value;
Ndef(\secondSound).getHalo(\onFunc).value;
Ndef(\secondSound).getHalo(\ppFuncCaps).value([0.5, 1.0.rand, 0, 0, 0, 0]);


m.ctls.pp.capNormVals
m.ctls.pp.imuDict
m.ctls.pp.encoderDict


*/
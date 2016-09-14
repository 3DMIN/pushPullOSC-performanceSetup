q.gens[\firstSound].isNil.if{
	"init %".format(\firstSound).postln;
};
q.gens[\firstSound] = Ndef(\firstSound);



Ndef(\firstSound).addSpec(\freq, [50, 1600, \exp]);
Ndef(\firstSound, {
	var freq = \freq.kr(440, 0.02);
	var amp = \amp.kr(0, 0.02);

	LPF.ar(PinkNoise.ar, freq) * amp!2
});


////////////// MAPPING ///////////////////////
Ndef(\firstSound).addHalo(\offFunc, {
	Ndef(\firstSound).set(\amp, 0);
	Ndef(\firstSound).stop;
});

Ndef(\firstSound).addHalo(\onFunc, {
	Ndef(\firstSound).play;
});


/////// CAPS ///////////
Ndef(\firstSound).addHalo(\ppFuncCaps, {|vals|
	// vals:
	// [ index, middle, ring, little, thumbPush, thumbPull ]

	Ndef(\firstSound).setUni(
		\freq, vals[1],
		\amp, vals[0]
	)
});

/////// ENCODERS ///////////
Ndef(\firstSound).addHalo(\ppFuncEncoders, {|key, val, eDict|
	"%: enc[%->%]".format(\firstSound, key, val).inform;
});

/////// IMU ///////////
Ndef(\firstSound).addHalo(\ppFuncIMU, {|iDict|
	//"%: imu %".format(\firstSound, iDict).inform;
});


//////////////// TESTS /////////////

/*
Ndef(\firstSound).getHalo(\offFunc).value;
Ndef(\firstSound).getHalo(\onFunc).value;
Ndef(\firstSound).getHalo(\ppFuncCaps).value([0.5, 1.0.rand, 0, 0, 0, 0]);
*/
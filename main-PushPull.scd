// A PushPull performance setup
// by Till Bovermann
// more information at http://3dmin.github.io
// http://tai-studio.org

/********
Server.killAll;
*********/

//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(
///////////    UTILS	  ///////////////////////

m = MeTA(path: thisProcess.nowExecutingPath.dirname, server: s);

/*
m.openFiles("configs",   ["3_userConfig"], warn: true);
*/

///////////    CONFIG	  ///////////////////////
m.config.numChans = 2;

// name of the PushPull
m.config.ppName = \daniel;

// the interfacing class; very likely
m.config.ppType= PushPullOSC_SE;

/////// NetAddr of PushPull
// dedicated network
m.config.ppAddr    = NetAddr("169.254.1.1", 9000); //
// ad'hoc
// m.config.ppAddr    = NetAddr("169.254.1.1", 9000);

/////// is it a left-handed version?
m.config.ppIsLeft  = true;

/////// tareing values
m.config.ppCapTare = [ [ 0, 8380 ], [ 0, 5571 ], [ 0, 9423 ], [ 514, 11222 ], [ 0, 8672 ], [ 0, 9388 ] ];

//// load configuration
m.loadFiles("configs", [
	"1_serverConfig",
	"2_networkConfig"
]);

m.server.waitForBoot({
	//	m.server.scope(q.numChans).window.bounds_(Rect(700, 5, 261, 250));


	///////////   HELPER NDEFS  ///////////////////////
	"loading HELPERS...".inform;
	// m.loadFiles("helperNdefs", ["utilsNdef"]);


	///////////    GENERATORS	  ///////////////////////
	"loading GENS...".inform;
	m.loadGen("breath"     , 1);
	m.loadGen("saw"         , 2);
	m.loadGen("firstSound" , 3);
	m.loadGen("toll"        , 4);

	/* open all gens
	q.utils.openFiles("gen", ["*"]); // */



	///////////   AUX-EFFECTS   ///////////////////////
	"loading AUX EFX...".inform;
	m.loadAux("reverbAux", m.config.numChans, 0.2);

});
);

(

///////////    CONTROLLERS	  ///////////////////////
"loading CONTROLLERS...".inform;

m.loadFiles(\control, [
	"NdefMixer",
	"pushPullOSC",
	"soundSelector-KeyPlayer",
	// "UC4-mixer" // a mixer implemented on the UC4
]);

/*
m.openFiles(\control, [
"NdefMixer",
"pushPullOSC",
"soundSelector-KeyPlayer"
]);
*/


///////////    MAPPING   	  ///////////////////////
"loading MAPPING...".inform;
(
	m.loadFiles("map", [
		"ppMapping",
		"keyPlayerMapping",
	// "mixerMapping-UC4"
	]);
);

{m.utils.generatorSelectAction(m.getNdefGens.first.key);}.defer;

);


(
m.auxBus[\reverbAux].set(\snd_flxMtrx, 0);
m.auxBus[\reverbAux].set(\snd_saw, 0.8);
m.auxBus[\reverbAux].set(\snd_scndSnd, 0.5);
m.auxBus[\reverbAux].set(\snd_brth, 0.3);


Ndef('reverb').set('t60', 1.5432325262237, 'damp', 0.6, 'size', 0.72222222222222, 'earlydiff', 0.59444444444444, 'in', ProxySubmix('reverbAux'), 'mdepth', 44.166666666667, 'mfreq', 0.055555555555556);
)


// select a sound manually
m.utils.generatorSelectAction(m.config.genNames[1]);
m.utils.generatorSelectAction(m.config.genNames[2]);
m.utils.generatorSelectAction(m.config.genNames[3]);
m.utils.generatorSelectAction(m.config.genNames[4]);
m.utils.generatorSelectAction(m.config.genNames[5]);

m.maps.ppMappingFuncs = {
	var dict = (
		imu:  MFunc(),
		caps: MFunc(),
		encoders: MFunc()
	);

	// alive func
	dict[\imu].add(\alive, {|el|
		m.utils.ppAlive = 1
	});

	// IMU
	m.ctls.pp.imuAction_{|iDict|
		dict[\imu].value(iDict);
	};

	// CAPS
	m.ctls.pp.capAction_{|normVals, trigs, rawVals|
		dict[\caps].value(normVals, trigs, rawVals)
	};

	// ENCODERS
	m.ctls.pp.encoderAction_{|key, val, eDict|
		dict[\encoders].value(key, val, eDict)
	};

	dict;
}.value;


m.utils.selectPPMapping = {|env, gen|

	/// IMU
		// remove previous control
	m.maps.ppMappingFuncs[\imu ].remove(\control);
		// add new control
	m.maps.ppMappingFuncs[\imu].add(\control, {|iDict|
		m.gens[gen].getHalo(\ppFuncIMU).value(iDict)
	});


		// CAPS
	// remove previous control
	m.maps.ppMappingFuncs[\caps   ].remove(\control);
	// add new control
	m.maps.ppMappingFuncs[\caps  ].add(\control, {|normVals, trigs, rawVals|
		m.gens[gen].getHalo(\ppFuncCaps).value(normVals, trigs, rawVals)
	});


		// ENCODERS
	// remove previous control
	m.maps.ppMappingFuncs[\encoders ].remove(\control);
	// add new control
	m.maps.ppMappingFuncs[\encoders].add(\control, {|key, val, eDict|
		m.gens[gen].getHalo(\ppFuncEncoders).value(key, val, eDict)
	});

};


/*
m.utils.selectPPMapping(\drumsDHML); // */


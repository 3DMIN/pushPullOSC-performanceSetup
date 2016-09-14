// select sounds with green buttons

m.ctls.mixer.elAt(\bt, \1, nil, \on).do{|el, idx|
	el.action = {|el|
		m.config.genNames[idx+1].notNil.if{
			m.utils.generatorSelectAction(m.config.genNames[idx+1])
		}
	}
};


// volume control
m.ctls.mixer.elAt(\sl, \1).action = {|el|
	var idx = el.index + 1;
	m.config.genNames[idx].notNil.if{
		m.gens[m.config.genNames[idx]].vol = el.value
	}
};

// main volume
m.ctls.mixer.elAt(\xfader).action = {|el|
	m.server.volume.volume = el.value.ampdb
};


/*

m.ctls.mixer.trace(true)
m.ctls.mixer.trace(false)
*/

// return value
nil;
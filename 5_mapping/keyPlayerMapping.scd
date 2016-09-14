m.config.genNames.keysValuesDo{|key, name|
	var gen = m.gens[name];

	m.ctls.keyPlayers[key] = KeyPlayer(name);

	// mapping for 0..9 to switch between gens
	"1234567890".do{|char|
		var genName, idx;

		idx = char.digit;
		genName = m.config.genNames[idx];

		genName.notNil.if{
			m.ctls.keyPlayers[key].put(char, {
				m.utils.generatorSelectAction(genName)
			})
		};

	};


	"qwertzuiopasdfghjklyxcvbnm".do{|char|
		var actionName = "kpAction_%".format(char).asSymbol;
		gen.getHalo(actionName).notNil.if{
			m.ctls.keyPlayers[key].put(char,
				{gen.getHalo(actionName).value})
		};
	}
};

/////////////////// TOOLS
m.utils.generatorSelectAction = {|env, genName|
	// activate gen
	(genName.notNil).if{
		m.selectGenerator(genName);
		m.utils.selectPPMapping(genName);
		{m.utils.updateKeyPlayer(genName);}.defer;
	};
};


m.utils.updateKeyPlayer = {|env, genName|
	m.views.keyPlayers.switchToPlayer(genName);
};

/*
q.views.keyPlayers.switchToPlayer(\firstSound);
q.views.keyPlayers.switchToPlayer(\secondSound);
q.views.keyPlayers.buttonForPlayerName(\breath2DHML);

q.views.keyPlayers.buttons.collect(_.states).postcs
*/
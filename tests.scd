// various testing of functionality can go here

m.ctls.pp.setLight(Color.red);


m.ctls.pp.setLight(Color.yellow(1));


m.ctls.pp.setLight((Color.red!4) ++ (Color.blue!4));


Tdef(\player, {
	100.do{|j|

		m.ctls.pp.setLight(
			{|i| Color.red.blend(Color.green.blend(Color.blue, j/100), i/8)}!8
		);
		0.1.wait;
	}
}).play



(
Tdef(\player, {
	var colors = [Color.red, Color.green , Color.yellow, Color.blue];

	100.do{|j|
		m.ctls.pp.setLight(
			colors.wrapAt(j).blend(Color.white, j/10%10)
		);
		0.1.wait;
	}
}).play
)


m.ctls.pp.netAddr


// instantiate PushPullOSC



m.ctls.pp =  m.ctls.pp ?? {
	m.config.ppType.new(m.config.ppAddr);
};

m.ctls.pp.isLeft = m.config.ppIsLeft;

/*
m.ctls.pp.trace[\imu] = true
m.ctls.pp.trace[\imu] = false
m.ctls.pp.trace[\cap] = true
m.ctls.pp.trace[\cap] = false
*/

/*
m.ctls.pp.tareCap(true)
m.ctls.pp.tareCap(false)
*/


m.ctls.pp; // return value


const express = require('express');
const shell = require('shelljs');
const app = require('express')()
const basicAuth = require('express-basic-auth');
const tcpp = require('tcp-ping');

const port = 3000;
const installer = '';


 
app.use(basicAuth({
    users: { 'admin': 'xyz123' }
}))



app.get('/', (request, response) => {
  response.send('Red5 Pro Controller Ready!!');
})


app.post('/api/2.0/admin/server/start', (request, response) => {

	shell.exec('sudo /etc/init.d/red5pro start');	
	response.send('Starting server ....');
})


app.post('/api/2.0/admin/server/stop', (request, response) => {

	shell.exec('sudo /etc/init.d/red5pro stop');	
	response.send('Stopping server ....');
})


app.post('/api/2.0/admin/server/restart', (request, response) => {
	
	shell.exec('sudo /etc/init.d/red5pro restart');
	response.send('Restarting server!');

})



app.post('/api/2.0/admin/server/ping', (request, response) => {
  	
	tcpp.probe('127.0.0.1', 5080, function(error, available){

		if(error)
		{
			response.send('Error : ' + error);
		}
		else
		{
			response.send('Server running = ' + available);
		}

	});
})



app.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err);
  }

  console.log('server is listening on ' + port);
})

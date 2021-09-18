const express = require("express");
const app = express();
const port = 4000;

const https = require("https");
const fs = require('fs')
const httpsOptions = {
    key: fs.readFileSync('./cert/cert.key'),
    cert: fs.readFileSync('./cert/cert.pem')
}
const server = https.createServer(httpsOptions, app);

const io = require("socket.io")(server);
app.use(express.static(__dirname + "/public"));

const peers = {};

io.sockets.on("error", e => console.log(e));
io.sockets.on("connection", socket => {

    /* Asking all other clients to setup the peer connection receiver */

    socket.on('join room', () => {
        
         for(let id in peers) {
             if(id === socket.id) continue
             console.log("sending init to '" + id + "' about " +  socket.id)
             socket.to(id).emit('other joined', socket.id)
         }

         if (!peers[socket.id]) {
             peers[socket.id] = [socket.id];
         }
       
        console.log(peers)
    });

    socket.on('offer', (id, message) => {
        console.log(id, ' send offer to ', socket.id)
        socket.to(id).emit('offer', socket.id, message);
    })

    socket.on('answer', (id, message) => {
        console.log('ans from ', id, ' to ', socket.id)
        socket.to(id).emit('answer', socket.id, message);
    })

    socket.on('candidate', (id, message) => {
        console.log('candidate from ', id, ' to ', socket.id, message)
        socket.to(id).emit('candidate', socket.id, message);
    })


    socket.on('disconnect', () => {
        console.log('socket disconnected ' + socket.id)
        delete peers[socket.id]
        for (let socket_id in peers) {
            socket.to(socket_id).emit('remove peer', socket.id);
        }
        
    })
   

});

server.listen(port, () => console.log(`Server is running on port ${port}`));
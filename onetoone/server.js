const express = require("express");
const app = express();
const port = 4000;

const http = require("http");
const server = http.createServer(app);

const io = require("socket.io")(server);
app.use(express.static(__dirname + "/public"));

let peers = {};
io.sockets.on("error", e => console.log(e));
io.sockets.on("connection", socket => {
    peers[socket.id] = socket

    /* Asking all other clients to setup the peer connection receiver */
    for(let id in peers) {
        if(id === socket.id) continue
        console.log(id + ' sending receive to ' + socket.id)
        peers[id].emit('other user', socket.id)
    }

    socket.on('offer', (id, message) => {
        socket.to(id).emit('offer', socket.id, message);
    })

    socket.on('answer', (id, message) => {
        socket.to(id).emit('answer', socket.id, message);
    })

    socket.on('candidate', (id, message) => {
        socket.to(id).emit('candidate', socket.id, message);
    })

});

server.listen(port, () => console.log(`Server is running on port ${port}`));
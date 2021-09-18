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
app.set('views', __dirname + '/public');
app.set('view engine', 'ejs'); 

app.get('/', (req, res) => {
    res.render('index.ejs', { text: 'Hey', _url: req.protocol+"://"+req.headers.host })
})

app.get('/magic', (req, res) => {
    res.render('magic.ejs', { text: 'Hey', _url: req.protocol+"://"+req.headers.host })
})

app.get('/guest', (req, res) => {
    res.render('guest.ejs', { text: 'Hey', _url: req.protocol+"://"+req.headers.host })
})

app.get('/guest/:id', (req, res) => {
    res.render('guest.ejs', { uname: req.params.id, _url: req.protocol+"://"+req.headers.host })
})

const peers = {};
const rooms = {};

io.sockets.on("error", e => console.log(e));
io.on("connection", socket => {


    let curRoom = null;

    socket.on("joinRoom", data => {
        const { room } = data;

        if (!rooms[room]) {
        rooms[room] = {
            name: room,
            occupants: {},
        };
        }

        const joinedTime = Date.now();
        rooms[room].occupants[socket.id] = joinedTime;
        curRoom = room;

        console.log(`${socket.id} joined room ${room}`);
        socket.join(room);

        socket.emit("connectSuccess", { joinedTime });
        const occupants = rooms[room].occupants;
        io.in(curRoom).emit("occupantsChanged", { occupants });
    });

    socket.on("send", data => {
        io.to(data.to).emit("send", data);
    });

    socket.on("broadcast", data => {
        socket.to(curRoom).broadcast.emit("broadcast", data);
    });

    socket.on("disconnect", () => {
        console.log('disconnected: ', socket.id, curRoom);
        if (rooms[curRoom]) {
        console.log("user disconnected", socket.id);

        delete rooms[curRoom].occupants[socket.id];
        const occupants = rooms[curRoom].occupants;
        socket.to(curRoom).broadcast.emit("occupantsChanged", { occupants });

        if (occupants == {}) {
            console.log("everybody left room");
            delete rooms[curRoom];
        }
        }
    });



    /* Asking all other clients to setup the peer connection receiver */

    socket.on('join room', () => {
        if (!peers[socket.id]) {
            peers[socket.id] = [socket.id];
        }
       
        for(let id in peers) {
            if(id === socket.id) continue
            console.log("sending init to '" + id + "' about " +  socket.id)
            socket.to(id).emit('other joined', socket.id)
        }

        console.log(peers)
    });

    socket.on('offer', (id, message) => {
        socket.to(id).emit('offer', socket.id, message);
    })

    socket.on('answer', (id, message) => {
        socket.to(id).emit('answer', socket.id, message);
    })

    socket.on('candidate', (id, message) => {
        socket.to(id).emit('candidate', socket.id, message);
    })

    socket.on('disconnect', () => {
        delete peers[socket.id]
        for (let socket_id in peers) {
            socket.to(socket_id).emit('remove peer', socket.id);
        }
        
    })
   
    socket.on('video', (data) => {
        io.sockets.emit('video', {sid: data.sid});
    });

});

server.listen(port, () => console.log(`Server is running on port ${port}`));
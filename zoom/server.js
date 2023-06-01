const express = require('express')
const app = express()

const https = require("https");
const fs = require('fs')
const httpsOptions = {
    key: fs.readFileSync('./cert/cert.key'),
    cert: fs.readFileSync('./cert/cert.pem')
}
const server = https.createServer(httpsOptions, app);

const io = require('socket.io')(server)
const PORT = 3000;
const peers = {};

app.set('view engine', 'ejs')
app.use(express.static('public'))

app.get('/', (req, res) => {
    res.redirect('/zoom')
})

app.get('/:room', (req, res) => {
    // res.render('room', {roomId: req.params.room})
    res.render('d3');
})

io.on('connection', socket => {
    socket.on('join-room', roomId => {
        if (!peers[roomId]) {
            peers[roomId] = [socket.id];
        }else{
            peers[roomId].push(socket.id);
        }
        
        const guestUser = peers[roomId].find(id => id != socket.id)
        if(guestUser) {
            socket.emit('guest-user', guestUser)
            socket.to(guestUser).emit('guest-joined', socket.id)
        }
    })

    socket.on('offer', payload => {
        io.to(payload.target).emit('offer', payload);
    })

    socket.on('answer', payload => {
        io.to(payload.target).emit('answer', payload);
    })

    socket.on('icecandidate', incoming => {
        io.to(incoming.target).emit('icecandidate', incoming.candidate);
    })
})

server.listen(PORT)
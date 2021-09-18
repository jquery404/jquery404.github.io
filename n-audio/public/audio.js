let localStream = null;
let remoteStream = null;
let peers = {}
let audios = []
let streams = []
let colors = ['#EBC3DB', '#C4F7A1'];

// Get camera and microphone
const hostAudio = document.querySelector(".host");
const canvasEl = document.querySelector("canvas");
const audioSelect = document.querySelector("select#audioSource");

audioSelect.onchange = getStream;

getStream().then(getDevices).then(gotDevices);

function getStream() {
    if (window.stream) {
      window.stream.getTracks().forEach(track => {
        track.stop();
      });
    }
    const audioSource = audioSelect.value;
    const constraints = {
      audio: { deviceId: audioSource ? { exact: audioSource } : undefined },
      video: false
    };
    return navigator.mediaDevices
      .getUserMedia(constraints)
      .then(gotStream)
      .catch(handleError);
}

function gotStream(stream) {
    window.stream = stream;
    audioSelect.selectedIndex = [...audioSelect.options].findIndex(
      option => option.text === stream.getAudioTracks()[0].label
    );
    hostAudio.srcObject = stream;
    localStream = stream;
    init();
    startVisualizer();
}

function handleError(error) {
    console.error("Error: ", error);
}

function getDevices() {
    return navigator.mediaDevices.enumerateDevices();
}

function gotDevices(deviceInfos) {
    window.deviceInfos = deviceInfos;
    for (const deviceInfo of deviceInfos) {
      const option = document.createElement("option");
      option.value = deviceInfo.deviceId;
      if (deviceInfo.kind === "audioinput") {
        option.text = deviceInfo.label || `Microphone ${audioSelect.length + 1}`;
        audioSelect.appendChild(option);
      } 
    }
}

const socket = io.connect(window.location.origin);

function init(){
    socket.emit('join room');

    socket.on('other joined', (socket_id) => {
      console.log(socket_id, ' joined')
      peers[socket_id] = addPeer(socket_id, true);
      localStream.getTracks().forEach(track => streams.push(peers[socket_id].addTrack(track, localStream)))
    })

    socket.on('offer', (socket_id, description) => {
      console.log(socket_id, ' make peer')
      peers[socket_id] = addPeer(socket_id, false)
  
      peers[socket_id].setRemoteDescription(description)
          .then(() => { localStream.getTracks().forEach(track => streams.push(peers[socket_id].addTrack(track, localStream))); })
          .then(() => peers[socket_id].createAnswer())
          .then(sdp => peers[socket_id].setLocalDescription(sdp))
          .then(() => {
            console.log('received offer preparing ans for ', socket_id, peers[socket_id].localDescription.type)
            socket.emit('answer', socket_id, peers[socket_id].localDescription);
          });
    })

    socket.on('answer', (socket_id, description) => {
      console.log('received ans back from ', socket_id);
      peers[socket_id].setRemoteDescription(description);
    })

    socket.on('candidate', (socket_id, candidate) => {
      if (socket_id in peers) {
        console.log('received candidate from ', socket_id);
        peers[socket_id].addIceCandidate(new RTCIceCandidate(candidate));
      }
      
      //peers[socket_id].addIceCandidate(new RTCIceCandidate(candidate)).catch(e => console.error(e));
    })
  
    socket.on('remove peer', (socket_id) => {
      console.log(socket_id, ' left')
      removePeer(socket_id)
    })
}


function removePeer(socket_id) {
  if (peers[socket_id]) {
    peers[socket_id].close();
    peers[socket_id].onicecandidate = null; 
    delete peers[socket_id];
    document.querySelector("#"+socket_id).remove();
    document.querySelector("#cvs"+socket_id).remove();
  }

  document.querySelector("pre").innerHTML += socket_id + ' left\n';
}

function addPeer(socket_id, am_initiator) {
    const peers = new RTCPeerConnection(config);

    peers.onicecandidate = event => {
        if (event.candidate) {
          console.log(socket_id, ' needs candidate');
          socket.emit('candidate', socket_id, event.candidate);
        }
    };
    
    peers.ontrack = event => {
      if(!audios.includes(socket_id)){
        let guestAudio = document.createElement('video')
        remoteStream = event.streams[0];
        guestAudio.srcObject = remoteStream;
        guestAudio.id = socket_id
        guestAudio.playsinline = false
        guestAudio.autoplay = true
        guestAudio.muted = false
        document.body.appendChild(guestAudio)

        let guestCanvasEl = document.createElement('canvas')
        guestCanvasEl.width = 300;
        guestCanvasEl.height = 50;
        guestCanvasEl.id = 'cvs'+socket_id
        document.body.appendChild(guestCanvasEl)

        new AudioVisualizer(guestAudio, guestCanvasEl, colors[1], remoteStream).visualize();
        audios.push(socket_id);
      }
        

    };

    if (am_initiator === true) {
        peers.onnegotiationneeded = () => {
            peers.createOffer()
            .then(sdp => peers.setLocalDescription(sdp))
            .then(() => { 
              console.log('making offer to ', socket_id, peers.localDescription.type)
              socket.emit('offer', socket_id, peers.localDescription); 
            });
        };
    }

    return peers;
}


/** audio visualiser */
function startVisualizer() {
  new AudioVisualizer(hostAudio, canvasEl, colors[0], localStream).visualize();
}

function AudioVisualizer(video, canvas, color, stream) {
  this.video = video;
  this.canvas = canvas;
  this.color = color;
  this.stream = stream;
}

AudioVisualizer.prototype = {
  async visualize() {
    var canvas = this.canvas;
    var WIDTH = canvas.width;
    var HEIGHT = canvas.height;
  
    var ctx = canvas.getContext("2d");
  
    var audioContext = new (window.AudioContext || window.webkitAudioContext)();
    var analyser = audioContext.createAnalyser();
    var dataArray = new Uint8Array(analyser.frequencyBinCount);
    
    if (localStream instanceof Blob) {
        const arrayBuffer = await new Response(this.stream).arrayBuffer();
        const audioBuffer = await audioContext.decodeAudioData(arrayBuffer);
        source = audioContext.createBufferSource();
        source.buffer = audioBuffer;
        source.connect(analyser);
        source.start(0);
    }
    else {
        var source = audioContext.createMediaStreamSource(this.stream);
        source.connect(analyser);
    }
  
    analyser.fftSize = 1024;
    var bufferLength = analyser.fftSize;
    var dataArray = new Uint8Array(bufferLength);
  
    ctx.clearRect(0, 0, WIDTH, HEIGHT);
    
    var draw = () => {
        requestAnimationFrame(draw);
        analyser.getByteTimeDomainData(dataArray);
  
        ctx.fillStyle = this.color;
        ctx.fillRect(0, 0, WIDTH, HEIGHT);
  
        ctx.lineWidth = 2;
        ctx.strokeStyle = "black";
  
        ctx.beginPath();
  
        var sliceWidth = WIDTH * 1.0 / bufferLength;
        var x = 0;
  
        for(var i = 0; i < bufferLength; i++) {
  
            var v = dataArray[i] / 128.0;
            var y = v * HEIGHT/2;
  
            if(i === 0)
                ctx.moveTo(x, y);
            else
                ctx.lineTo(x, y);
            x += sliceWidth;
        }
  
        ctx.lineTo(WIDTH, HEIGHT/2);
        ctx.stroke();
    };
  
    draw();
  }
};


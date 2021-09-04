let localStream = null;
let peers = {}

// Get camera and microphone
const videoElement = document.querySelector("video");
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
    videoElement.srcObject = stream;
    localStream = stream;
    init();
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
      if(!videos.includes(socket_id)){
        let newVid = document.createElement('video')
        newVid.srcObject = event.streams[0];
        newVid.id = socket_id
        newVid.playsinline = false
        newVid.autoplay = true
        newVid.muted = true
        document.body.appendChild(newVid)
        videos.push(socket_id);
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
let localStream = null;
let peers = {}
let streams = []

// Get camera and microphone
const videoElement = document.querySelector("video");
const audioSelect = document.querySelector("select#audioSource");
const videoSelect = document.querySelector("select#videoSource");

audioSelect.onchange = getStream;
videoSelect.onchange = getStream;

getStream().then(getDevices).then(gotDevices);

function getStream() {
    if (window.stream) {
      window.stream.getTracks().forEach(track => {
        track.stop();
      });
    }
    const audioSource = audioSelect.value;
    const videoSource = videoSelect.value;
    const constraints = {
      audio: { deviceId: audioSource ? { exact: audioSource } : undefined },
      video: { deviceId: videoSource ? { exact: videoSource } : undefined }
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
    videoSelect.selectedIndex = [...videoSelect.options].findIndex(
      option => option.text === stream.getVideoTracks()[0].label
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
      } else if (deviceInfo.kind === "videoinput") {
        option.text = deviceInfo.label || `Camera ${videoSelect.length + 1}`;
        videoSelect.appendChild(option);
      }
    }
}

const socket = io.connect(window.location.origin);

function init() {

    socket.on('other user', socket_id => {
        console.log('INIT RECEIVE ' + socket_id)
        peers[socket_id] = addPeer(socket_id, false)
        
        localStream.getTracks().forEach(track => streams.push(peers[socket_id].addTrack(track, localStream)))
    })
    
    socket.on('offer', (socket_id, description) => {
        peers[socket_id] = addPeer(socket_id, true)
    
        peers[socket_id].setRemoteDescription(description)
            .then(() => { localStream.getTracks().forEach(track => peers[socket_id].addTrack(track, localStream)); })
            .then(() => peers[socket_id].createAnswer())
            .then(sdp => peers[socket_id].setLocalDescription(sdp))
            .then(() => {
                socket.emit('answer', socket_id, peers[socket_id].localDescription);
            });
    })
    
    socket.on('answer', (socket_id, description) => {
        peers[socket_id].setRemoteDescription(description);
    })

    socket.on('candidate', (socket_id, candidate) => {
        peers[socket_id].addIceCandidate(new RTCIceCandidate(candidate)).catch(e => console.error(e));
    })

}


function addPeer(socket_id, am_initiator) {
    const peers = new RTCPeerConnection(config);

    peers.onicecandidate = event => {
        if (event.candidate) {
          socket.emit('candidate', socket_id, event.candidate);
        }
    };
    
    peers.ontrack = event => {
        let newVid = document.createElement('video')
        newVid.srcObject = event.streams[0];
        newVid.id = socket_id
        newVid.playsinline = false
        newVid.autoplay = true
        newVid.muted = true
        document.body.appendChild(newVid)
    };

    if (am_initiator === false) {
        peers.onnegotiationneeded = () => {
            peers.createOffer()
            .then(sdp => peers.setLocalDescription(sdp))
            .then(() => { socket.emit('offer', socket_id, peers.localDescription); });
        };
    }

    return peers;
}

function shareScreen() {
    navigator.mediaDevices.getDisplayMedia({ cursor: true }).then(stream => {
        const screenTrack = stream.getTracks()[0];
        streams.find(sender => sender.track.kind === 'video').replaceTrack(screenTrack);
        screenTrack.onended = function() {
            streams.find(sender => sender.track.kind === 'video').replaceTrack(localStream.getTracks()[1]);
        }
    })
}
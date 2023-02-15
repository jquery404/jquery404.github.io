let localStream = null;
let peers = {}
let streams = []
let videos = []
let myid;
let guestUser;
let peerRef;
let senders = []
let clients = {sender: {tag: '', socket_id: ''}, receiver: []}
let isSharing = false;

// Get camera and microphone
const videoElement = document.querySelector(".host");
const guestVideoElement = document.querySelector(".guest");
const audioSelect = document.querySelector("select#audioSource");
const videoSelect = document.querySelector("select#videoSource");
const video = document.querySelector("#video2");

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
    // init();
}

function startCall() {
    if (document.getElementById('builder').checked) {
        document.getElementById('model_canvas').removeAttribute("hidden"); 
    }
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

    myid = socket.id;
    socket.emit('join-room', 'zoom');

    socket.on('guest-user', (socket_id) => {
      callGuest(socket_id);
      guestUser = socket_id; 
    })

    socket.on('guest-joined', (socket_id) => {
        guestUser = socket_id; 
    })

    socket.on('offer', handleRecieveCall)

    socket.on('answer', handleAnswer)

    socket.on('icecandidate', handleNewICECandidateMsg)
}

function callGuest(socket_id) {
    peerRef = createPeer(socket_id);
    console.log('ll')
    localStream.getTracks().forEach(track => senders.push(peerRef.addTrack(track, localStream)));
}

function createPeer(socket_id) {
    const peer = new RTCPeerConnection({
        iceServers: [
            {
                urls: 'stun:stun.stunprotocol.org'
            },
            {
                urls: 'turn:numb.viagenie.ca',
                credential: 'muazkh',
                username: 'webrtc@live.com'
            },
        ]
    });

    peer.onicecandidate = handleICECandidateEvent;
    peer.ontrack = handleTrackEvent;
    peer.onnegotiationneeded = () => handleNegotiationNeededEvent(socket_id);

    return peer;
}

function handleICECandidateEvent(e) {
    if (e.candidate) {
        const payload = {
            target: guestUser,
            candidate: e.candidate,
        }
        socket.emit('icecandidate', payload);
    }
}

function handleNewICECandidateMsg(incoming) {
    const candidate = new RTCIceCandidate(incoming);

    peerRef.addIceCandidate(candidate)
        .catch(e => console.log(e));
}

function handleTrackEvent(e) {
    guestVideoElement.srcObject = e.streams[0];
};

function handleNegotiationNeededEvent(socket_id) {
    peerRef.createOffer().then(offer => {
        return peerRef.setLocalDescription(offer);
    }).then(() => {
        const payload = {
            target: socket_id,
            caller: myid,
            sdp: peerRef.localDescription
        };
        socket.emit("offer", payload);
    }).catch(e => console.log(e));
}

function handleRecieveCall(incoming) {
    peerRef = createPeer();
    const desc = new RTCSessionDescription(incoming.sdp);
    peerRef.setRemoteDescription(desc).then(() => {
        localStream.getTracks().forEach(track => senders.push(peerRef.addTrack(track, localStream)));
    }).then(() => {
        return peerRef.createAnswer();
    }).then(answer => {
        return peerRef.setLocalDescription(answer);
    }).then(() => {
        const payload = {
            target: incoming.caller,
            caller: myid,
            sdp: peerRef.localDescription
        }
        socket.emit("answer", payload);
    })
}

function handleAnswer(message) {
    const desc = new RTCSessionDescription(message.sdp);
    peerRef.setRemoteDescription(desc).catch(e => console.log(e));
}

function shareScreen() {
    isSharing = !isSharing;
    
    
    if (!isSharing) {
        document.getElementById('drawShare').innerHTML = "Start Sharing";
        senders.find(sender => sender.track.kind === 'video').replaceTrack(localStream.getTracks()[1]);
    }else{
        const screenTrack = c.captureStream().getTracks()[0];
        senders.find(sender => sender.track.kind === 'video').replaceTrack(screenTrack);
        document.getElementById('drawShare').innerHTML = "Stop Sharing";
    }
    
        // screenTrack.onended = function () {
        //     senders.find(sender => sender.track.kind === 'video').replaceTrack(localStream.getTracks()[1]);
        // }
}

function on() {
    document.getElementById("overlay").style.display = "block";
}
  
function off() {
    document.getElementById("overlay").style.display = "none";
}
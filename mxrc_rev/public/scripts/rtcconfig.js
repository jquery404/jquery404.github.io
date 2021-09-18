const config = {
    iceServers: [
        { 
          "urls": "stun:stun.l.google.com:19302",
        },
        // { 
        //   "urls": "turn:TURN_IP?transport=tcp",
        //   "username": "TURN_USERNAME",
        //   "credential": "TURN_CREDENTIALS"
        // }
        {
          url: 'turn:numb.viagenie.ca',
          credential: 'jquery404@gmail.com',
          username: 'Pot64hook'
        },
    ]
};
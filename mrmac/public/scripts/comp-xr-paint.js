const usersMap = {};

// Painting on the surface using the controller 
AFRAME.registerComponent('painter', {

    schema: {
        color: {default: 'red', type: 'color'},
        canDraw: {default: false, type: 'boolean'},
    },

    init: function () {
    
    this.userData = {};

    this.initPaint();

    this.el.addEventListener('triggerdown', () => {
        if(!this.data.canDraw) return;
        
        this.initPaint();
        this.userData.isSelecting = true;
        // set start
        this.cursor.setFromMatrixPosition(this.hand.object3D.matrixWorld);
        this.painter.moveTo(this.cursor);
        NAF.connection.broadcastDataGuaranteed("stroke-start", this.hand.object3D.matrixWorld);
    });
    
    this.el.addEventListener('triggerup', () => {
        this.userData.isSelecting = false;
        NAF.connection.broadcastDataGuaranteed("stroke-ended", this.hand.object3D.matrixWorld);
        // remove paint after certain seconds
        this.painter.removeInTime(this.hand.sceneEl.object3D, 20);
    });


    this.userData.isSelecting = false;
    },

    initPaint() {
        this.painter = new TubePainter();
        this.painter.setSize( 0.4 );
        this.painter.mesh.material.side = THREE.DoubleSide;
        this.painter.setColor(new THREE.Color(this.data.color));
        
        this.cursor = new THREE.Vector3();
        this.hand = this.el;
        this.hand.sceneEl.object3D.add(this.painter.mesh);
    },

    mapping: {
        axis0: 'trackpad',
        axis1: 'trackpad',
        button0: 'trackpad',
        button1: 'trigger',
        button2: 'grip',
        button3: 'menu',
        button4: 'system'
    },

    onButtonEvent: function (id, evtName) {
        var buttonName = this.mapping['button' + id];
        this.el.emit(buttonName + evtName);
        this.updateModel(buttonName, evtName);
    },

    updateModel: function (buttonName, state) {
        console.log(buttonName, state);
    },

    update() {
        this.painter.setColor(new THREE.Color(this.data.color));
    },

    tick: function () {
        var userData = this.userData;
        var painter = this.painter;

        if (userData.isSelecting === true) {
            let matric = this.hand.object3D.matrixWorld;
            // matric.elements[14] -= 5;

            this.cursor.setFromMatrixPosition(matric);
            painter.lineTo(this.cursor);
            painter.update();
            NAF.connection.broadcastDataGuaranteed("stroke-started", this.hand.object3D.matrixWorld);
        }
    },

});

// Synchronize drawing for all participants
AFRAME.registerComponent('sync-paint', {
    schema: {
    },

    init: function() {
    // keep track of each avatar / networkID / clientID

    this.userData = {};
    let that = this;

    document.body.addEventListener("entityCreated", function(evt) {
        console.log("entityCreated event. clientId =", evt.detail.el);
        const el = evt.detail.el;
        const networkedComponent = el.getAttribute("networked");
        usersMap[networkedComponent.creator] = {
            networkId: networkedComponent.networkId,
            el: el,
        };
        //let currentOwnerId = usersMap[''].el.components.networked.data.owner;
    });

    document.body.addEventListener("clientDisconnected", function(evt) {
        if (usersMap[evt.detail.clientId])
        delete usersMap[evt.detail.clientId];
    });
    
    // receive and react

    function createIndicator(parent) {
        var indicator = document.createElement("a-entity");
        indicator.setAttribute("position", "0 1 0");
        
        var sphere = document.createElement("a-sphere");
        sphere.setAttribute("radius", "0.1");
        sphere.setAttribute("position", "0 -0.4 0");
        indicator.appendChild(sphere);

        var box = document.createElement("a-box");
        box.setAttribute("scale", "0.1 0.7 0.1");
        box.setAttribute("position", "0 0.1 0");
        indicator.appendChild(box);

        parent.appendChild(indicator);
        return indicator;
    }
    

    NAF.connection.subscribeToDataChannel("stroke-start", function newData(sender, type, data, target) {
        if (!usersMap[sender]) {
            console.log("unknown sender");
            return;
        }
        let clientData = usersMap[sender];

        if (clientData.indicator) {
            clientData.el.removeChild(clientData.indicator);
            clientData.indicator = null;
        } else {
            clientData.indicator = createIndicator(clientData.el);
        }

        that.initPaint();
        that.userData.isSelecting = true;
        // set start
        that.cursor.setFromMatrixPosition(data);
        that.painter.moveTo(that.cursor);
    });

    NAF.connection.subscribeToDataChannel("stroke-started", function newData(sender, type, data, target) {
        if (!usersMap[sender]) {
        console.log("unknown sender");
        return;
        }
        // set start
        var userData = that.userData;
        var painter = that.painter;
    
        if (userData.isSelecting === true) {
            that.cursor.setFromMatrixPosition(data);
            painter.lineTo(that.cursor);
            painter.update();          
        }
    });

    NAF.connection.subscribeToDataChannel("stroke-ended", function newData(sender, type, data, target) {
        if (!usersMap[sender]) {
        console.log("unknown sender");
        return;
        }
        let clientData = usersMap[sender];

        if (clientData.indicator) {
            clientData.el.removeChild(clientData.indicator);
            clientData.indicator = null;
        }
        
        that.userData.isSelecting = false;
        if(that.painter !== undefined) {
            that.painter.update();
            that.painter.removeInTime(that.el.sceneEl.object3D, 5);
        }
    });

    this.userData.isSelecting = false;
    },

    initPaint() {
        this.painter = new TubePainter();
        this.painter.setSize( 0.4 );
        this.painter.mesh.material.side = THREE.DoubleSide;
        this.painter.setColor(new THREE.Color('red'));
        
        this.cursor = new THREE.Vector3();
        this.hand = this.el;
        this.hand.sceneEl.object3D.add(this.painter.mesh);
    },
    
});


// Synchronize pointer for all participants
AFRAME.registerComponent('sync-pointer', {
    schema: {
    },

    init: function() {
        // keep track of each avatar / networkID / clientID

        this.userData = {};
        let that = this;

        document.body.addEventListener("entityCreated", function(evt) {
            console.log("entityCreated event. clientId =", evt.detail.el);
            const el = evt.detail.el;
            const networkedComponent = el.getAttribute("networked");
            usersMap[networkedComponent.creator] = {
                networkId: networkedComponent.networkId,
                el: el,
            };
            //let currentOwnerId = usersMap[''].el.components.networked.data.owner;
        });

        document.body.addEventListener("clientDisconnected", function(evt) {
            if (usersMap[evt.detail.clientId])
            delete usersMap[evt.detail.clientId];
        });
        
    

        NAF.connection.subscribeToDataChannel("pointer-start", function newData(sender, type, data, target) {
            console.log('someone pointing', sender);
        });

        NAF.connection.subscribeToDataChannel("pointer-close", function newData(sender, type, data, target) {
            console.log('someone closed pointing', sender);
        });

    },
   
});



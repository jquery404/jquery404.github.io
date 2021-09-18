// Just for some unneccessary fun e.g. phew phew phew... 
AFRAME.registerComponent('gun', {
    schema: {
        bulletTemplate: {default: '#bullet-template'},
    },

    init: function() {
        this.el.addEventListener('gun-fire', this.onGunFire.bind(this));
    },

    onGunFire: function() {
        this.shoot();
    },

    shoot: function() {
        this.createBullet();
    },

    createBullet: function() {
        var el = document.createElement('a-entity');
        el.setAttribute('networked', 'template:' + this.data.bulletTemplate);
        el.setAttribute('remove-in-seconds', 3);
        el.setAttribute('forward', 'speed:0.3');
    
        var tip = this.el;
        el.setAttribute('position', this.getInitialBulletPosition(tip));
        el.setAttribute('rotation', this.getInitialBulletRotation(tip));
    
        this.el.sceneEl.appendChild(el);
    },

    getInitialBulletPosition: function(spawnerEl) {
        var worldPos = new THREE.Vector3();
        worldPos.setFromMatrixPosition(spawnerEl.object3D.matrixWorld);
        return worldPos;
    },

    getInitialBulletRotation: function(spawnerEl) {
        var worldDirection = new THREE.Vector3();
    
        spawnerEl.object3D.getWorldDirection(worldDirection);
        worldDirection.multiplyScalar(-1);
        this.vec3RadToDeg(worldDirection);
    
        return worldDirection;
    },

    vec3RadToDeg: function(rad) {
        rad.set(rad.y * 90, -90 + (-THREE.Math.radToDeg(Math.atan2(rad.z, rad.x))), 0);
    }
});

// Its physics, the bullet always moves forward, duh! 
AFRAME.registerComponent('forward', {
    schema: {
        speed: {default: 0.1},
    },

    init: function() {
        var worldDirection = new THREE.Vector3();
    
        this.el.object3D.getWorldDirection(worldDirection);
        worldDirection.multiplyScalar(-1);
    
        this.worldDirection = worldDirection;
        console.error(this.worldDirection);
    },

    tick: function() {
        var el = this.el;
    
        var currentPosition = el.getAttribute('position');
        var newPosition = this.worldDirection
            .clone()
            .multiplyScalar(this.data.speed)
            .add(currentPosition);
        el.setAttribute('position', newPosition);
    }
});

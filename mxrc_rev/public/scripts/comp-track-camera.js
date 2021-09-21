AFRAME.registerComponent('track-camera', {
    schema: {
        target: {default: []},
    },

    init: function(){
        this.target = this.data.target;
    },

    update: function(){
        this.target = this.data.target;
    },

    tick: (function () {
      const position = new THREE.Vector3();
      const rotation = new THREE.Quaternion();
      const direction = new THREE.Vector3();
      const euler = new THREE.Euler();
      const matrix = new THREE.Matrix4();
      return function () {
        
        this.el.object3D.updateMatrixWorld();
        position.setFromMatrixPosition(this.el.object3D.matrixWorld); // Vector3
        rotation.setFromRotationMatrix(matrix.extractRotation(this.el.object3D.matrixWorld ));
        var e = this.el.object3D.matrixWorld.elements;
        direction.set(e[8], e[9], e[10]).normalize();
        
        // var debug = document.getElementById("debug");
        // debug.setAttribute("value", "Position: " + position.x.toFixed(2) + " " + position.y.toFixed(2) + " " + position.z.toFixed(2) + " ," + "Rotation: " + rotation.x.toFixed(2) + " " + rotation.y.toFixed(2) + " " + rotation.z.toFixed(2) + " ," + "Direction: " + direction.x.toFixed(2) + " " + direction.y.toFixed(2) + " " + direction.z.toFixed(2));

        // target tracking
        this.target.forEach((elem, i) => {
            var targetEl = this.el.sceneEl.querySelector(elem);	
            if (targetEl) {
                this.lookAt(targetEl.object3D, position, i);
            }
        });
      }
    })(),

    lookAt: function(obj, pos, i){
        obj.lookAt(pos);
        const distanceFromCamera = 3; 
        const target = new THREE.Vector3(0, 0, -distanceFromCamera);
        target.applyMatrix4(this.el.object3D.matrixWorld);    
        
        const distance = obj.position.distanceTo(target);
        if (distance > 0) {
            // const amount = Math.min(moveSpeed * deltaTime, distance) / distance;
            obj.position.lerp(target, 0.05 + i/100*4);
        } 
    }
});

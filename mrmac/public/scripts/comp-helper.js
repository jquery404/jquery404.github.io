    
    // mxrc room @username
    AFRAME.registerComponent('mxrc-room', {
        schema: { 
            name: {type: 'string', default: 'Hello 👋'} 
        },

        init: function () {
            var person = prompt("Please enter your name", "Harry Potter");

            if (person != null) {
                var el = this.el;
            
                // Set local user's name
                var myNametag = document.querySelector('.nametag');
                myNametag.setAttribute('text', 'value', person);
                
                // Setup networked-scene
                var networkedComp = {
                    room: 'basic',
                    debug: true,
                };
                el.setAttribute('networked-scene', networkedComp);
            }
        
        }
    });
    
    // Remove something after some seconds 
    AFRAME.registerComponent('remove-in-seconds', {
        schema: { default: 1 },
    
        init: function() {
            setTimeout(this.destroy.bind(this), this.data * 1000);
        },
    
        destroy: function() {
            var el = this.el;
            el.parentNode.removeChild(el);
        }
    });

    // Spawn in circle
    AFRAME.registerComponent('spawn-in-circle', {
        schema: {
          radius: {type: 'number', default: 1}
        },
      
        init: function() {
          var el = this.el;
          var center = el.getAttribute('position');
      
          var angleRad = this.getRandomAngleInRadians();
          var circlePoint = this.randomPointOnCircle(this.data.radius, angleRad);
          var worldPoint = {x: circlePoint.x + center.x, y: center.y+.2, z: circlePoint.y + center.z};
          el.setAttribute('position', worldPoint);
      
          var angleDeg = angleRad * 180 / Math.PI;
          var angleToCenter = -1 * angleDeg + 90;
          var angleRad = THREE.Math.degToRad(angleToCenter);
          el.object3D.rotation.set(0, angleRad, 0);
        },
      
        getRandomAngleInRadians: function() {
          return Math.random()*Math.PI*2;
        },
      
        randomPointOnCircle: function (radius, angleRad) {
          var x = Math.cos(angleRad)*radius;
          var y = Math.sin(angleRad)*radius;
          return {x: x, y: y};
        }
    });

    // Indicator of hud direction
    AFRAME.registerComponent('hud-indicator', {
        schema: {
          dir: {default: 'left'}
        },
        
        init: function() {
            var el = this.el;
            
            el.setAttribute('position', '0 0 -90');
            el.setAttribute('rotation', '.25 0 0');
            el.setAttribute('animation', 'property: position; to: .5 0 0; dur: 1000; loop: true');
        },

        update: function() {
            var el = this.el;
            var data = this.data;
            var animation = el.getAttribute('animation');

            if (data.dir == 'left') {
                el.setAttribute('visible', 'true');
                el.setAttribute('rotation', '0 0 90');
                el.setAttribute('position', '-.25 0 0');
                el.setAttribute('animation', 'property: position; to: -.5 0 0; dur: 1000; loop: true');
            } else if (data.dir == 'right') {
                el.setAttribute('visible', 'true');
                el.setAttribute('rotation', '0 0 -90');
                el.setAttribute('position', '.25 0 0');
                el.setAttribute('animation', 'property: position; to: .5 0 0; dur: 1000; loop: true');
            } else if (data.dir == 'none') {
                el.setAttribute('visible', 'false');
            }
            
        },

    });

   
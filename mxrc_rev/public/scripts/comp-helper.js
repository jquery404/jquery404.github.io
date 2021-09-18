    
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

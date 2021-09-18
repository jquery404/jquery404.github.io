// Toast for the lego model that you will be building
AFRAME.registerComponent('lego-model', {
    schema: {
    legoTemplate: {default: '#lego-template'},
    legoSrc: {default: '#goal-glb'},
    isShowing: {default: false},
    },

    init: function () {
        this.el.addEventListener('lego-goal', this.onLegoGoalToggle.bind(this));
    },

    onLegoGoalToggle: function() {

        if(!this.data.isShowing){
            var el = document.createElement('a-entity');
            el.id = 'legoGoal';
            el.setAttribute('scale', '.02 .02 .02');
            el.setAttribute('position', '0 .05 -.4');
            el.setAttribute('gltf-model', this.data.legoSrc)
            // setTimeout(this.toggleShowing.bind(this), 3 * 1000);
            this.data.isShowing = true;
            this.el.appendChild(el);
        }else{
            var el = document.getElementById('legoGoal');
            el.setAttribute('remove-in-seconds', .5);
            this.data.isShowing = false;
        }
    
    },

    toggleShowing: function(){
        var el = this.el;
        this.data.isShowing = false;
    },

    update: function (oldData) {   
        // this.onLegoGoalToggle();
    }

});


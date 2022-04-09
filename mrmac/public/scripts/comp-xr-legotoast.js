// Toast for the lego model that you will be building
AFRAME.registerComponent('lego-model', {
    schema: {
    legoTemplate: {default: '#lego-template'},
    legoSrc: {default: '#goal3-glb'},
    isShowing: {default: false},
    currentLegoId: {default: 1},
    },

    init: function () {
        this.el.addEventListener('lego-goal', this.onLegoGoalToggle.bind(this));
    },

    onLegoGoalToggle: function() {

        if(!this.data.isShowing){
            var el = document.createElement('a-entity');
            // var modelName = this.data.legoSrc; 
            var modelName = '#goal'+this.data.currentLegoId+'-glb'; 
            el.id = 'legoGoal';
            el.setAttribute('scale', '.1 .1 .1');
            el.setAttribute('position', '0 .05 -.4');
            el.setAttribute('gltf-model', modelName)
            // el.setAttribute('gltf-model', this.data.legoSrc)
            // setTimeout(this.toggleShowing.bind(this), 3 * 1000);
            this.data.isShowing = true;
            this.data.currentLegoId  = this.data.currentLegoId >=9 ? 1: this.data.currentLegoId + 1;
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


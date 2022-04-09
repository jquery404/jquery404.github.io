
    // Managing skybox src attribute like a boss
    AFRAME.registerComponent('set-sky', {
        schema: {default:'#sky'},
        init: function() {
            this.sky = this.el;
        },
        update: function() {
            this.sky.setAttribute('src', this.data);
        }
    });
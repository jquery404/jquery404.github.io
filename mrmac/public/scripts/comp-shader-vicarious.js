AFRAME.registerShader('viewpoint', {
    schema: {
      color: {type: 'color', is: 'uniform', default: '#ff0000'},
      timeMsec: {type: 'time', is: 'uniform'},
      uMap: {type: 'map', is: 'uniform'},
      vicarious:{type: 'int', is: 'uniform', default: 0},
      isActive: {type: 'bool', is: 'uniform', default: false}
    },
  
    vertexShader: `
    #define SCALE 10.0
    
    varying vec2 vUv;

    uniform bool isActive;
    
    uniform float timeMsec;  

    uniform int vicarious;
    
    float calculateSurface(float x, float z) {
        float uTime = timeMsec / 1000.0;
        float y = 0.0;
        y += (sin(x * 1.0 / SCALE + uTime * 1.0) + sin(x * 2.3 / SCALE + uTime * 1.5) + sin(x * 3.3 / SCALE + uTime * 0.4)) / 3.0;
        y += (sin(z * 0.2 / SCALE + uTime * 1.8) + sin(z * 1.8 / SCALE + uTime * 1.8) + sin(z * 2.8 / SCALE + uTime * 0.8)) / 3.0;
        return y;
    }
    
    void main() {
        float uTime = timeMsec / 1000.0;
        vUv = uv;
        vec3 pos = position;
        float strength = 1.5;
        //pos.y += strength * calculateSurface(pos.x, pos.z);
        //pos.y -= strength * calculateSurface(0.0, 0.0);
        if(isActive && vicarious == 2){
            pos.z += strength;
        }
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }  
    `,
    fragmentShader: `
    varying vec2 vUv;
    
    uniform sampler2D uMap;

    uniform bool isActive;

    uniform int vicarious;
    
    uniform vec3 color;
    
    uniform float timeMsec; 
    
    void main() {
        float uTime = timeMsec / 1000.0;
        vec2 uv = vUv;
        vec4 tex1 = texture2D(uMap, uv);
        vec4 bordercolor = vec4(1, 0, 0, .1);
        float texValue = texture2D(uMap, uv).r;
    
        gl_FragColor = tex1;
        
        if(isActive && vicarious == 1){
          gl_FragColor = mix(gl_FragColor, bordercolor, texValue);
        }
    
    }`
    
    });
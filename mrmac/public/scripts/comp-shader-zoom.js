AFRAME.registerShader('zoom', {
    schema: {
      color: {type: 'color', is: 'uniform', default: '#0051da'},
      timeMsec: {type: 'time', is: 'uniform'},
      uMap: {type: 'map', is: 'uniform'},
      isActive: {type: 'bool', is: 'uniform', default: false}
    },
  
    vertexShader: `
    #define SCALE 10.0
    
    varying vec2 vUv;

    uniform bool isActive;
    
    uniform float timeMsec;  
    
    float calculateSurface(float x, float z) {
        float uTime = timeMsec / 1000.0;
        float y = 1.0;
        y += (sin(x * 3.3 / SCALE + uTime * 1.0) + sin(x * 2.3 / SCALE + uTime * 1.5) + sin(x * 3.3 / SCALE + uTime * 0.4)) / 3.0;
        y += (sin(z * 2.8 / SCALE + uTime * 1.8) + sin(z * 1.8 / SCALE + uTime * 1.8) + sin(z * 2.8 / SCALE + uTime * 0.8)) / 3.0;
        return y;
    }
    
    void main() {
        float uTime = timeMsec / 1000.0;
        vUv = uv;
        vec3 pos = position;
        float strength = 1.2;
        //pos.y += strength * calculateSurface(pos.x, pos.z);
        if(isActive){        
            pos.z += strength;
        }
        //pos.y -= strength * calculateSurface(0.0, 0.0);
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }  
    `,
    fragmentShader: `
    varying vec2 vUv;
    
    uniform sampler2D uMap;
    
    uniform vec3 color;
    
    uniform float timeMsec; 
    
    void main() {
        float uTime = timeMsec / 1000.0;     
        vec2 uv = vUv;
        vec4 tex1 = texture2D(uMap, uv * 1.0);
    
        vec3 blue = color;
    
        gl_FragColor = tex1;
    
    }`
    
});
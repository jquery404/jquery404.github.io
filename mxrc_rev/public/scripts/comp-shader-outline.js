AFRAME.registerShader('outline', {
    schema: {
      color: {type: 'color', is: 'uniform', default: '#0051da'},
    },
  
    vertexShader: `
    uniform float offset;    
  
    void main() {
        vec4 pos = modelViewMatrix * vec4( position + normal * offset, 1.0 );
        gl_Position = projectionMatrix * pos;
    }  
  `,
    fragmentShader: `
  
  void main() {
      gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
  
  }`
  
  });
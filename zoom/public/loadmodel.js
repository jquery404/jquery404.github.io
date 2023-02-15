import * as THREE from 'three';
import { OrbitControls } from 'OrbitControls';
import { GLTFLoader } from 'GLTFLoader';
import { RoomEnvironment } from 'RoomEnvironment';

const lego = 'models/model3_.glb';
const camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
const renderer = new THREE.WebGLRenderer( { antialias: true } );
renderer.setPixelRatio( window.devicePixelRatio );
renderer.setSize( window.innerWidth*.5, window.innerHeight*.5 );
renderer.outputEncoding = THREE.sRGBEncoding;
const pmremGenerator = new THREE.PMREMGenerator( renderer );

const scene = new THREE.Scene();
scene.background = new THREE.Color( 0x111111 );
scene.environment = pmremGenerator.fromScene( new RoomEnvironment(), 0.04 ).texture;

document.getElementById("model_canvas").appendChild( renderer.domElement );

camera.position.z = 3;

const controls = new OrbitControls( camera, renderer.domElement );
controls.target.set( 0, 0.5, 0 );
controls.update();
controls.enablePan = false;
controls.enableDamping = true;


const loader = new GLTFLoader();
loader.load(lego, function ( gltf ) {
	const model = gltf.scene;
	model.position.set( 0, 0, 0 );
	model.scale.set( 0.5, 0.5, 0.5 );
	scene.add( model );
}, undefined, function ( e ) {
	console.error( e );
} );

const color = 0xFFFFFF;
const intensity = 1;
const light = new THREE.DirectionalLight(color, intensity);
light.position.set(0, 10, 0);
light.target.position.set(-5, 0, 0);
scene.add(light);
scene.add(light.target);

function animate() {
	requestAnimationFrame( animate );
	renderer.render( scene, camera );
};
animate();
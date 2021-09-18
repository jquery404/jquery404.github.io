// syncing avatar
NAF.schemas.add({template: '#player-template', components: ['position', 'rotation']});
NAF.schemas.add({template: '#avatar-template', components: ['position', 'rotation', {
    selector: '.nametag',
    component: 'text',
    property: 'value'
}]});
NAF.schemas.add({template: '#hand-template', components: ['position', 'rotation']});
NAF.schemas.add({template: '#pointer-template', components: ['position', 'rotation', {
    selector: '.pointer',
    component: 'visible',
}]});
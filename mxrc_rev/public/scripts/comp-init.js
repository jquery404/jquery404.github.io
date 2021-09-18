
    const menu = document.querySelector("#controller-menu");
    const menulabel = document.querySelector("#menulabel");
    const lhand = document.querySelector("#lhand");
    const rhand = document.querySelector("#rhand"); 
    const menuColor = '#FFC65D'; 
    let selectedMenu = '';
    let showPointer = false;
    let isMenuSelected;
    let isMenuHovered;

    $(lhand).on("triggerdown triggerup", function(e) {
        visibility(menu);
    });

    $(rhand).on("triggerdown", function(e) {
        
        var myPointer = document.querySelector('.pointer');
        myPointer.setAttribute('visible', 'true');

        if(isMenuHovered) {
            isMenuSelected = true;
            selectedMenu = menulabel.getAttribute('value');
        }
        
        if(isMenuSelected && !isMenuHovered){
            switch (selectedMenu) {
                case 'lego-goal':
                    lhand.emit("lego-goal");
                    rhand.setAttribute("painter", {canDraw: false});
                    break;
                
                case 'paint':
                    rhand.setAttribute("painter", {canDraw: true});
                    break;

                case 'shoot':
                    rhand.setAttribute("painter", {canDraw: false});
                    rhand.emit("gun-fire");
                    break;

                case 'pointer':
                    showPointer = true;
                    break;    
            
                default:
                    break;
            }
        }
        
    });

    $(rhand).on("triggerup", function(e) {
        
        var myPointer = document.querySelector('.pointer');
        myPointer.setAttribute('visible', 'false');
        
    });

    $(".menu-item").on("raycaster-intersected", function(e) {
        if (!menu.object3D.visible) return;
        let targetEl = this.getAttribute("data-target");
        this.setAttribute('color', '#ff0000');
        this.setAttribute('radius', '0.55');
        menulabel.setAttribute('value', targetEl);
        isMenuHovered = true;
    });

    $(".menu-item").on("raycaster-intersected-cleared", function(e) {
        this.setAttribute('color', menuColor);   
        this.setAttribute('radius', '0.45');
        isMenuHovered = false
    });

    function visibility(el) {
        el.setAttribute("visible", !el.object3D.visible);
    }


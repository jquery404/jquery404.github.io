
    const menu = document.querySelector("#controller-menu");
    const menulabel = document.querySelector("#menulabel");
    const lhand = document.querySelector("#lhand");
    const rhand = document.querySelector("#rhand"); 
    const menuColor = '#FFC65D'; 
    let selectedMenu = '';
    let prevMenu = '';
    let toggleMenu = ['lego-goal', 'pointer'];
    let isMenuSelected;
    let isMenuHovered;

    $(lhand).on("triggerdown triggerup", function(e) {
        visibility(menu);
    });

    $(rhand).on("triggerdown", function(e) {

        if(isMenuHovered) {
            isMenuSelected = true;
            selectedMenu = menulabel.getAttribute('value');

            let thisMenu = $(`[data-target="${selectedMenu}"]`);

            // toggle buttons
            if(toggleMenu.includes(selectedMenu)){
                if(thisMenu.hasClass('on')) thisMenu.removeClass('on')
                else thisMenu.addClass('on');
    
                if (selectedMenu == 'lego-goal'){
                    lhand.emit("lego-goal");
                }else if(selectedMenu == 'pointer'){
                    var myPointer = document.querySelectorAll('.pointer');
                    myPointer.forEach(elem => {
                        elem.setAttribute('visible', thisMenu.hasClass('on') ? 'true' : 'false');
                    });                    
                }
            }
            // general buttons
            else {
                if(prevMenu && prevMenu[0].getAttribute('data-target') !== thisMenu[0].getAttribute('data-target')) {
                    prevMenu.removeClass('on');
                    resetMenuStyle(prevMenu[0]);
                }
                thisMenu.addClass('on');
                prevMenu = thisMenu;
            }
           
        }
        

        if(isMenuSelected && !isMenuHovered){

            switch (selectedMenu) {
                case 'paint':
                    rhand.setAttribute("painter", {canDraw: true});                    
                    break;

                case 'shoot':
                    rhand.setAttribute("painter", {canDraw: false});
                    rhand.emit("gun-fire");                    
                    break;

                default:
                    break;
            }
        }
        
    });


    $(".menu-item").on("raycaster-intersected", function(e) {
        if (!menu.object3D.visible) return;
        let targetEl = this.getAttribute("data-target");
        menulabel.setAttribute('value', targetEl);
        setMenuStyle(this);
        isMenuHovered = true;
    });

    $(".menu-item").on("raycaster-intersected-cleared", function(e) {
        isMenuHovered = false
        if($(this).hasClass('on')) return;

        resetMenuStyle(this);        
    });

    function visibility(el) {
        el.setAttribute("visible", !el.object3D.visible);
    }

    function setMenuStyle(el){
        el.setAttribute('color', '#ff0000');
        el.setAttribute('opacity', '1');
    }

    function resetMenuStyle(el){
        el.setAttribute('color', menuColor);   
        el.setAttribute('opacity', '.5');
    }

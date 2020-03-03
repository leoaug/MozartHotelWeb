contextDisabled=true; 
contextMenu="contextMenu"; 
contextObject=""; 
currentMenu = contextMenu; 

function myRClick(e){ 
    //alert('Botao:'+contextDisabled);
    
    if(contextDisabled){ 
              return true; 
    } 
    if(_d.all) { 
        ev=event.button; 
        contextObject=event.srcElement;
    } else { 
        ev=e.which; 
        contextObject=e.target;
    } 
    if(ev==2||ev==3){ 
        _gm=getMenuByName(currentMenu);
        
        if(_gm!=null) 
            popup(currentMenu ,1);
        contextDisabled = true; 
        return false ;
    }
    return true; 
}

if(ns4){ 
    _d.captureEvents(Event.MOUSEDOWN); 
    _d.onmousedown=myRClick; 
} else{ 
    _d.onmouseup=myRClick; 
    _d.oncontextmenu=new Function("return false"); 
} 

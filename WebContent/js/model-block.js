function GetEvent(e){ 
    return ( e ? e : window.event );
}
function GetKeyCode(e){ 
    var _ev = GetEvent(e);  
    return ( _ev.keyCode ? _ev.keyCode : _ev.which );
} 
function CancelBubble(e){  
    var _ev = GetEvent(e);
    
    if (_ev.stopPropagation) { 
        _ev.stopPropagation(); //firefox
    } else{ 
        _ev.cancelBubble = true; 
        _ev.returnValue = false; 
    } 
}


function SetStyle(obj, position, zIndex, top, left, width, height){ 
    var objStyle = obj.style;  

    if (position && position!==null) {objStyle.position = position; } 
    if (zIndex && zIndex!==null) { objStyle.zIndex = zIndex; } 
    if (top && top!==null) { objStyle.top = top; } 
    if (left && left!==null) { objStyle.left = left; } 
    if (width && width!==null) { objStyle.width = width; } 
    if (height && height!==null) { objStyle.height = height; } 
} 
function GetElement(objId){ 
    return document.getElementById(objId); 
} 
function GetElementPos(obj){  
    var left=0, top=0, width=obj.offsetWidth, height=obj.offsetHeight;  

    try {
        while (obj) {  
            left += obj.offsetLeft;  
            top += obj.offsetTop;  
            obj = obj.offsetParent;  
            if (obj) { 
                if (obj.tagName == 'BODY') break; 
                var p = obj.style.position; 
                if (p == 'absolute') break; 
            } 
        }  
    }
    catch (e) { }

    return {left:left, top:top, width:width, height:height};  
} 
function GetMouseEventPos(e){ 
    var _ev = GetEvent(e); 

    if(_ev.clientX && _ev.clientY) { 
        var _sc=GetScroll(); 
        return {left:_ev.clientX + _sc.left, top:_ev.clientY + _sc.top};  
    } else {  
        return {left:_ev.pageX, top:_ev.pageY}; 
    } 
} 
function GetScreenSize(){  
    var height=0, width=0;  
    if( typeof( window.innerHeight ) == 'number' ) {  
        height = window.innerHeight;  
        width = window.innerWidth;  
    } else if( document.documentElement && document.documentElement.clientHeight ) {  
        height = document.documentElement.clientHeight;  
        width = document.documentElement.clientWidth;  
    } else if( document.body && document.body.clientHeight ) {  
        height = document.body.clientHeight;  
        width = document.body.clientWidth;  
    } 
    return {width:width, height:height, top:0, left:0};  
} 
function GetScroll(element){ 
    var top=0, left=0; 

    if (!element){ 
        element = (document.documentElement ? document.documentElement : document.body); 
    } 

    do { 
      top += element.scrollTop  || 0; 
      left += element.scrollLeft || 0; 
      element = element.parentNode; 
    } while (element); 

    return {left:left, top:top};  
}  
function Display(obj, show){ 
    if (typeof(show) == 'undefined'){ 
        show = (obj.style.display == 'none'); 
    } 
    if (typeof(obj) == 'string'){ 
        obj = GetElement(obj); 
    } 
	if(obj!= null){
       obj.style.display = (show ? 'block' : 'none');  
	}
} 
function GetObjRelativePos(menu, refererPos, referer, topOrientation, leftOrientation, offSetTop, offSetLeft, scrollType){ 
    if (!refererPos){ refererPos = (referer ? GetElementPos(referer) : GetScreenSize()); } 
    var menuPos = GetElementPos(menu);  
    var pageScroll = GetScroll(referer);

    var top, left;    
    switch (topOrientation){    
        case 0: top = refererPos.top - menuPos.height + pageScroll.top; break;    
        case 1: top = refererPos.top - menuPos.height + refererPos.height + pageScroll.top; break;    
        case 2: top = refererPos.top - pageScroll.top; break;    
        case 3: top = refererPos.top + refererPos.height + pageScroll.top; break;    
        case 4: top = refererPos.top + (refererPos.height / 2) + pageScroll.top; break;    
        case 5: top = refererPos.top + (refererPos.height / 2) - menuPos.height + pageScroll.top; break; 
        case 6: top = refererPos.top + (refererPos.height / 2) - (menuPos.height / 2) + pageScroll.top; break; 
    }    
    if (offSetTop) { top += offSetTop; }    

    switch (leftOrientation){    
        case 0: left = refererPos.left - menuPos.width + pageScroll.left; break;    
        case 1: left = refererPos.left - menuPos.width + refererPos.width + pageScroll.left; break;    
        case 2: left = refererPos.left - pageScroll.left; break;    
        case 3: left = refererPos.left + refererPos.width + pageScroll.left; break;    
        case 4: left = refererPos.left + (refererPos.width / 2) + pageScroll.left; break;    
        case 5: left = refererPos.left + (refererPos.width / 2) - menuPos.width + pageScroll.left; break;    
        case 6: left = refererPos.left + (refererPos.width / 2) - (menuPos.width / 2) + pageScroll.left; break;    
    }    
    if (offSetLeft) { left += offSetLeft; }  

    return {"top":top, "left":left};  
}  

document.write('<div id=\'bodyDiv\'></div>'); 
function AppendToBody(control){  
    var theDiv; 
    if (typeof(control) == 'string'){ 
        theDiv = document.createElement('div'); 
        theDiv.innerHTML = control;  
    } 
    else{ 
        theDiv = control; 
    } 
    GetElement('bodyDiv').appendChild(theDiv); 
}  

var lightBox = {   
    level:0,   
    flowLevels:[31000, 31200, 31400, 31600, 31800],
    
    Show : function(panel, centerPage, times){    
        var _zIndex = this.flowLevels[(this.level < 0 ? 0 : this.level)]; 
        if (typeof(panel) == 'string') {panel = GetElement(panel); } 

        if (panel.style.display == '' || panel.style.display == 'none'){ 
             if (this.lightFrame == null){  
                 AppendToBody('<div id="lightFrame" style="display:none;position:absolute;top:0px;left:0px;background:#000;opacity:0.6;-moz-opacity: 0.6;-khtml-opacity:0.6;filter:alpha(opacity=60);width:100%;height:100%;"><iframe frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="background:#000;opacity:0;-moz-opacity: 0;-khtml-opacity:0;filter:alpha(opacity=0);width:100%;height:100%;"></iframe></div>'); 
             }  
             
             var screenHeight = GetScreenSize().height;
             
             this.lightFrame = GetElement('lightFrame'); 
             this.lightFrame.style.zIndex = _zIndex; 
             this.lightFrame.style.height = (screenHeight > document.body.clientHeight ? screenHeight : document.body.clientHeight) + 'px';
             
             Display(panel, true);
             Display(this.lightFrame, true);  

             this.CenterOnPage(panel, _zIndex, centerPage, times);
         }
    },
    
    CenterOnPage : function(panel, _zIndex, centerPage, times){
        if (times){
            if (times >= 0) times--;
            else return;
        }
        
        var middleWindow = GetObjRelativePos(panel, null, null, 6, 6);  
        SetStyle(panel, 'absolute', parseInt(_zIndex + 100), middleWindow.top + 'px', middleWindow.left + 'px'); 

        
        if (centerPage && panel.style.display != 'none'){
            setTimeout(function(){
                lightBox.CenterOnPage(panel, _zIndex, centerPage, times);
            }, 500);
        }
    },
        
    Close : function(panel){ 
        if (typeof(panel) == 'string') {panel = GetElement(panel); } 

        this.level--; 
        if (this.level <= 0){    
            Display(this.lightFrame, false);    
        }    
        else {   
			if(this.lightFrame!= null){
               this.lightFrame.style.zIndex = this.flowLevels[this.level-1];    
			}
        }    
        Display(panel, false); 
    }
}
var movePanelManager = {
    DragStart : function(panelId, e){      
        this.screenSize = GetScreenSize(); 

        if (this.movingPanel){   
            this.DragEnd();   
            return;   
        }  

        this.movingPanel = GetElement(panelId);  

        this.movingPanelPos = GetElementPos(this.movingPanel); 

        var scroll = GetScroll(this.movingPanel); 
        SetStyle(this.movingPanel, 'absolute', null, this.movingPanelPos.top + 'px', this.movingPanelPos.left + 'px'); 

        this.firstEvPos = GetMouseEventPos(e); 
    },

    DragEnd : function(){  
        if (this.movingPanel){  
            this.movingPanel = null;  
            this.movingPanelPos = null;  

            this.firstEvPos = null;  

            _alastIndex = null;  
            _lastIndex = null;  
        }  
    },
    
    Drag : function(e){ 
        if (this.movingPanel){  
            var _evPos = GetMouseEventPos(e); 

            var scroll = GetScroll(this.movingPanel); 
            if ((typeof(_evPos.top) == 'undefined' || typeof(_evPos.left) == 'undefined')) {  
                this.DragEnd();  
                return;  
            }  

            var left = this.movingPanelPos.left + (_evPos.left - this.firstEvPos.left); 
            if (left < 0) {left = 0;} 
            if (left > this.screenSize.width - this.movingPanelPos.width) { left = this.screenSize.width - this.movingPanelPos.width; } 

            var top = this.movingPanelPos.top + (_evPos.top - this.firstEvPos.top); 
            if (top < 0) {top = 0;} 

            this.movingPanel.style.left = left + 'px';  
            this.movingPanel.style.top  = top  + 'px';  
        }  
    }
}

document.onmouseup = function(){ movePanelManager.DragEnd(); }; 
document.onmousemove = function(event){ movePanelManager.Drag(event); }; 

movePanel = {
    Show : function(panelId, centerPage, times) { 
        var _panel = GetElement(panelId);      
        var _header = GetElement(panelId + 'header'); 

        _header.style.cursor = "move"; 
        _header.onmousedown = function(event){  
             movePanelManager.DragStart(panelId, event);  
        }; 

        this.header = _header; 
        this.panel = _panel; 
        
        lightBox.Show(panelId, centerPage, times);
    },
    
    Hide : function(panelId) { 
        lightBox.Close(panelId);
    } 
}


function changeLanguage(newLang){
    var location = window.document.location.href;
    
    var langStartIndex = location.indexOf('lang');
    if (langStartIndex != -1){
        var langEndIndex = location.indexOf('&', langStartIndex);
        
        langStartIndex--;
        
        if (langEndIndex == -1) langEndIndex = location.length;
        
        location = location.replace(location.substr(langStartIndex, langEndIndex - langStartIndex), '');
    }
    
    location += (location.indexOf('?') == -1 ? '?' : '&');
    
    window.location.href= location + 'lang=' + newLang;
}
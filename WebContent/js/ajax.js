var req;
var which;
var currSpan="";
var objType="";
var conjuntoObj="";

var newDiv = false;
var newSpan= false;

function getTopPos(inputObj)
{
  var returnValue = inputObj.offsetTop + inputObj.offsetHeight;
  while((inputObj = inputObj.offsetParent) != null)returnValue += inputObj.offsetTop;
  return returnValue;
}

function getLeftPos(inputObj)
{
  var returnValue = inputObj.offsetLeft;
  while((inputObj = inputObj.offsetParent) != null)returnValue += inputObj.offsetLeft;
  return returnValue;
}

function criarDiv(obj){
$(document.body).append("<div id=\"divLookup\" class=\"divLookup\" style=\"display:none\"><h1><p>Selecione</p> <img src=\"imagens/fecharColuna.png\" onclick=\"$('div.divLookup').slideUp('slow');\"/> </h1> <div id=\"divLookupBody\" class=\"divLookupBody\"> </div></div>");
newDiv = $('div.divLookup');
newDiv.css('display','block');

//newDiv = document.createElement('DIV');
//newDiv.setAttribute("style","visibility:visible");
//newDiv.setAttribute("className","divLookup");
//newDiv.setAttribute("id","div"+obj);

newSpan = document.createElement('SPAN');
newSpan.id="span"+obj;
//newDiv.appendChild(newSpan);
}

function criarDiv500px(obj){
	$(document.body).append("<div id=\"divLookup\" class=\"divLookup\" style=\"min-width:600px;display:none\"><h1><p>Selecione</p> <img src=\"imagens/fecharColuna.png\" onclick=\"$('div.divLookup').slideUp('slow');\"/> </h1> <div id=\"divLookupBody\" class=\"divLookupBody\"> </div></div>");
	newDiv = $('div.divLookup');
	newDiv.css('display','block');

	//newDiv = document.createElement('DIV');
	//newDiv.setAttribute("style","visibility:visible");
	//newDiv.setAttribute("className","divLookup");
	//newDiv.setAttribute("id","div"+obj);

	newSpan = document.createElement('SPAN');
	newSpan.id="span"+obj;
	//newDiv.appendChild(newSpan);
	}

function getDataLookup(obj, url, div, tipoObj){
    objType = tipoObj;
    if (obj.value.length >= 3 ){
        criarDiv(div);
        obj.disabled=true;
        conjuntoObj = div;
        currSpan = 'span'+div;
        retrieveURL(url);

        var position = $(obj).offset();
        //alert( $(obj).attr('height') );
        //$(newDiv).css(position);
        newDiv.css('top',position.top + obj.offsetHeight);
        newDiv.css('left',position.left);
        obj.disabled=false;
        //newDiv.style.visibility='';
        //newDiv.style.top=getTopPos(obj);
        //newDiv.style.left=getLeftPos(obj);
        //obj.parentNode.insertBefore(newDiv, obj.nextSibling);
    }

}
function getDataLookupBloqueio(obj, url, div, tipoObj){
    objType = tipoObj;
    
    criarDiv(div);
    obj.disabled=true;
    conjuntoObj = div;
    currSpan = 'span'+div;
    retrieveURL(url);

    var position = $(obj).offset();
    newDiv.css('top',position.top + obj.offsetHeight);
    newDiv.css('left',position.left);
    obj.disabled=false;
}
function getDataLookup500px(obj, url, div, tipoObj){
    objType = tipoObj;
    if (obj.value.length >= 3 ){
        criarDiv500px(div);
        obj.disabled=true;
        conjuntoObj = div;
        currSpan = 'span'+div;
        retrieveURL(url);

        var position = $(obj).offset();
        //alert( $(obj).attr('height') );
        //$(newDiv).css(position);
        newDiv.css('top',position.top + obj.offsetHeight);
        newDiv.css('left',position.left);
        obj.disabled=false;
        //newDiv.style.visibility='';
        //newDiv.style.top=getTopPos(obj);
        //newDiv.style.left=getLeftPos(obj);
        //obj.parentNode.insertBefore(newDiv, obj.nextSibling);
    }

}
var metodo;
var objCombo = null;
function preencherCombo(combo, url){
	
	 metodo = null;
    objCombo = combo;
    preencherComboBoxJS(combo, 'Carregando..., |');
    retrieveURL(url);
}

function preencherComboCallback(combo, url, method){
    objCombo = combo;
    metodo = method;
    preencherComboBoxJS(combo, 'Carregando..., |');
    retrieveURL(url);
}

function invocarUrl(url){
    objType = "";
    currSpan = '';
    retrieveURL(url);
}
var tree;

function getAjaxValue(url, metodoCallback){
    tree = true;
    objType = "";
    currSpan = '';
    metodo = metodoCallback;
    retrieveURL(url);
}

function retrieveURL(url) {

    if (window.XMLHttpRequest) { // Non-IE browsers
        req = new XMLHttpRequest();
        req.onreadystatechange = processStateChange;
        try {
            req.open("GET", url, true); //was get
        } catch (e) {
            alert("Problem Communicating with Server\n"+e);
        }
        req.send(null);
    } else if (window.ActiveXObject) { // IE
        req = new ActiveXObject("Microsoft.XMLHTTP");
        if (req) {
            req.onreadystatechange = processStateChange;
            req.open("GET", url, true);
            req.send();
        }
    }
}


function processStateChange() {
    
    if ($('div.divLookupBody') != null)
        $('div.divLookupBody').html(getElementWaiting());
        
    if (req.readyState == 4) {
        if (req.status == 200) {
            if (currSpan!=''){
                $('div.divLookupBody').html(req.responseText);
            }else if (tree!=null){
                metodo(req.responseText);
                //updateTreeCallback(req.responseText);
            }else if (objCombo != null){
                preencherComboBoxJS(objCombo, req.responseText);
                if (metodo!=null)
                	metodo();
                
            }
        } else {
            alert("Erro ao realizar consulta: " + req.statusText);
        }
    }

}

function getElementWaiting(){

    if (objType=="SELECT"){
        if (document.getElementById(getIdElementName()).type=="select-one")
        return '<select id="'+getIdElementName()+'" ><option value="">Carregando...</option></select>';
    }else if (objType=="TABLE"){ 
        return '<ul><li><img src="imagens/loading.gif" class="imagem" ><p>Carregando...</p></li></ul>';
    }
    return "";
}

function getIdElementName(){
    return "select"+conjuntoObj;
    //(currSpan.substring(4,5).toLowerCase()+currSpan.substring(5));
}



function getFormAsString(){
    returnString ="";
    formElements=document.forms[0].elements;
    for ( var i=formElements.length-1; i>=0; --i ){
            returnString=returnString+"&"+escape(formElements[i].name)+"="+escape(formElements[i].value);
    }
    return returnString;
}


function submitFormAjax(metodoComParametros, executaScript) {        
    try{
        xmlhttp = new XMLHttpRequest();
    }catch(ee){ 
        try{
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
        }catch(e) {
            try{
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(E){
                xmlhttp = false;
            }
        }
    }
        
    var endereco = window.location.href;
    endereco = endereco.substr(0,endereco.indexOf("/app")+4)+'/ajax/ajax!';    
    endereco = endereco + metodoComParametros;    
    xmlhttp.open("GET", endereco ,false);
    xmlhttp.send(null);             
    if (executaScript!=null && executaScript)
        eval(xmlhttp.responseText);    
}


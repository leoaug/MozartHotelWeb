window.MozartNS = window.MozartNS || {};

window.MozartNS.Form = window.MozartNS.Form || {}; 
 
window.MozartNS.Form.alternarValorDoFiltro = function(el, targetId, tipo) {
	switch (tipo) {
		case 'D':
		case 'I':
		case 'F':
			if (el.value=='') {
				$('#'+targetId+'1').css('visibility','hidden');
				$('#'+targetId+'2').css('visibility','hidden');
				$('#'+targetId+'1>input').val('');
				$('#'+targetId+'2>input').val('');
			} else if (el.value == '1') {
				$('#'+targetId+'1').css('visibility','visible');
				$('#'+targetId+'2').css('visibility','visible');
			} else {
				$('#'+targetId+'1').css('visibility','visible');
				$('#'+targetId+'2').css('visibility','hidden');
				$('#'+targetId+'2>input').val('');
			}
			break;
			
		default:
			if (el.value=='') {
				$('#'+targetId).css('visibility','hidden');
				$('#'+targetId+'>input').val('');
			} else {
				$('#'+targetId).css('visibility','visible');
			}
	}
};

window.MozartNS.GoogleSuggest = window.MozartNS.GoogleSuggest || {};

window.MozartNS.GoogleSuggest.selecionar = function(elemento, valorTextual, 
		elementoOculto, idEntidade) {
	$('#'+elemento).val(valorTextual);
	$('#'+elementoOculto).val(idEntidade);
	$('div.divLookup').remove();
};

window.MozartNS.GoogleSuggest.isNull = function(obj) {
	if (null == obj)
		return true;
	
	if ('string' == typeof(obj) && 
			('' == obj.trim() ||
			'null' == obj.trim().toLowerCase()))
		return true;
	
	return false;
};
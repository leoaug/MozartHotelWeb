var movePanel = null;

function toFloat(vlString) {
	if (vlString == null || vlString == '')
		return 0.0;
	return parseFloat(vlString.replace(".", "").replace(",", "."));
}

function mascaraTudo(src, mask) {
	src.value = numeros(src.value);
	var i = src.value.length;
	var saida = mask.substring(0, 1);
	var texto = mask.substring(i);
	if (texto.substring(0, 1) != saida) {
		src.value += texto.substring(0, 1);
	}
}

function toUpperCase(obj) {
	obj.value = obj.value.toUpperCase();
}
function toLowerCase(obj) {
	obj.value = obj.value.toLowerCase();
}

function validarEmail(email) {
	if (email.length <= 10 || email.indexOf("@") <= 1
			|| email.indexOf('.') <= 1) {
		return false;
	}
	return true;
}

function validarCPF(cpf) {

	if (cpf.length < 11)
		return false;

	if (cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222"
			|| cpf == "33333333333" || cpf == "44444444444"
			|| cpf == "55555555555" || cpf == "66666666666"
			|| cpf == "77777777777" || cpf == "88888888888"
			|| cpf == "99999999999") {
		return false;
	}
	var a = [];
	var b = new Number;
	var c = 11;
	for (i = 0; i < 11; i++) {
		a[i] = cpf.charAt(i);
		if (i < 9)
			b += (a[i] * --c);
	}
	if ((x = b % 11) < 2) {
		a[9] = 0
	} else {
		a[9] = 11 - x
	}
	b = 0;
	c = 11;
	for (y = 0; y < 10; y++)
		b += (a[y] * c--);
	if ((x = b % 11) < 2) {
		a[10] = 0;
	} else {
		a[10] = 11 - x;
	}
	if ((cpf.charAt(9) != a[9]) || (cpf.charAt(10) != a[10])) {
		return false;
	}

	return true;
}

function validarCNPJ(cnpj) {
	// Declaração as variáveis
	var numeros, digitos, soma, i, resultado, pos, tamanho, digitos_iguais;
	// Verificando se o campo é nulo
	if (cnpj.length == 0) {
		return false;
	}
	// Ultilização expressão regular para retirar o que não for número
	cnpj = cnpj.replace(/\D+/g, '');
	digitos_iguais = 1;

	for (i = 0; i < cnpj.length - 1; i++)
		if (cnpj.charAt(i) != cnpj.charAt(i + 1)) {
			digitos_iguais = 0;
			break;
		}

	if (!digitos_iguais) {
		tamanho = cnpj.length - 2
		numeros = cnpj.substring(0, tamanho);
		digitos = cnpj.substring(tamanho);
		soma = 0;
		pos = tamanho - 7;
		for (i = tamanho; i >= 1; i--) {
			soma += numeros.charAt(tamanho - i) * pos--;
			if (pos < 2)
				pos = 9;
		}
		resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
		if (resultado != digitos.charAt(0)) {
			return false;
		}
		tamanho = tamanho + 1;
		numeros = cnpj.substring(0, tamanho);
		soma = 0;
		pos = tamanho - 7;
		for (i = tamanho; i >= 1; i--) {
			soma += numeros.charAt(tamanho - i) * pos--;
			if (pos < 2)
				pos = 9;
		}

		resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
		if (resultado != digitos.charAt(1)) {
			return false;
		}
		return true;
	} else {
		return false;
	}

}

function mascara(o, f) {
	v_obj = o;
	v_fun = f;
	setTimeout("execmascara()", 1);
}

function execmascara() {
	v_obj.value = v_fun(v_obj.value);
}

function numeros(v) {
	return v.replace(/\D/g, "");
}
function moeda(v) {
	pre = '';
	if (v.indexOf('-') == 0)
		pre = '-';

	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{1,3})(\d{2})$/, "$1,$2");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{2})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{2})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\.(\d{3})\,(\d{2})$/, "$1.$2.$3,$4");
	v = v.replace(/(\d{1,3})(\d{3})\.(\d{3})\.(\d{3})\,(\d{2})$/,
			"$1.$2.$3.$4,$5");
	return pre + v;
}

function moeda4Decimais(v) {
	pre = '';
	if (v.indexOf('-') == 0)
		pre = '-';

	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{1,3})(\d{4})$/, "$1,$2");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{4})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{4})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\.(\d{3})\,(\d{4})$/, "$1.$2.$3,$4");
	v = v.replace(/(\d{1,3})(\d{3})\.(\d{3})\.(\d{3})\,(\d{4})$/,
			"$1.$2.$3.$4,$5");
	return pre + v;
}

function moedaDecimal(v) {
	pre = '';
	if (v.indexOf('-') == 0)
		pre = '-';

	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{1,3})(\d{3})$/, "$1,$2");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{3})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{3})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\.(\d{3})\,(\d{3})$/, "$1.$2.$3,$4");
	return pre + v;
}

function quantidadeDecimal(v) {
	pre = '';
	if (v.indexOf('-') == 0)
		pre = '-';

	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{1,3})(\d{4})$/, "$1,$2");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{4})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\,(\d{4})$/, "$1.$2,$3");
	v = v.replace(/(\d{1,3})(\d{3})\.(\d{3})\,(\d{4})$/, "$1.$2.$3,$4");
	return pre + v;
}

function telefone(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/^(\d\d)(\d)/g, "($1) $2");
	v = v.replace(/(\d{4})(\d)/, "$1-$2");
	return v;
}

function celular(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/^(\d\d)(\d)/g, "($1) $2");
	v = v.replace(/(\d{5})(\d)/, "$1-$2");
	return v;
}

function validadeCartao(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{2})(\d)/, "$1/$2");
	return v;
}

function cpf(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{3})(\d)/, "$1.$2");
	v = v.replace(/(\d{3})(\d)/, "$1.$2");
	v = v.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
	return v;
}

function cep(v) {
	v = v.replace(/D/g, "");
	v = v.replace(/^(\d{5})(\d)/, "$1-$2");
	return v;
}

function cnpj(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/^(\d{2})(\d)/, "$1.$2");
	v = v.replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3");
	v = v.replace(/\.(\d{3})(\d)/, ".$1/$2");
	v = v.replace(/(\d{4})(\d)/, "$1-$2");
	return v;
}

function site(v) {
	v = v.replace(/^http:\/\/?/, "");
	dominio = v;
	caminho = "";
	if (v.indexOf("/") > -1)
		dominio = v.split("/")[0];
	caminho = v.replace(/[^\/]*/, "");
	dominio = dominio.replace(/[^\w\.\+-:@]/g, "");
	caminho = caminho.replace(/[^\w\d\+-@:\?&=%\(\)\.]/g, "");
	caminho = caminho.replace(/([\?&])=/, "$1");
	if (caminho != "")
		dominio = dominio.replace(/\.+$/, "");
	v = "https://" + dominio + caminho;
	return v;
}

function data(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{2})(\d)/, "$1/$2");
	v = v.replace(/(\d{2})(\d)/, "$1/$2");
	return v;
}

function mesano(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{2})(\d)/, "$1/$2");
	return v;
}

function hora(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{2})(\d)/, "$1:$2");
	return v;
}
function hms(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{2})(\d)/, "$1:$2");
	v = v.replace(/(\d{2})(\d)/, "$1:$2");
	return v;
}

function contaContabil(v) {
	v = v.replace(/\D/g, "");
	v = v.replace(/(\d{1})(\d)/, "$1.$2");
	v = v.replace(/(\d{1})(\d)/, "$1.$2");
	v = v.replace(/(\d{1})(\d)/, "$1.$2");
	v = v.replace(/(\d{2})(\d)/, "$1.$2");
	return v;
}

function dataValida(obj) {

	if ((obj.value != '') && (!isDate(obj))) {
		alerta('Data inválida!');
		obj.value = '';
		obj.focus();
	}
}


// Fun??o para valida??o de data
function isDate(obj) {
	return true;
	var objd, strd, typd;
	var fr = 1;
	obj.value = Trim(obj.value);
	var valor = obj.value;
	if (obj.maxLength == 7) {
		valor = '01/' + obj.value;
	}

	objd = cDate(valor, 'date');
	strd = cDate(valor, 'string');
	typd = cDate(valor, 'type');
	if ((isNaN(objd)) || (objd == null))
		fr = 0;
	if (strd == null)
		fr = 0;
	if (typd == null)
		fr = 0;
	if (fr) {
		if (objd.getYear() < 1000) {
			if (typd == 'shortdate') {
				if ((objd.getDate() + '/' + (objd.getMonth() + 1) + '/' + (objd
						.getYear() + 1900)) != strd)
					fr = 0;
			} else {
				if ((objd.getDate() + '/' + (objd.getMonth() + 1) + '/'
						+ (objd.getYear() + 1900) + ' ' + objd.getHours() + ':'
						+ objd.getMinutes() + ':' + objd.getSeconds()) != strd)
					fr = 0;
			}
		} else {
			if (typd == 'shortdate') {
				if ((objd.getDate() + '/' + (objd.getMonth() + 1) + '/' + objd
						.getYear()) != strd)
					fr = 0;
			} else {
				if ((objd.getDate() + '/' + (objd.getMonth() + 1) + '/'
						+ objd.getYear() + ' ' + objd.getHours() + ':'
						+ objd.getMinutes() + ':' + objd.getSeconds()) != strd)
					fr = 0;
			}
		}
	}
	return fr;
}

// Fun??o para converter para data
function cDate(value, typ) {
	var objd, art, arh, strd;
	var fr = 1;
	var ard = value.split("/");
	if (ard.length == 3) {
		if (isNaN(ard[0]) || (ard[0].length > 2) || (ard[0] > 31)
				|| (ard[0] < 1))
			fr = 0;
		if (isNaN(ard[1]) || (ard[1].length > 2) || (ard[1] > 12)
				|| (ard[1] < 1))
			fr = 0;
		if (ard[2].length <= 4) {
			if ((isNaN(ard[2])) || (ard[2] < 0))
				fr = 0;
			objd = new Date(parseInt(ard[2], 10), parseInt(ard[1], 10) - 1,
					parseInt(ard[0], 10));
			strd = (parseInt(ard[0], 10) + "/" + parseInt(ard[1], 10) + "/" + parseInt(
					ard[2], 10));
		} else {
			art = ard[2].split(' ');
			if ((isNaN(art[0])) || (art[0].length != 4) || (art[0] < 0))
				fr = 0;
			arh = art[1].split(':');
			if ((isNaN(arh[0])) || (arh[0].length > 2) || (arh[0] > 23)
					|| (arh[0] < 0))
				fr = 0;
			if ((isNaN(arh[1])) || (arh[1].length > 2) || (arh[1] > 59)
					|| (arh[1] < 0))
				fr = 0;
			if (arh.length >= 3) {
				if (arh.length > 3)
					fr = 0;
				if ((isNaN(arh[2])) || (arh[2].length > 2) || (arh[2] > 59)
						|| (arh[2] < 0))
					fr = 0;
				objd = new Date(parseInt(art[0], 10), parseInt(ard[1], 10) - 1,
						parseInt(ard[0], 10), parseInt(arh[0], 10), parseInt(
								arh[1], 10), parseInt(arh[2], 10));
				strd = (parseInt(ard[0], 10) + "/" + parseInt(ard[1], 10) + "/"
						+ parseInt(art[0], 10) + " " + parseInt(arh[0], 10)
						+ ":" + parseInt(arh[1], 10) + ":" + parseInt(arh[2],
						10));
			} else {
				objd = new Date(parseInt(art[0], 10), parseInt(ard[1], 10) - 1,
						parseInt(ard[0], 10), parseInt(arh[0], 10), parseInt(
								arh[1], 10), 0);
				strd = (parseInt(ard[0], 10) + "/" + parseInt(ard[1], 10) + "/"
						+ parseInt(art[0], 10) + " " + parseInt(arh[0], 10)
						+ ":" + parseInt(arh[1], 10) + ":0");
			}
		}
	} else {
		fr = 0;
	}
	if (fr) {
		switch (typ) {
		case "date":
			return objd;
			break;
		case "string":
			return strd;
			break;
		case "type":
			if (ard[2].length == 4) {
				return 'shortdate';
			} else {
				return 'longdate';
			}
			;
			break;
		}
	} else {
		return null;
	}
}

function arredondaFloat(num) {
	x = 0;
	if (num < 0) {
		num = Math.abs(num);
		x = 1;
	}
	if (isNaN(num))
		num = "0";
	cents = Math.floor((num * 100 + 0.5) % 100);

	num = Math.floor((num * 100 + 0.5) / 100).toString();

	if (cents < 10)
		cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
		num = num.substring(0, num.length - (4 * i + 3)) + '.'
				+ num.substring(num.length - (4 * i + 3));

	ret = num + ',' + cents;
	if (x == 1)
		ret = ' - ' + ret;

	ret = ret.replace('.', '').replace(',', '.');

	return ret;

}

function arredondaFloatDecimal(num) {
	x = 0;
	if (num < 0) {
		num = Math.abs(num);
		x = 1;
	}
	if (isNaN(num))
		num = "0";
	cents = Math.floor((num * 1000 + 0.5) % 1000);

	num = Math.floor((num * 1000 + 0.5) / 1000).toString();

	if (cents < 10)
		cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
		num = num.substring(0, num.length - (4 * i + 3)) + '.'
				+ num.substring(num.length - (4 * i + 3));

	ret = num + ',' + cents;
	if (x == 1)
		ret = ' - ' + ret;

	ret = ret.replace('.', '').replace(',', '.');

	return ret;

}

function arredondaFloat4Decimais(num) {
	x = 0;
	if (num < 0) {
		num = Math.abs(num);
		x = 1;
	}
	if (isNaN(num))
		num = "0";
	cents = Math.floor((num * 10000 + 0.5) % 10000);

	num = Math.floor((num * 10000 + 0.5) / 10000).toString();

	if (cents < 10)
		cents = "000" + cents;
	else if (cents < 100)
		cents = "00" + cents;
	else if (cents < 1000)
		cents = "0" + cents;
	
	for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
		num = num.substring(0, num.length - (4 * i + 3)) + '.'
				+ num.substring(num.length - (4 * i + 3));

	ret = num + ',' + cents;
	if (x == 1)
		ret = ' - ' + ret;

	ret = ret.replace('.', '').replace(',', '.');

	return ret;

}

function setarValorJS(idCampo, valor) {
	if (valor != null && valor != 'null'
			&& document.getElementById(idCampo) != null)
		document.getElementById(idCampo).value = valor;
}

function preencherComboBoxJS(id, valores) {

	objSelect = document.getElementById(id);
	if (objSelect != null)
		objSelect.options.length = 0;

	if (valores != null && valores != '' && objSelect != null) {
		opts = valores.split('|');
		objSelect.options.length = opts.length;
		for (i = 0; i < opts.length; i++) {
			arr = opts[i].split(',');
			
			op = new Option(Trim(arr[0]), Trim(arr[1]));
			objSelect.options[i] = op;
			
			if(arr.length == 3){
				atribs = arr[2].split(':');
				for (j = 0; j< atribs.length; j++) {
					attrib = atribs[j].split('=');
					op.setAttribute(attrib[0],attrib[1]);
				}
			}
			
		}

	}
}

function selecionarValorCombo(idCombo, valor) {
	for (i = 0; i < document.getElementById(idCombo).length; i++) {
		if (document.getElementById(idCombo).options[i].value == valor)
			document.getElementById(idCombo).selectedIndex = i;
	}
}

function pegaDiferencaDiasDatas(valorData1, valorData2) {

	var dataEntrada = new Date(valorData2.split('/')[2], parseInt(valorData2
			.split('/')[1], 10) - 1, valorData2.split('/')[0]);

	var dataSaida = new Date(valorData1.split('/')[2], parseInt(valorData1
			.split('/')[1], 10) - 1, valorData1.split('/')[0]);

	dias = (dataSaida - dataEntrada) / (1000 * 60 * 60 * 24);
	if (valorData1 != '' && valorData2 != '')
		return dias;
	else
		return null;
}

function incrementarData(date, numDias) {

	return date;
}

function formatDate(date, format) {
	var m = date.getMonth();
	var d = date.getDate();
	var y = date.getFullYear();
	var wn = date.getWeekNumber();
	var w = date.getDay();
	var s = {};
	var hr = date.getHours();
	var pm = (hr >= 12);
	var ir = (pm) ? (hr - 12) : hr;
	var dy = date.getDayOfYear();
	if (ir == 0) {
		ir = 12;
	}
	var min = date.getMinutes();
	var sec = date.getSeconds();
	var parts = format.split(''), part;
	for (var i = 0; i < parts.length; i++) {
		part = parts[i];
		switch (parts[i]) {
		case 'a':
			part = date.getDayName();
			break;
		case 'A':
			part = date.getDayName(true);
			break;
		case 'b':
			part = date.getMonthName();
			break;
		case 'B':
			part = date.getMonthName(true);
			break;
		case 'C':
			part = 1 + Math.floor(y / 100);
			break;
		case 'd':
			part = (d < 10) ? ("0" + d) : d;
			break;
		case 'e':
			part = d;
			break;
		case 'H':
			part = (hr < 10) ? ("0" + hr) : hr;
			break;
		case 'I':
			part = (ir < 10) ? ("0" + ir) : ir;
			break;
		case 'j':
			part = (dy < 100) ? ((dy < 10) ? ("00" + dy) : ("0" + dy)) : dy;
			break;
		case 'k':
			part = hr;
			break;
		case 'l':
			part = ir;
			break;
		case 'm':
			part = (m < 9) ? ("0" + (1 + m)) : (1 + m);
			break;
		case 'M':
			part = (min < 10) ? ("0" + min) : min;
			break;
		case 'p':
		case 'P':
			part = pm ? "PM" : "AM";
			break;
		case 's':
			part = Math.floor(date.getTime() / 1000);
			break;
		case 'S':
			part = (sec < 10) ? ("0" + sec) : sec;
			break;
		case 'u':
			part = w + 1;
			break;
		case 'w':
			part = w;
			break;
		case 'y':
			part = ('' + y).substr(2, 2);
			break;
		case 'Y':
			part = y;
			break;
		}
		parts[i] = part;
	}
	return parts.join('');
}

//Função para retirar os espaços em branco do início e do fim da string.
function Trim(strTexto)
    {
        // Substitúi os espaços vazios no inicio e no fim da string por vazio.
        return (strTexto == null || strTexto == '') ? '' : strTexto.trim();
    }

// Função para validação de CEP.
function validaCep(cep, obrigatorio) {
    var regex = /^[0-9]{5}-[0-9]{3}$/;
    
    // TODO: (ID) Definir se o padrão deve ser obrigatório ou opcional
    if (window.MozartNS.GoogleSuggest.isNull(obrigatorio))
    	obrigatorio = true;

    cep = Trim(cep);
    
    if (cep.length > 0) {
        if(regex.test(cep)) {
        	return true;
        } else return false;
    } else return !obrigatorio;
}
//-->
package com.mozart.web.actions.marketing;

import java.util.List;

import com.mozart.model.delegate.MarketingDelegate;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.MarketingPorEmpresaVO;
import com.mozart.web.actions.BaseAction;

public class MarketingAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6885329710110152910L;
	private MarketingPorEmpresaVO filtro;
	

	
	public String prepararRelatorioPorEmpresa(){
		return SUCESSO_FORWARD;
	}
	
	public String prepararPorEmpresa(){
		
		request.setAttribute("filtro.filtroPeriodo.tipoIntervalo", "1");
		request.setAttribute("filtro.filtroPeriodo.valorInicial", MozartUtil.format(MozartUtil.incrementarDia(getControlaData().getFrontOffice(),-30), MozartUtil.FMT_DATE));
		request.setAttribute("filtro.filtroPeriodo.valorFinal", MozartUtil.format(getControlaData().getFrontOffice(), MozartUtil.FMT_DATE));
		request.getSession().removeAttribute("listaPesquisaReserva");
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	
	public String prepararOutros(){
		
		
		
		
		
		return SUCESSO_FORWARD;
		
	}

	
	public String pesquisarPorEmpresa(){
		
		try{
			
			filtro.setIdHoteis( getIdHoteis() );
			List<MarketingPorEmpresaVO> lista = MarketingDelegate.instance().pesquisarReservasPorEmpreasa(filtro);
			if(MozartUtil.isNull(lista)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute("listaPesquisa", lista);
			
		}catch(MozartValidateException ex){
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}


	public MarketingPorEmpresaVO getFiltro() {
		return filtro;
	}


	public void setFiltro(MarketingPorEmpresaVO filtro) {
		this.filtro = filtro;
	} 

}

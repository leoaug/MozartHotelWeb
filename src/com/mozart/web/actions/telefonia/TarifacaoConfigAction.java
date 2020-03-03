package com.mozart.web.actions.telefonia;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.TelefoniaDelegate;
import com.mozart.model.ejb.entity.TelefoniasConfigEJB;
import com.mozart.model.ejb.entity.TelefoniaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.exception.MozartSessionException;

import com.mozart.web.actions.BaseAction;

public class TarifacaoConfigAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = -75928571429384561L;
	
	private TelefoniasConfigEJB entidade;

	private List<TelefoniaEJB> telefoniaList;
	
	private List<TipoLancamentoEJB> tipoLancamentoList;
	
	
	public TarifacaoConfigAction(){
		entidade = new TelefoniasConfigEJB();
		telefoniaList = Collections.emptyList();
		tipoLancamentoList = Collections.emptyList();
	}
	
	public String prepararManterTarifacao(){
		try{
			initCombo();
			TelefoniasConfigEJB filtro = new TelefoniasConfigEJB();
			filtro.setIdHotel( getIdHoteis()[0]);
			entidade = TelefoniaDelegate.instance().obterTelefoniasConfigPorHotel( filtro );
			
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}
	
	private void initCombo() throws MozartSessionException{
		telefoniaList = TelefoniaDelegate.instance().obterCentralTelefonia();
		TipoLancamentoEJB pFiltro = new TipoLancamentoEJB();
		pFiltro.setIdHotel( getIdHoteis()[0]);
		pFiltro.getIdentificaLancamento().setIdIdentificaLancamento( new Long (7) );
		pFiltro.setDebitoCredito("D");
		tipoLancamentoList = CheckinDelegate.instance().pesquisarTipoLancamentoByFiltro(pFiltro);
	}

	
	public String gravarTarifacaoConfig(){
		try{
			initCombo();
			
			if (entidade.getTipoLancamentoInternet() != null && entidade.getTipoLancamentoInternet().getIdTipoLancamento() !=null){
				entidade.setTipoLancamentoInternet(tipoLancamentoList.get( tipoLancamentoList.indexOf(entidade.getTipoLancamentoInternet())));
			}else{
				entidade.setTipoLancamentoInternet(null);
			}

			if (entidade.getTipoLancamentoTelefonia() != null && entidade.getTipoLancamentoTelefonia().getIdTipoLancamento() !=null){
				entidade.setTipoLancamentoTelefonia(tipoLancamentoList.get( tipoLancamentoList.indexOf(entidade.getTipoLancamentoTelefonia())));
			}else{
				entidade.setTipoLancamentoTelefonia(null);
			}
			
			
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if (entidade.getIdTelefoniasConfig() == null){
				entidade = (TelefoniasConfigEJB)CheckinDelegate.instance().incluir( entidade );
			}else{
				entidade = (TelefoniasConfigEJB)CheckinDelegate.instance().alterar( entidade );
			}
			
			getHotelCorrente().setTelefoniasConfigEJB( entidade );
			addMensagemSucesso(MSG_SUCESSO);
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}
	
	
	
	public String cancelar(){
		
		return PESQUISA_FORWARD;
	}
	
	public TelefoniasConfigEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TelefoniasConfigEJB entidade) {
		this.entidade = entidade;
	}

	public List<TelefoniaEJB> getTelefoniaList() {
		return telefoniaList;
	}

	public void setTelefoniaList(List<TelefoniaEJB> telefoniaList) {
		this.telefoniaList = telefoniaList;
	}

	public List<TipoLancamentoEJB> getTipoLancamentoList() {
		return tipoLancamentoList;
	}

	public void setTipoLancamentoList(List<TipoLancamentoEJB> tipoLancamentoList) {
		this.tipoLancamentoList = tipoLancamentoList;
	}
	
}

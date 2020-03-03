package com.mozart.web.actions.operacional;

import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.CamareiraEJB;
import com.mozart.model.ejb.entity.TipoApartamentoEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApartamentoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class ApartamentoAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8373750652766400998L;
	private ApartamentoVO filtro;
	private ApartamentoEJB apto;
	private List<MozartComboWeb> statusList;
	
	
	public ApartamentoAction(){
		filtro = new ApartamentoVO();
		apto = new ApartamentoEJB();
		
		statusList = new ArrayList<MozartComboWeb>();
		statusList.add( new MozartComboWeb("IN","Interditado"));
		statusList.add( new MozartComboWeb("LA","Livre/Arrumado"));
		statusList.add( new MozartComboWeb("LL","Livre/Limpo"));
		statusList.add( new MozartComboWeb("LS","Livre/Sujo"));
		statusList.add( new MozartComboWeb("OA","Ocupado/Arrumado"));
		statusList.add( new MozartComboWeb("OS","Ocupado/Sujo"));
		
	}
	
	
	public String prepararAlteracao(){
		
		warn("Preparando Alteracao do apartamento");
		try{
			
			CamareiraEJB filtro = new CamareiraEJB();
			filtro.setIdHotel( getIdHoteis()[0] );
			
			List<CamareiraEJB> camareiraList = OperacionalDelegate.instance().pesquisaCamareira(filtro);
			request.getSession().setAttribute("camareiraList", camareiraList);
			
			TipoApartamentoEJB pTipoApartamentoEJB = new TipoApartamentoEJB();
			pTipoApartamentoEJB.setIdHotel( getIdHoteis()[0] );
			
			List<TipoApartamentoEJB> tipoApartamentoList = CheckinDelegate.instance().obterTipoApartamento(pTipoApartamentoEJB);
			request.getSession().setAttribute("tipoApartamentoList", tipoApartamentoList);
			
			apto =(ApartamentoEJB) CheckinDelegate.instance().obter(ApartamentoEJB.class, apto.getIdApartamento());
			
			
		
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	public String prepararInclusao(){
		warn("Preparando manter do apartamento");
		try{
			apto = new ApartamentoEJB();
			apto.setCofan("N");
			apto.setCheckout("N");
			apto.setStatus("LL");
			CamareiraEJB filtro = new CamareiraEJB();
			filtro.setIdHotel( getIdHoteis()[0] );
			
			List<CamareiraEJB> camareiraList = OperacionalDelegate.instance().pesquisaCamareira(filtro);
			request.getSession().setAttribute("camareiraList", camareiraList);
			
			TipoApartamentoEJB pTipoApartamentoEJB = new TipoApartamentoEJB();
			pTipoApartamentoEJB.setIdHotel( getIdHoteis()[0] );
			
			List<TipoApartamentoEJB> tipoApartamentoList = CheckinDelegate.instance().obterTipoApartamento(pTipoApartamentoEJB);
			request.getSession().setAttribute("tipoApartamentoList", tipoApartamentoList);
			
		
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
	}
	
	
	public String gravarApartamento(){
		warn("Gravando o apartamento");
		try{   


			apto.setIdHotel( getIdHoteis()[0] );
			apto.setDepositoAntecipado("N");
			apto.setUsuario( getUserSession().getUsuarioEJB() );
			apto = OperacionalDelegate.instance().gravarApartamento(apto);
			addMensagemSucesso( MSG_SUCESSO );
			return prepararInclusao();
			
		}catch(MozartValidateException ex){	
			addMensagemSucesso( ex.getMessage() );

		}catch(Exception exc){
            error( exc.getMessage() );
            addMensagemErro(MSG_ERRO);
        }
		return SUCESSO_FORWARD;
	}
	
	public String prepararPesquisa(){
		warn("Preparando a pesquisa do apartamento");
		request.getSession().removeAttribute(LISTA_PESQUISA);
		request.getSession().removeAttribute("camareiraList");
		request.getSession().removeAttribute("tipoApartamentoList");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		warn("Pesquisando do apartamento");
		try{   
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<ApartamentoEJB> listaPesquisa = OperacionalDelegate.instance().pesquisarApartamento(filtro); 
			if (MozartUtil.isNull( listaPesquisa )){
	                addMensagemSucesso("Nenhum resultado encontrado.");
	        }
			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
		}catch(Exception exc){
            error( exc.getMessage() );
            addMensagemErro(MSG_ERRO);
        }
		return SUCESSO_FORWARD;
	}


	public ApartamentoVO getFiltro() {
		return filtro;
	}


	public void setFiltro(ApartamentoVO filtro) {
		this.filtro = filtro;
	}


	public ApartamentoEJB getApto() {
		return apto;
	}


	public void setApto(ApartamentoEJB apto) {
		this.apto = apto;
	}


	public List<MozartComboWeb> getStatusList() {
		return statusList;
	}


	public void setStatusList(List<MozartComboWeb> statusList) {
		this.statusList = statusList;
	}
	
	
	

}

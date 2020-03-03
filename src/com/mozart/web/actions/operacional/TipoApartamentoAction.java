package com.mozart.web.actions.operacional;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.TipoApartamentoEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.TipoApartamentoVO;
import com.mozart.web.actions.BaseAction;

@SuppressWarnings("serial")
public class TipoApartamentoAction extends BaseAction {
	
	private TipoApartamentoVO filtro;
	private TipoApartamentoEJB entidade;
	
	
	public TipoApartamentoAction(){
		filtro = new TipoApartamentoVO();
		entidade = new TipoApartamentoEJB();
	}
	
	
	public String prepararAlteracao(){
		
		warn("Preparando Alteracao do TipoApartamento");
		try{
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade = OperacionalDelegate.instance().obterTipoApartamento(entidade);
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	public String prepararInclusao(){
		warn("Preparando manter do TipoApartamento");
		entidade = new TipoApartamentoEJB();
		return SUCESSO_FORWARD;
	}
	
	
	public String gravarTipoApartamento(){
		warn("Gravando o TipoApartamento");
		try{   

			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if (entidade.getIdTipoApartamento() == null){
				entidade = (TipoApartamentoEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (TipoApartamentoEJB)CheckinDelegate.instance().alterar(entidade);
			}
			
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
		warn("Preparando a pesquisa do tipoApartamento");
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		warn("Pesquisando TipoApartamento");
		try{   
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<TipoApartamentoVO> listaPesquisa = OperacionalDelegate.instance().pesquisarTipoApartamento(filtro); 
			if (MozartUtil.isNull( listaPesquisa )){
	                addMensagemSucesso(MSG_PESQUISA_VAZIA);
	        }
			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
		}catch(Exception exc){
            error( exc.getMessage() );
            addMensagemErro(MSG_ERRO);
        }
		return SUCESSO_FORWARD;
	}


	public TipoApartamentoVO getFiltro() {
		return filtro;
	}


	public void setFiltro(TipoApartamentoVO filtro) {
		this.filtro = filtro;
	}


	public TipoApartamentoEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(TipoApartamentoEJB entidade) {
		this.entidade = entidade;
	}

	

}

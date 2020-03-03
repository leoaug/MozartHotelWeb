package com.mozart.web.actions.operacional;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.ObjetoEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ObjetoVO;
import com.mozart.web.actions.BaseAction;

public class ObjetoAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7002945953752231642L;

	private ObjetoVO filtro;
	private ObjetoEJB entidade;
	
	
	public ObjetoAction(){
		filtro = new ObjetoVO();
		entidade = new ObjetoEJB();
	}
	
	
	public String prepararAlteracao(){
		
		warn("Preparando Alteracao do objeto");
		try{
			
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade = (ObjetoEJB)CheckinDelegate.instance().obter(ObjetoEJB.class, entidade.getIdObjeto());
			
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	public String prepararInclusao(){
		warn("Preparando manter objeto");
		entidade = new ObjetoEJB();
		return SUCESSO_FORWARD;
	}
	
	
	public String gravar(){
		warn("Gravando o objeto");
		try{   
			
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if (entidade.getIdObjeto() == null){
				entidade = (ObjetoEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (ObjetoEJB)CheckinDelegate.instance().alterar(entidade);
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
		warn("Preparando a pesquisa do objeto");
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		warn("Pesquisando objeto");
		try{   
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<ObjetoVO> listaPesquisa = OperacionalDelegate.instance().pesquisarObjeto(filtro); 
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


	public ObjetoVO getFiltro() {
		return filtro;
	}


	public void setFiltro(ObjetoVO filtro) {
		this.filtro = filtro;
	}


	public ObjetoEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(ObjetoEJB entidade) {
		this.entidade = entidade;
	}

	
}

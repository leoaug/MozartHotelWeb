package com.mozart.web.actions.sistema;

import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.MensagemWebUsuarioVO;
import com.mozart.web.actions.BaseAction;
import java.util.List;

public class MensagemWebUsuarioAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private MensagemWebUsuarioVO filtro;
	
	
	public MensagemWebUsuarioAction (){
		
		filtro = new MensagemWebUsuarioVO();
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		
		try{
			filtro.setIdUsuario(getUserSession().getUsuarioEJB().getIdUsuario());
			List<MensagemWebUsuarioVO> lista = SistemaDelegate.instance().pesquisarMensagemWebUsuario(filtro);
			if (MozartUtil.isNull(lista)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public MensagemWebUsuarioVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MensagemWebUsuarioVO filtro) {
		this.filtro = filtro;
	}
}
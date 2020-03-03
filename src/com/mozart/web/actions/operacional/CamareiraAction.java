package com.mozart.web.actions.operacional;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.CamareiraEJB;
import com.mozart.model.ejb.entity.GarconEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CamareiraVO;
import com.mozart.web.actions.BaseAction;

public class CamareiraAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8373750652766400998L;
	private CamareiraVO filtro;
	private CamareiraEJB entidade;
	private long idUsuario;
	
	public CamareiraAction(){
		filtro = new CamareiraVO();
		entidade = new CamareiraEJB();
	}
	
	
	public String prepararAlteracao(){
		
		warn("Preparando Alteracao da camareira");
		try{
			
			GarconEJB filtroGarcon = new GarconEJB();
			filtroGarcon.setIdHotel(getIdHoteis()[0]);
			
			List<GarconEJB> usuarioList = OperacionalDelegate.instance().obterGarcon( filtroGarcon );
			
			request.getSession().setAttribute("usuarioList", usuarioList);
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade = OperacionalDelegate.instance().obterCamareira(entidade);
			
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	public String prepararInclusao(){
		warn("Preparando manter do camareira");
		try{
			entidade = new CamareiraEJB();
		
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
	}
	
	
	public String gravarCamareira(){
		warn("Gravando a camareira");
		try{   
			
			entidade.setIdHotel( getIdHoteis()[0] );
			UsuarioEJB usuario = (UsuarioEJB)CheckinDelegate.instance().obter(UsuarioEJB.class, idUsuario);
			entidade.setUsuario( usuario );
			entidade.setIdUsuario(idUsuario);
			
			if (entidade.getIdCamareira() == null){
				entidade = (CamareiraEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (CamareiraEJB)CheckinDelegate.instance().alterar(entidade);
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
		warn("Preparando a pesquisa da camareira");
		request.getSession().removeAttribute("listaPesquisa");
		request.getSession().removeAttribute("usuarioList");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		warn("Pesquisando camareira");
		try{   
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<CamareiraVO> listaPesquisa = OperacionalDelegate.instance().pesquisarCamareira(filtro); 
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


	public CamareiraVO getFiltro() {
		return filtro;
	}


	public void setFiltro(CamareiraVO filtro) {
		this.filtro = filtro;
	}


	public CamareiraEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(CamareiraEJB entidade) {
		this.entidade = entidade;
	}


	public long getIdUsuario() {
		return idUsuario;
	}


	public void setIdUsuario(long idUsuario) {
		this.idUsuario = idUsuario;
	}
	
	

}

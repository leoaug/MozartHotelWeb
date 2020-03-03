package com.mozart.web.actions.rede;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.EmpresaRedeEJB;
import com.mozart.model.ejb.entity.EmpresaRedeEJBPK;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CreditoEmpresaVO;
import com.mozart.model.vo.LogUsuarioVO;
import com.mozart.web.actions.BaseAction;

public class CreditoEmpresaAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1974198086069167151L;

	
	private CreditoEmpresaVO filtro;
	private EmpresaRedeEJB entidade;
	
	
	public CreditoEmpresaAction(){
		filtro = new CreditoEmpresaVO();
		//apto = new ApartamentoEJB();
	}
	
	
	public String prepararAlteracao(){
		
		warn("Preparando Alteracao do apartamento");
		try{
			if (entidade == null || entidade.getEmpresaEJB() == null || entidade.getEmpresaEJB().getIdEmpresa() == null){
				addMensagemErro("Nenhuma empresa selecionada");
				return ERRO_FORWARD;
			}
			EmpresaRedeEJBPK pk = new EmpresaRedeEJBPK();
			pk.idEmpresa = entidade.getEmpresaEJB().getIdEmpresa();
			pk.idRedeHotel = getHotelCorrente().getRedeHotelEJB().getIdRedeHotel();
			entidade = (EmpresaRedeEJB)CheckinDelegate.instance().obter(EmpresaRedeEJB.class, pk);
			
			LogUsuarioVO ultimoLog = new LogUsuarioVO();
			
			ultimoLog.setIdAuditado(pk.idEmpresa);
			ultimoLog.setTabelaAuditada("EMPRESA");
			ultimoLog.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			
			ultimoLog = RedeDelegate.instance().obterUltimoLog( ultimoLog );
			
			
			request.getSession().setAttribute("logAlteracao", ultimoLog);
			request.getSession().setAttribute("ENTIDADE_SESSION", entidade);
			
		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MENSAGEM_ERRO );
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravar(){
		warn("Gravando o apartamento");
		try{   
			
			EmpresaRedeEJB entidadeSession = (EmpresaRedeEJB)request.getSession().getAttribute("ENTIDADE_SESSION");
			entidadeSession.setCredito( entidade.getCredito() );
			entidadeSession.setValorCredito( entidade.getValorCredito() );
			entidadeSession.setUsuario( getUserSession().getUsuarioEJB() );
			entidadeSession.setObservacao( entidade.getObservacao() );
			CheckinDelegate.instance().alterar(entidadeSession);
			addMensagemSucesso( MSG_SUCESSO );
			prepararPesquisa();
			return ERRO_FORWARD;
			
		}catch(Exception exc){
            error( exc.getMessage() );
            addMensagemErro(MSG_ERRO);
        }
		return SUCESSO_FORWARD;
	}
	
	public String prepararPesquisa(){
		warn("Preparando a pesquisa do crédito da empresa");
		request.getSession().removeAttribute("listaPesquisa");
		request.getSession().removeAttribute("ENTIDADE_SESSION");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		warn("Pesquisando do credito empresa");
		try{
			prepararPesquisa();
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<CreditoEmpresaVO> listaPesquisa = RedeDelegate.instance().pesquisarCreditoEmpresa(filtro); 
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


	public CreditoEmpresaVO getFiltro() {
		return filtro;
	}


	public void setFiltro(CreditoEmpresaVO filtro) {
		this.filtro = filtro;
	}


	public EmpresaRedeEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(EmpresaRedeEJB entidade) {
		this.entidade = entidade;
	}
}

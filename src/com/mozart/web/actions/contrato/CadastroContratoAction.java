package com.mozart.web.actions.contrato;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ContratoDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.ejb.entity.ServicosContratoEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ContratoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class CadastroContratoAction extends BaseAction {

	private static final long serialVersionUID = -4797381933648578239L;
	
	private ContratoVO filtro;
	private ServicosContratoEJB entidade;
	private List <TipoLancamentoEJB> tipoLancamentoList, tipoLancamentoPagamentoList;
	private List<MozartComboWeb> contaFaturamentoList;
	
	private Long idEmpresa;
	private String nomeCliente;
	private String contaFaturamento;
	private String empresaCredito;
	
	public CadastroContratoAction (){
		filtro = new ContratoVO();
		entidade = new ServicosContratoEJB();
		tipoLancamentoList = Collections.emptyList();
		contaFaturamentoList = new ArrayList<MozartComboWeb>();
		contaFaturamentoList.add( new MozartComboWeb("C","Conta Corrente"));
		contaFaturamentoList.add( new MozartComboWeb("F","Faturamento"));
	}
	
	private void initCombo() throws MozartSessionException {
		TipoLancamentoEJB valor;
		valor = new TipoLancamentoEJB();
		valor.setIdHotel(getHotelCorrente().getIdHotel());
		
		tipoLancamentoList = OperacionalDelegate.instance().pesquisarTipoLancamentoContrato(valor);
		tipoLancamentoPagamentoList = OperacionalDelegate.instance().pesquisarTipoLancamentoContratoPagamento(valor);
	}
	
	public String prepararInclusao(){
		try {
			entidade.setId(null);
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			initCombo();
			
		} catch (MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
				
		return SUCESSO_FORWARD;
	}
	
	public String prepararCadastroContratos(){
		filtro.getFiltroCancelado().setTipo("C");
		filtro.getFiltroCancelado().setTipoIntervalo("3");
		filtro.getFiltroCancelado().setValorInicial("N");

		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		try { 
			initCombo();
			entidade=(ServicosContratoEJB) CheckinDelegate.instance().obter(ServicosContratoEJB.class, entidade.getId());
			nomeCliente = entidade.getEmpresaEJB().getEmpresaRedeEJBList().get(0).getNomeFantasia() + " - " + entidade.getEmpresaEJB().getCgc();
			empresaCredito = entidade.getEmpresaEJB().getEmpresaRedeEJBList().get(0).getCredito();
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD;
	}
	
	public String gravarContrato() {
		try { 
			entidade.setHotel(getHotelCorrente());
			entidade.setUsuario(getUsuario());
			//entidade.setCancelado("N");
			initCombo();
			ServicosContratoEJB contratoSession = (ServicosContratoEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			//entidade.setEmpresaEJB((EmpresaEJB) CheckinDelegate.instance().obter(EmpresaEJB.class, entidade.getEmpresaEJB().getIdEmpresa()));
			
			entidade.getTipoLancamentoEJB().setIdHotel(getHotelCorrente().getIdHotel());
			
			if(contaFaturamento.equals("F")){
				entidade.getTipoLancamentoCkEJB().setIdHotel(getHotelCorrente().getIdHotel());
			}
			else
			{
				entidade.setTipoLancamentoCkEJB(null);
			}
			
			if(entidade.getEmpresaEJB() != null  && entidade.getEmpresaEJB().getEmpresaRedeEJBList().size() > 0)
				{
					entidade.getEmpresaEJB().getEmpresaRedeEJBList().get(0).setCredito(empresaCredito);
				}
			
			TipoLancamentoEJBPK pk = new TipoLancamentoEJBPK();
			pk.idTipoLancamento = entidade.getTipoLancamentoEJB().getIdTipoLancamento();
			pk.idHotel = getHotelCorrente().getIdHotel();
			
			//entidade.setTipoLancamentoEJB((TipoLancamentoEJB)CheckinDelegate.instance().obter(TipoLancamentoEJB.class, pk));
			
			ServicosContratoEJB contrato = ContratoDelegate.instance().gravarContrato(entidade);
			
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ServicosContratoEJB();
			nomeCliente = "";

			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			return PESQUISA_FORWARD;
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD; 
	}
	
	public String pesquisar(){
		try {
			filtro.setIdHoteis(getIdHoteis());
			List<ContratoVO> lista = ContratoDelegate.instance().obterListaContratos(filtro);
			if (MozartUtil.isNull(lista)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);
			
		} catch(Exception ex) {
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public ContratoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ContratoVO filtro) {
		this.filtro = filtro;
	}

	public ServicosContratoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ServicosContratoEJB entidade) {
		this.entidade = entidade;
	}

	public List<TipoLancamentoEJB> getTipoLancamentoList() {
		return tipoLancamentoList;
	}

	public void setTipoLancamentoList(List<TipoLancamentoEJB> tipoLancamentoList) {
		this.tipoLancamentoList = tipoLancamentoList;
	}

	public Long getIdEmpresa() {
		return idEmpresa;
	}

	public void setIdEmpresa(Long idEmpresa) {
		this.idEmpresa = idEmpresa;
	}

	public String getNomeCliente() {
		return nomeCliente;
	}

	public void setNomeCliente(String nomeCliente) {
		this.nomeCliente = nomeCliente;
	}

	public List<MozartComboWeb> getContaFaturamentoList() {
		return contaFaturamentoList;
	}

	public void setContaFaturamentoList(List<MozartComboWeb> contaFaturamentoList) {
		this.contaFaturamentoList = contaFaturamentoList;
	}

	public List<TipoLancamentoEJB> getTipoLancamentoPagamentoList() {
		return tipoLancamentoPagamentoList;
	}

	public void setTipoLancamentoPagamentoList(
			List<TipoLancamentoEJB> tipoLancamentoPagamentoList) {
		this.tipoLancamentoPagamentoList = tipoLancamentoPagamentoList;
	}

	public String getContaFaturamento() {
		return contaFaturamento;
	}

	public void setContaFaturamento(String contaFaturamento) {
		this.contaFaturamento = contaFaturamento;
	}

	public String getEmpresaCredito() {
		return empresaCredito;
	}

	public void setEmpresaCredito(String empresaCredito) {
		this.empresaCredito = empresaCredito;
	}
}
	
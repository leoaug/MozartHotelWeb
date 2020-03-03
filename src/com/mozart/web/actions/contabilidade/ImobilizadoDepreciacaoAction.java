package com.mozart.web.actions.contabilidade;

import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.MovimentoContabilEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ImobilizadoDepreciacaoVO;
import com.mozart.web.actions.BaseAction;

public class ImobilizadoDepreciacaoAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8549356440714640406L;

	protected ImobilizadoDepreciacaoVO filtro;
	private ImobilizadoDepreciacaoVO entidade;
	private List <CentroCustoContabilEJB> centroCustoList;
	private List<String> listControleAtivo;
	private Long idMovimentoContabil;
	private boolean possuiDepreciacao;
	private String validaCheckinAtivoFixo;
		
	public ImobilizadoDepreciacaoAction() {
		centroCustoList = Collections.emptyList();
		this.filtro = new ImobilizadoDepreciacaoVO();
	}
	
	public String prepararPesquisa() throws MozartSessionException {
		
		Calendar c = new GregorianCalendar();
		c.setTime(getControlaData().getContabilidade());
		c.set(Calendar.DAY_OF_MONTH,c.getActualMinimum(Calendar.DAY_OF_MONTH));
		
		this.request.getSession().removeAttribute("entidadeSession");
		this.request.setAttribute("filtro.DataMovimento.tipoIntervalo",
				"1");
		this.request.setAttribute("filtro.DataMovimento.valorInicial",
				MozartUtil.format(c.getTime(), "dd/MM/yyyy"));
		
		Calendar cFinal = new GregorianCalendar();
		cFinal.setTime(getControlaData().getContabilidade());
		cFinal.set(Calendar.DAY_OF_MONTH,c.getActualMaximum(Calendar.DAY_OF_MONTH));
		
		this.request.setAttribute("filtro.DataMovimento.valorFinal",
				MozartUtil.format(cFinal.getTime(),
						"dd/MM/yyyy"));
	
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() throws MozartSessionException {
		initCombo();
		
		entidade = ContabilidadeDelegate.instance().obterImobilizadoDepreciacao(this.idMovimentoContabil, getHotelCorrente());
		
		request.getSession().removeAttribute(LISTA_PESQUISA);
		
		this.request.getSession().setAttribute("entidadeSession", this.entidade);
		
		return SUCESSO_FORWARD;
	}

	public String pesquisar() throws MozartSessionException {

		try {
			List<ImobilizadoDepreciacaoVO> listaPesquisa = ContabilidadeDelegate
					.instance().pesquisarImobilizadoDepreciacao(this.filtro, getHotelCorrente());
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}

		return SUCESSO_FORWARD;
	}
	
	public String prepararRelatorio(){
		try{
			prepararPesquisa();
			this.listControleAtivo = ContabilidadeDelegate.instance().obterComboControleAtivoFixo(getIdHoteis()[0]);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}
	
	private void initCombo(){
		try{
			CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
			filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
	}
	
	public String prepararManter(){
		initCombo();
		return SUCESSO_FORWARD;
	}

	public String gravar() throws MozartSessionException{
		
		try{

			MovimentoContabilEJB entidadeMov = ((MovimentoContabilEJB) CheckinDelegate
					.instance().obter(MovimentoContabilEJB.class,
							entidade.getIdMovimentoContabil()));
			
			if(!MozartUtil.isNull(entidadeMov.getCentroCustoContabilEJB()) 
					&& !MozartUtil.isNull(entidade.getIdCentroCustoContabil()) 
						&& entidade.getIdCentroCustoContabil() != entidadeMov.getCentroCustoContabilEJB().getIdCentroCustoContabil()){
				CentroCustoContabilEJB centroCusto = (CentroCustoContabilEJB)CheckinDelegate.instance().obter(CentroCustoContabilEJB.class, entidade.getIdCentroCustoContabil());
				entidadeMov.setCentroCustoContabilEJB(centroCusto);
			}
			
			entidadeMov.setControleAtivoFixo(Long.parseLong(entidade.getControle()));
			
			if(!MozartUtil.isNull(entidade.getIdPatrimonioSetor())) 
				entidadeMov.setIdPatrimonioSetor(Long.parseLong(entidade.getIdPatrimonioSetor()));
			
			CheckinDelegate.instance().alterar(entidadeMov);
			
			addMensagemSucesso(MSG_SUCESSO);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}finally{
			initCombo();
			prepararPesquisa();
		}
		return PESQUISA_FORWARD;
	}
	
	public String prepararEncerramento() {
		try {
			this.possuiDepreciacao = false;
			Long quantidadeDepreciacao = ContabilidadeDelegate.instance()
					.verificaDepreciacaoJaLancada(getIdHoteis()[0]);
			if (quantidadeDepreciacao > 0L) {
				this.possuiDepreciacao = true;
			}
			
			List<String> validaAtivoFixo = ContabilidadeDelegate.instance().obterValidacaoControleAtivoFixo(getIdHoteis()[0], getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			this.validaCheckinAtivoFixo = validaAtivoFixo.get(0);
			
			
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		
		return SUCESSO_FORWARD;
	}

	public String encerrar() {
		try {
			prepararPesquisa();
			
			ContabilidadeDelegate.instance().executarProcedureCalculoDepreciacao(getIdHoteis()[0]);
			
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			prepararEncerramento();
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception ex) {
			prepararEncerramento();
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return SUCESSO_FORWARD;
		}
		return "pesquisa";
	}

	public ImobilizadoDepreciacaoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ImobilizadoDepreciacaoVO filtro) {
		this.filtro = filtro;
	}

	public Long getIdMovimentoContabil() {
		return idMovimentoContabil;
	}

	public void setIdMovimentoContabil(Long idMovimentoContabil) {
		this.idMovimentoContabil = idMovimentoContabil;
	}

	public ImobilizadoDepreciacaoVO getEntidade() {
		return entidade;
	}

	public void setEntidade(ImobilizadoDepreciacaoVO entidade) {
		this.entidade = entidade;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public boolean isPossuiDepreciacao() {
		return possuiDepreciacao;
	}

	public void setPossuiDepreciacao(boolean possuiDepreciacao) {
		this.possuiDepreciacao = possuiDepreciacao;
	}

	public String getValidaCheckinAtivoFixo() {
		return validaCheckinAtivoFixo;
	}

	public void setValidaCheckinAtivoFixo(String validaCheckinAtivoFixo) {
		this.validaCheckinAtivoFixo = validaCheckinAtivoFixo;
	}

	public List<String> getListControleAtivo() {
		return listControleAtivo;
	}

	public void setListControleAtivo(List<String> listControleAtivo) {
		this.listControleAtivo = listControleAtivo;
	}
	
	
}

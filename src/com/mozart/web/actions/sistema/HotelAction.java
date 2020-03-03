package com.mozart.web.actions.sistema;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.EmpresaSeguradoraEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.RedeHotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.HotelVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class HotelAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private List <RedeHotelEJB> redeHotelList;
	private HotelEJB entidade;
	private HotelVO filtro;
	private List <MozartComboWeb> pensaoList, simNaoList, seguradoraList;
	private EmpresaSeguradoraEJB seguradora;
	private String operacao;
	
	public HotelAction (){
		
		entidade = new HotelEJB();
		filtro = new HotelVO();
		redeHotelList = Collections.emptyList();
		seguradora = new EmpresaSeguradoraEJB();
	}
	
	public String atualizarPorRede(){
		
		try{
			initCombo();
			RedeHotelEJB rede = entidade.getRedeHotelEJB();
			if(MozartUtil.isNull(rede)||MozartUtil.isNull(rede.getIdRedeHotel()))
				entidade=new HotelEJB();
			else{
			rede = redeHotelList.get(redeHotelList.indexOf(rede));
			entidade.setNomeFantasia(rede.getNomeFantasia());
			entidade.setRazaoSocial(rede.getRazaoSocial());
			entidade.setEndereco(rede.getEndereco());
			entidade.setBairro(rede.getBairro());
			entidade.setCep(rede.getCep());
			entidade.setSigla(rede.getSigla());
			entidade.setTelefone(rede.getTelefone());
			entidade.setFax(rede.getFax());
			entidade.setEmail(rede.getEmail());
			entidade.setCgc(rede.getCgc());
			entidade.setInscEstadual(rede.getInscEstadual());
			entidade.setInscMunicipal(rede.getInscMunicipal());
			entidade.setInscEmbratur(rede.getInscEmbratur());
			
			}
		}catch(Exception ex){
			
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		redeHotelList = SistemaDelegate.instance().pesquisarRedeHotel();
		pensaoList = new ArrayList<MozartComboWeb>();
		pensaoList.add(new MozartComboWeb("A", "ALL"));
		pensaoList.add(new MozartComboWeb("C", "COM CAFÉ"));
		pensaoList.add(new MozartComboWeb("N", "SEM CAFÉ"));
		pensaoList.add(new MozartComboWeb("M", "MAP"));
		pensaoList.add(new MozartComboWeb("F", "FAP"));
		
		simNaoList = new ArrayList<MozartComboWeb>();
		simNaoList.add(new MozartComboWeb("0", "Não"));
		simNaoList.add(new MozartComboWeb("1", "Sim"));
		
		seguradoraList = new ArrayList<MozartComboWeb>();
		seguradoraList.add(new MozartComboWeb("82", "ALFA"));
		
		
		
	}

public String prepararInclusao(){
	
	try{
		operacao = "I";
		initCombo();
		HotelEJB corrente = getHotelCorrente();
		entidade.setSigla(corrente.getSigla());
		entidade.setPensao(corrente.getPensao());
		entidade.setFnrh(corrente.getFnrh());
		entidade.setTaxaCheckout(corrente.getTaxaCheckout());
		entidade.setRazaoSocial(corrente.getRazaoSocial());
		entidade.setEndereco(corrente.getEndereco());
		entidade.setCidadeEJB(corrente.getCidadeEJB());
		entidade.setBairro(corrente.getBairro());
		entidade.setCep(corrente.getCep());
		entidade.setTelefone(corrente.getTelefone());
		entidade.setFax(corrente.getFax());
		entidade.setEmail(corrente.getEmail());
		entidade.setSite(corrente.getSite());
		entidade.setCgc(corrente.getCgc());
		entidade.setInscMunicipal(corrente.getInscMunicipal());
		entidade.setInscEstadual(corrente.getInscEstadual());
		entidade.setInscEmbratur(corrente.getInscEmbratur());
		entidade.setTelex(corrente.getTelex());
		entidade.setIss(corrente.getIss());
		entidade.setTaxaServico(corrente.getTaxaServico());
		entidade.setTaxaServico(corrente.getTaxaServico());
		entidade.setRoomtax(corrente.getRoomtax());
		entidade.setSeguro(corrente.getSeguro());
		entidade.setIrDuplicatas(corrente.getIrDuplicatas());
		entidade.setIsencaoIrDuplicatas(corrente.getIsencaoIrDuplicatas());
		entidade.setClassificacao(corrente.getClassificacao());
		entidade.setNotaTermo(corrente.getNotaTermo());
		entidade.setTitular(corrente.getTitular());
		entidade.setCpfTitular(corrente.getCpfTitular());
		entidade.setTipoHotel(corrente.getTipoHotel());
		entidade.setFormatoconta(corrente.getFormatoconta());
		entidade.setRazao(corrente.getRazao());
		entidade.setDiario(corrente.getDiario());
		entidade.setJuntaComercial(corrente.getJuntaComercial());
		entidade.setPaginasNota(corrente.getPaginasNota());
		entidade.setTextoPromocional(corrente.getTextoPromocional());
		entidade.setSede(corrente.getSede());
		entidade.setNotaFiscal(corrente.getNotaFiscal());
		entidade.setNotaFiscal("N");
		entidade.setResumoFiscal(corrente.getResumoFiscal());
		entidade.setNotaHosp(corrente.getNotaHosp());
		entidade.setNotaHospTipo(corrente.getNotaHospTipo());
		entidade.setNotaFiscalCodigo(corrente.getNotaFiscalCodigo());
		entidade.setTollFree(corrente.getTollFree());
		entidade.setContaCorrenteDuplicatas(corrente.getContaCorrenteDuplicatas());
		entidade.setControleAtivoFixo(corrente.getControleAtivoFixo());
		entidade.setIssRetencao(corrente.getIssRetencao());
		entidade.setEnderecoLogotipo(corrente.getEnderecoLogotipo());
		entidade.setNotaFiscalCodigo(corrente.getNotaFiscalCodigo());
		entidade.setAtivo(corrente.getAtivo());
		entidade.setAtivoWeb(corrente.getAtivoWeb());
		entidade.setTef(corrente.getTef());
		entidade.setInternet(corrente.getInternet());
		entidade.setObrigaDadosHosp(corrente.getObrigaDadosHosp());
		entidade.setCupomfiscal(corrente.getCupomfiscal());
		entidade.setPercentualJuros(corrente.getPercentualJuros());
		entidade.setMapfre(corrente.getMapfre());
		entidade.setBeliever(corrente.getBeliever());
		entidade.setEReserva(corrente.getEReserva());
		entidade.setFundoReserva(corrente.getFundoReserva());
		entidade.setFonteNota(corrente.getFonteNota());
		entidade.setMiniPdv(corrente.getMiniPdv());
		entidade.setRps(corrente.getRps());
		entidade.setNomeContador(corrente.getNomeContador());
		entidade.setCrcContador(corrente.getCrcContador());
		entidade.setCpfContador(corrente.getCpfContador());
		
		seguradora.setDiaVencimento(new Long (15));
		seguradora.setDtInicioSeguro(new Timestamp(new Date().getTime()));
		seguradora.setNumContratoApolice(new Long(614598));
		seguradora.setNumPlanoApolice(new Long(2982856));
		seguradora.setNumSubContratoApolice(new Long(123));
		seguradora.setVlDatacenter(new Double(3.5));
		seguradora.setVlManutencao(new Double(12));
		seguradora.setVlSeguro(new Double(1.2));
		
		
			} catch (MozartSessionException e) {
				
				addMensagemErro(MSG_ERRO);
				error(e.getMessage());
				
			}
			return SUCESSO_FORWARD;
			
			}



	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
public String prepararAlteracao() {
		
		try { 
			operacao="A";
			initCombo();
			entidade=(HotelEJB) CheckinDelegate.instance().obter(HotelEJB.class, entidade.getIdHotel());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarHotel() {
		try { 
			
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdPrograma(new Long(1));
			initCombo();
			
			
			if(entidade.getIdSeguradora()!=null){
				seguradora.setIdHotelSegurado(entidade.getIdHotel());
				seguradora.setIdSeguradora(entidade.getIdSeguradora());
				
			}else{
				
				seguradora=null;
				
			}
			entidade.setEmpresaSeguradoraEJB(null);
				
			
			if ("I".equals(getOperacao())){
				entidade = (HotelEJB)
				CheckinDelegate.instance().incluir(entidade);
				if(seguradora!=null){
					seguradora.setUsuario(getUserSession().getUsuarioEJB());
					seguradora.setSegurado(entidade);
					CheckinDelegate.instance().incluir(seguradora);
				}
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new HotelEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			List<HotelEJB> lista = SistemaDelegate.instance().pesquisarHotelEJB(filtro);
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

	public HotelEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(HotelEJB entidade) {
		this.entidade = entidade;
	}

	public List<RedeHotelEJB> getRedeHotelList() {
		return redeHotelList;
	}

	public void setRedeHotelList(List<RedeHotelEJB> redeHotelList) {
		this.redeHotelList = redeHotelList;
	}

	public List<MozartComboWeb> getPensaoList() {
		return pensaoList;
	}

	public void setPensaoList(List<MozartComboWeb> pensaoList) {
		this.pensaoList = pensaoList;
	}

	public List<MozartComboWeb> getSimNaoList() {
		return simNaoList;
	}

	public void setSimNaoList(List<MozartComboWeb> simNaoList) {
		this.simNaoList = simNaoList;
	}

	public HotelVO getFiltro() {
		return filtro;
	}

	public void setFiltro(HotelVO filtro) {
		this.filtro = filtro;
	}

	public List<MozartComboWeb> getSeguradoraList() {
		return seguradoraList;
	}

	public void setSeguradoraList(List<MozartComboWeb> seguradoraList) {
		this.seguradoraList = seguradoraList;
	}

	public EmpresaSeguradoraEJB getSeguradora() {
		return seguradora;
	}

	public void setSeguradora(EmpresaSeguradoraEJB seguradora) {
		this.seguradora = seguradora;
	}

	public String getOperacao() {
		return operacao;
	}

	public void setOperacao(String operacao) {
		this.operacao = operacao;
	}

	

}
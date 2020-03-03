package com.mozart.web.actions.contabilidade;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.ejb.entity.ClassificacaoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ClassificacaoContabilCentroCustoVO;
import com.mozart.model.vo.ClassificacaoContabilFaturamentoGrupoVO;
import com.mozart.model.vo.filtro.FiltroWeb;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartWebUtil;

public class ClassificacaoContabilCReceberAction extends BaseAction {

	private static final String PREFIXO_LIKE_DESCRICAO = "REC_%";


	/**
	 * 
	 */
	private static final long serialVersionUID = -461061668728225444L;

	
	private ClassificacaoContabilEJB recRecEjb;
	private ClassificacaoContabilEJB recJurEjb;
	private ClassificacaoContabilEJB recDupEjb;
	private ClassificacaoContabilEJB recFinEjb;
	private ClassificacaoContabilEJB recRddEjb;
	private ClassificacaoContabilEJB recDreEjb;
	private ClassificacaoContabilEJB recDraEjb;
	private ClassificacaoContabilEJB recPisEjb;
	private ClassificacaoContabilEJB recCofEjb;
	private ClassificacaoContabilEJB recCsslEjb;
	private ClassificacaoContabilEJB recIrrfEjb;
	private ClassificacaoContabilEJB recIssEjb;


	private List<ClassificacaoContabilEJB> listaPesquisa;
	
	private HashMap<String, String[]> hashDsClassificacaoContabil = new HashMap<String, String[]>();
	private HashMap<String, ClassificacaoContabilEJB> hashClassificacaoContabil = new HashMap<String, ClassificacaoContabilEJB>();
	
	
	private List<ClassificacaoContabilCentroCustoVO> listaCentroCusto;
	private ClassificacaoContabilFaturamentoGrupoVO filtro;
	

	public ClassificacaoContabilCReceberAction() {

		this.filtro = new ClassificacaoContabilFaturamentoGrupoVO();
		
		this.hashDsClassificacaoContabil.put("REC_REC", new String[]{"Contas a receber","C"});
		this.hashDsClassificacaoContabil.put("REC_JUR", new String[]{"Juros","C"});
		this.hashDsClassificacaoContabil.put("REC_DUP", new String[]{"Receb. Duplicatas Descontada Banco","C"});
		this.hashDsClassificacaoContabil.put("REC_FIN", new String[]{"Despesas financeiras","D"});
		this.hashDsClassificacaoContabil.put("REC_RDD", new String[]{"Duplicatas descontadas banco","D"});
		this.hashDsClassificacaoContabil.put("REC_DRE", new String[]{"Duplicatas recompradas","D"});
		this.hashDsClassificacaoContabil.put("REC_DRA", new String[]{"Desconto Recebimento automático","D"});
		this.hashDsClassificacaoContabil.put("REC_PIS", new String[]{"PIS","D"});
		this.hashDsClassificacaoContabil.put("REC_COF", new String[]{"COFINS","D"});
		this.hashDsClassificacaoContabil.put("REC_CSSL", new String[]{"CSSL","D"});
		this.hashDsClassificacaoContabil.put("REC_IRRF", new String[]{"IRRF","D"});
		this.hashDsClassificacaoContabil.put("REC_ISS", new String[]{"ISS","D"});
		
		
	}
	
	public String prepararInclusao(){
		HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
				"HOTEL_SESSION");
		
		ClassificacaoContabilEJB faturamento = new ClassificacaoContabilEJB();
		faturamento.setIdHotel(getHotelCorrente().getIdHotel());
		faturamento.setDescricao(PREFIXO_LIKE_DESCRICAO);
		
		
		try{
			listaPesquisa  =  ContabilidadeDelegate.instance().obterClassificacaoContabilFaturamento(faturamento);
			
			if (listaPesquisa.size()>0){
				return prepararAlteracao();
			}
			listaCentroCusto = ContabilidadeDelegate.instance().obterComboCentroCusto(hotelEJB.getRedeHotelEJB());
		}catch(Exception ex){
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request), ex
					.getMessage(), this.log);
		}
		this.request.getSession().setAttribute("centroCustoList",
				listaCentroCusto);
		
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao(){
		HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
				"HOTEL_SESSION");
		try{
			ClassificacaoContabilEJB faturamento = new ClassificacaoContabilEJB();
			faturamento.setIdHotel(getHotelCorrente().getIdHotel());
			faturamento.setDescricao(PREFIXO_LIKE_DESCRICAO);
			
			listaCentroCusto = ContabilidadeDelegate.instance().obterComboCentroCusto(hotelEJB.getRedeHotelEJB());
			
			listaPesquisa  =  ContabilidadeDelegate.instance().obterClassificacaoContabilFaturamento(faturamento);
			
			for (ClassificacaoContabilEJB c: listaPesquisa){
				if(c.getDescricao().equalsIgnoreCase("REC_COF")){
					recCofEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_CSSL")){
					recCsslEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_DRA")){
					recDraEjb = c;
				}else if (c.getDescricao().equalsIgnoreCase("REC_DRE")){
					recDreEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_DUP")){
					recDupEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_FIN")){
					recFinEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_IRRF")){
					recIrrfEjb = c;
				}else if (c.getDescricao().equalsIgnoreCase("REC_ISS")){
					recIssEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_JUR")){
					recJurEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_PIS")){
					recPisEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("REC_RDD")){
					recRddEjb = c;
				}else if (c.getDescricao().equalsIgnoreCase("REC_REC")){
					recRecEjb = c;
				}
			}
			
		}catch(Exception ex){
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request), ex
					.getMessage(), this.log);
		}
		this.request.getSession().setAttribute("centroCustoList",
				listaCentroCusto);
		
		return "alterar";
	}
	
	public HashMap<String, ClassificacaoContabilEJB> getHashClassificacaoContabil() {
		return hashClassificacaoContabil;
	}

	public void setHashClassificacaoContabil(
			HashMap<String, ClassificacaoContabilEJB> hashClassificacaoContabil) {
		this.hashClassificacaoContabil = hashClassificacaoContabil;
	}

	public String prepararManter() {
		listaPesquisa = null;
		this.request.getSession().removeAttribute("listaPesquisa");
		recRecEjb = new ClassificacaoContabilEJB();
		recJurEjb = new ClassificacaoContabilEJB();
		recDupEjb = new ClassificacaoContabilEJB();
		recFinEjb = new ClassificacaoContabilEJB();
		recRddEjb = new ClassificacaoContabilEJB();
		recDreEjb = new ClassificacaoContabilEJB();
		recDraEjb = new ClassificacaoContabilEJB();
		recPisEjb = new ClassificacaoContabilEJB();
		recCofEjb = new ClassificacaoContabilEJB();
		recCsslEjb = new ClassificacaoContabilEJB();
		recIrrfEjb = new ClassificacaoContabilEJB();
		recIssEjb = new ClassificacaoContabilEJB();
		
		return "pesquisa";
	}
	
	public String salvarClassificacaoContabil() throws MozartSessionException{
		try {
			info("Salvando Contas a Receber");
			Date agora = new Date();
			
			List<ClassificacaoContabilEJB> listaCReceber = new ArrayList<ClassificacaoContabilEJB>();
			
			listaCReceber.add(recRecEjb);
			listaCReceber.add(recJurEjb);
			listaCReceber.add(recDupEjb);
			listaCReceber.add(recFinEjb);
			listaCReceber.add(recRddEjb);
			listaCReceber.add(recDreEjb);
			listaCReceber.add(recDraEjb);
			listaCReceber.add(recPisEjb);
			listaCReceber.add(recCofEjb);
			listaCReceber.add(recCsslEjb);
			listaCReceber.add(recIrrfEjb);
			listaCReceber.add(recIssEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB =  getUsuario();
		
			String mensagem = "Todos os grupos são obrigatórios";
			String retorno="pesquisa";
			for (ClassificacaoContabilEJB o : listaCReceber){
				
				if((o.getPlanoContasCredito() == null || o.getPlanoContasCredito().getIdPlanoContas() == null)   
						&& (o.getPlanoContasDebito() == null || o.getPlanoContasDebito().getIdPlanoContas() == null)
						&& (o.getCentroCustoDebito() == null || o.getCentroCustoDebito().getIdCentroCustoContabil() == null)   
						&& (o.getCentroCustoCredito() == null || o.getCentroCustoCredito().getIdCentroCustoContabil() == null)){
					addMensagemErro(mensagem);
					removeMensagemSucesso();
					retorno = "sucesso";
					break;
				}
				
				ClassificacaoContabilEJB contasReceber = new ClassificacaoContabilEJB();
				contasReceber.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				contasReceber.setUsuario(usuarioEJB);
				contasReceber.setIdHotel(hotelEJB.getIdHotel());
				
				
				if(o.getCentroCustoDebito() != null){
					contasReceber.setCentroCustoDebito(o.getCentroCustoDebito());
				}
				
				if(o.getCentroCustoCredito() != null){
					contasReceber.setCentroCustoCredito(o.getCentroCustoCredito());
				}
				
				if(o.getPlanoContasDebito() != null){
					contasReceber.setPlanoContasDebito(o.getPlanoContasDebito());
				}
				if(o.getPlanoContasCredito() != null){
					contasReceber.setPlanoContasCredito(o.getPlanoContasCredito());
				}
				
				contasReceber.setPis((o.getPis()!=null)?o.getPis():"N");
				contasReceber.setDescricao(o.getDescricao());
				contasReceber.setIdClassificacaoContabil(ContabilidadeDelegate.instance().obterNextVal());
				
				ContabilidadeDelegate.instance().salvarClassificacaoContabilFaturamento(contasReceber);
				
				
				addMensagemSucesso("Operação realizada com sucesso.");
			}
			
			return retorno;
		}catch(Exception ex){
			addMensagemSucesso(ex.getMessage());
			error(ex.getMessage());
			return "sucesso";
		}
	}
	public String alterarClassificacaoContabil() throws MozartSessionException{
		try {
			info("Alterando Contas a Receber");
			Date agora = new Date();
			
			List<ClassificacaoContabilEJB> listaFaturamento = new ArrayList<ClassificacaoContabilEJB>();
			listaFaturamento.add(recCofEjb);
			listaFaturamento.add(recCsslEjb);
			listaFaturamento.add(recDraEjb);
			listaFaturamento.add(recDreEjb);
			listaFaturamento.add(recDupEjb);
			listaFaturamento.add(recFinEjb);
			listaFaturamento.add(recIrrfEjb);
			listaFaturamento.add(recIssEjb);
			listaFaturamento.add(recJurEjb);
			listaFaturamento.add(recPisEjb);
			listaFaturamento.add(recRddEjb);
			listaFaturamento.add(recRecEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB = (UsuarioEJB) getUserSession().getUsuarioEJB();
						
			for (ClassificacaoContabilEJB o : listaFaturamento){
				ClassificacaoContabilEJB faturamento = new ClassificacaoContabilEJB();
				faturamento.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				faturamento.setIdHotel(hotelEJB.getIdHotel());
				
				faturamento.setUsuario(usuarioEJB);
				
				if(o.getCentroCustoDebito() != null){
					faturamento.setCentroCustoDebito(o.getCentroCustoDebito());
				}
				
				if(o.getCentroCustoCredito() != null){
					faturamento.setCentroCustoCredito(o.getCentroCustoCredito());
				}
				
				if(o.getPlanoContasDebito() != null){
				faturamento.setPlanoContasDebito(o.getPlanoContasDebito());
				}
				if(o.getPlanoContasCredito() != null){
				faturamento.setPlanoContasCredito(o.getPlanoContasCredito());
				}
				faturamento.setPis(o.getPis());
				faturamento.setDescricao(o.getDescricao());
				faturamento.setIdClassificacaoContabil(o.getIdClassificacaoContabil());
				
				ContabilidadeDelegate.instance().alterarClassificacaoContabilFaturamento(faturamento);
				
				
			}
			
			addMensagemSucesso("Operação realizada com sucesso.");
			return "pesquisa";
		}catch(Exception ex){
			addMensagemSucesso(ex.getMessage());
			error(ex.getMessage());
			return "alterar";
		}
	}
	
	public String pesquisar() {

		warn("Pesquisando Classificacao Contabil Contas a Receber");
		try {
			
			ClassificacaoContabilFaturamentoGrupoVO classificacaoContabilFaturamentoGrupoVO =  (ClassificacaoContabilFaturamentoGrupoVO) this.filtro;
			
			FiltroWeb filtroFaturamento = classificacaoContabilFaturamentoGrupoVO.getFiltroFaturamento();
			
			this.filtro.setIdHoteis(new Long[]{getHotelCorrente().getIdHotel()});
			this.filtro.setDescricao(PREFIXO_LIKE_DESCRICAO);
			
			List<ClassificacaoContabilFaturamentoGrupoVO> listaPesquisa = ContabilidadeDelegate.instance().pesquisarClassificacaoContabilFaturamento(this.filtro);
			
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}else{
				for(int i=0; i<listaPesquisa.size(); i++){
					listaPesquisa.get(i).setDescricao(hashDsClassificacaoContabil.get(listaPesquisa.get(i).getDescricao())[0].toUpperCase());
				}
			}
			
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "pesquisa";
	
	}
	
	public List<ClassificacaoContabilCentroCustoVO> getListaCentroCusto() {
		return listaCentroCusto;
	}

	public void setListaCentroCusto(
			List<ClassificacaoContabilCentroCustoVO> listaCentroCusto) {
		this.listaCentroCusto = listaCentroCusto;
	}


	public ClassificacaoContabilEJB getRecRecEjb() {
		return recRecEjb;
	}

	public void setRecRecEjb(ClassificacaoContabilEJB recRecEjb) {
		this.recRecEjb = recRecEjb;
	}

	public ClassificacaoContabilEJB getRecJurEjb() {
		return recJurEjb;
	}

	public void setRecJurEjb(ClassificacaoContabilEJB recJurEjb) {
		this.recJurEjb = recJurEjb;
	}

	public ClassificacaoContabilEJB getRecDupEjb() {
		return recDupEjb;
	}

	public void setRecDupEjb(ClassificacaoContabilEJB recDupEjb) {
		this.recDupEjb = recDupEjb;
	}

	public ClassificacaoContabilEJB getRecFinEjb() {
		return recFinEjb;
	}

	public void setRecFinEjb(ClassificacaoContabilEJB recFinEjb) {
		this.recFinEjb = recFinEjb;
	}

	public ClassificacaoContabilEJB getRecRddEjb() {
		return recRddEjb;
	}

	public void setRecRddEjb(ClassificacaoContabilEJB recRddEjb) {
		this.recRddEjb = recRddEjb;
	}

	public ClassificacaoContabilEJB getRecDreEjb() {
		return recDreEjb;
	}

	public void setRecDreEjb(ClassificacaoContabilEJB recDreEjb) {
		this.recDreEjb = recDreEjb;
	}

	public ClassificacaoContabilEJB getRecDraEjb() {
		return recDraEjb;
	}

	public void setRecDraEjb(ClassificacaoContabilEJB recDraEjb) {
		this.recDraEjb = recDraEjb;
	}

	public ClassificacaoContabilEJB getRecPisEjb() {
		return recPisEjb;
	}

	public void setRecPisEjb(ClassificacaoContabilEJB recPisEjb) {
		this.recPisEjb = recPisEjb;
	}

	public ClassificacaoContabilEJB getRecCofEjb() {
		return recCofEjb;
	}

	public void setRecCofEjb(ClassificacaoContabilEJB recCofEjb) {
		this.recCofEjb = recCofEjb;
	}

	public ClassificacaoContabilEJB getRecCsslEjb() {
		return recCsslEjb;
	}

	public void setRecCsslEjb(ClassificacaoContabilEJB recCsslEjb) {
		this.recCsslEjb = recCsslEjb;
	}

	public ClassificacaoContabilEJB getRecIrrfEjb() {
		return recIrrfEjb;
	}

	public void setRecIrrfEjb(ClassificacaoContabilEJB recIrrfEjb) {
		this.recIrrfEjb = recIrrfEjb;
	}

	public ClassificacaoContabilEJB getRecIssEjb() {
		return recIssEjb;
	}

	public void setRecIssEjb(ClassificacaoContabilEJB recIssEjb) {
		this.recIssEjb = recIssEjb;
	}

	public ClassificacaoContabilFaturamentoGrupoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ClassificacaoContabilFaturamentoGrupoVO filtro) {
		this.filtro = filtro;
	}

	public List<ClassificacaoContabilEJB> getListaPesquisa() {
		return listaPesquisa;
	}

	public void setListaPesquisa(List<ClassificacaoContabilEJB> listaPesquisa) {
		this.listaPesquisa = listaPesquisa;
	}

	public HashMap<String, String[]> getHashDsClassificacaoContabil() {
		return hashDsClassificacaoContabil;
	}

	public void setHashDsClassificacaoContabil(
			HashMap<String, String[]> hashDsClassificacaoContabil) {
		this.hashDsClassificacaoContabil = hashDsClassificacaoContabil;
	}

	
}

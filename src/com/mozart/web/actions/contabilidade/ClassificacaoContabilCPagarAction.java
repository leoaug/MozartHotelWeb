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

public class ClassificacaoContabilCPagarAction extends BaseAction {

	private static final String PREFIXO_LIKE_DESCRICAO = "PAG_%";


	/**
	 * 
	 */
	private static final long serialVersionUID = -461061668728225444L;

	
	private ClassificacaoContabilEJB pagForEjb;
	private ClassificacaoContabilEJB pagJurEjb;
	private ClassificacaoContabilEJB pagAjuEjb;
	private ClassificacaoContabilEJB pagComEjb;


	private List<ClassificacaoContabilEJB> listaPesquisa;
	
	private HashMap<String, String[]> hashDsClassificacaoContabil = new HashMap<String, String[]>();
	private HashMap<String, ClassificacaoContabilEJB> hashClassificacaoContabil = new HashMap<String, ClassificacaoContabilEJB>();
	
	
	private List<ClassificacaoContabilCentroCustoVO> listaCentroCusto;
	private ClassificacaoContabilFaturamentoGrupoVO filtro;
	

	public ClassificacaoContabilCPagarAction() {

		this.filtro = new ClassificacaoContabilFaturamentoGrupoVO();
		
		this.hashDsClassificacaoContabil.put("PAG_JUR", new String[]{"Juros","D"});
		this.hashDsClassificacaoContabil.put("PAG_AJU", new String[]{"Ajustes","C"});
		this.hashDsClassificacaoContabil.put("PAG_COM", new String[]{"Comissão","D"});
		this.hashDsClassificacaoContabil.put("PAG_FOR", new String[]{"Fornecedor","C"});
		
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
				if(c.getDescricao().equalsIgnoreCase("PAG_AJU")){
					pagAjuEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("PAG_COM")){
					pagComEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("PAG_FOR")){
					pagForEjb = c;
				}else if (c.getDescricao().equalsIgnoreCase("PAG_JUR")){
					pagJurEjb = c;
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
		pagAjuEjb = new ClassificacaoContabilEJB();
		pagJurEjb = new ClassificacaoContabilEJB();
		pagForEjb = new ClassificacaoContabilEJB();
		pagComEjb = new ClassificacaoContabilEJB();
		
		return "pesquisa";
	}
	
	public String salvarClassificacaoContabil() throws MozartSessionException{
		try {
			info("Salvando Contas a Pagar");
			Date agora = new Date();
			
			List<ClassificacaoContabilEJB> listaCPagar = new ArrayList<ClassificacaoContabilEJB>();
			
			listaCPagar.add(pagJurEjb);
			listaCPagar.add(pagComEjb);
			listaCPagar.add(pagAjuEjb);
			listaCPagar.add(pagForEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB =  getUsuario();
		
			String mensagem = "Todos os grupos são obrigatórios";
			String retorno="pesquisa";
			for (ClassificacaoContabilEJB o : listaCPagar){
				
				if((o.getPlanoContasCredito() == null || o.getPlanoContasCredito().getIdPlanoContas() == null)   
						&& (o.getPlanoContasDebito() == null || o.getPlanoContasDebito().getIdPlanoContas() == null)
						&& (o.getCentroCustoDebito() == null || o.getCentroCustoDebito().getIdCentroCustoContabil() == null)   
						&& (o.getCentroCustoCredito() == null || o.getCentroCustoCredito().getIdCentroCustoContabil() == null)){
					addMensagemErro(mensagem);
					removeMensagemSucesso();
					retorno = "sucesso";
					break;
				}
				
				ClassificacaoContabilEJB contasPagar = new ClassificacaoContabilEJB();
				contasPagar.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				contasPagar.setUsuario(usuarioEJB);
				contasPagar.setIdHotel(hotelEJB.getIdHotel());
				
				
				if(o.getCentroCustoDebito() != null){
					contasPagar.setCentroCustoDebito(o.getCentroCustoDebito());
				}
				
				if(o.getCentroCustoCredito() != null){
					contasPagar.setCentroCustoCredito(o.getCentroCustoCredito());
				}
				
				if(o.getPlanoContasDebito() != null){
					contasPagar.setPlanoContasDebito(o.getPlanoContasDebito());
				}
				if(o.getPlanoContasCredito() != null){
					contasPagar.setPlanoContasCredito(o.getPlanoContasCredito());
				}
				
				contasPagar.setPis((o.getPis()!=null)?o.getPis():"N");
				contasPagar.setDescricao(o.getDescricao());
				contasPagar.setIdClassificacaoContabil(ContabilidadeDelegate.instance().obterNextVal());
				
				ContabilidadeDelegate.instance().salvarClassificacaoContabilFaturamento(contasPagar);
				
				
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
			info("Alterando Contas a Pagar");
			Date agora = new Date();
			
			List<ClassificacaoContabilEJB> listaCPagar = new ArrayList<ClassificacaoContabilEJB>();
			listaCPagar.add(pagJurEjb);
			listaCPagar.add(pagComEjb);
			listaCPagar.add(pagAjuEjb);
			listaCPagar.add(pagForEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB = (UsuarioEJB) getUserSession().getUsuarioEJB();
						
			for (ClassificacaoContabilEJB o : listaCPagar){
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

		warn("Pesquisando Classificacao Contabil Contas a Pagar");
		try {
			
			ClassificacaoContabilFaturamentoGrupoVO classificacaoContabilFaturamentoGrupoVO =  (ClassificacaoContabilFaturamentoGrupoVO) this.filtro;
			
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

	public ClassificacaoContabilEJB getPagForEjb() {
		return pagForEjb;
	}

	public void setPagForEjb(ClassificacaoContabilEJB pagForEjb) {
		this.pagForEjb = pagForEjb;
	}

	public ClassificacaoContabilEJB getPagJurEjb() {
		return pagJurEjb;
	}

	public void setPagJurEjb(ClassificacaoContabilEJB pagJurEjb) {
		this.pagJurEjb = pagJurEjb;
	}

	public ClassificacaoContabilEJB getPagAjuEjb() {
		return pagAjuEjb;
	}

	public void setPagAjuEjb(ClassificacaoContabilEJB pagAjuEjb) {
		this.pagAjuEjb = pagAjuEjb;
	}

	public ClassificacaoContabilEJB getPagComEjb() {
		return pagComEjb;
	}

	public void setPagComEjb(ClassificacaoContabilEJB pagComEjb) {
		this.pagComEjb = pagComEjb;
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

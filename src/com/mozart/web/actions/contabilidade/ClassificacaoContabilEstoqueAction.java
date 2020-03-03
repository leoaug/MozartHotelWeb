package com.mozart.web.actions.contabilidade;

import java.util.ArrayList;
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
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartWebUtil;

public class ClassificacaoContabilEstoqueAction extends BaseAction {

	private static final String PREFIXO_LIKE_DESCRICAO = "EST_%";

	private static final long serialVersionUID = -461061668728225444L;

	private ClassificacaoContabilEJB estForEjb;
	private ClassificacaoContabilEJB estEstEjb;

	private List<ClassificacaoContabilEJB> listaPesquisa;
	
	private HashMap<String, String[]> hashDsClassificacaoContabil = new HashMap<String, String[]>();
	private HashMap<String, ClassificacaoContabilEJB> hashClassificacaoContabil = new HashMap<String, ClassificacaoContabilEJB>();
	
	
	private List<ClassificacaoContabilCentroCustoVO> listaCentroCusto;
	private ClassificacaoContabilFaturamentoGrupoVO filtro;
	

	public ClassificacaoContabilEstoqueAction() {

		this.filtro = new ClassificacaoContabilFaturamentoGrupoVO();
		
		this.hashDsClassificacaoContabil.put("EST_FOR", new String[]{"Fornecedor","C"});
		this.hashDsClassificacaoContabil.put("EST_EST", new String[]{"Estoque","D"});
		
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
				if(c.getDescricao().equalsIgnoreCase("EST_FOR")){
					estForEjb = c;
				}else if (c.getDescricao().equalsIgnoreCase("EST_EST")){
					estEstEjb = c;
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
		estEstEjb = new ClassificacaoContabilEJB();
		estForEjb = new ClassificacaoContabilEJB();
		
		return "pesquisa";
	}
	
	public String salvarClassificacaoContabil() throws MozartSessionException{
		try {
			info("Salvando Estoque");

			List<ClassificacaoContabilEJB> listaEstoque = new ArrayList<ClassificacaoContabilEJB>();
			
			listaEstoque.add(estEstEjb);
			listaEstoque.add(estForEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB =  getUsuario();
		
			String mensagem = "Todos os grupos são obrigatórios";
			String retorno="pesquisa";
			for (ClassificacaoContabilEJB o : listaEstoque){
				
				if((o.getPlanoContasCredito() == null || o.getPlanoContasCredito().getIdPlanoContas() == null)   
						&& (o.getPlanoContasDebito() == null || o.getPlanoContasDebito().getIdPlanoContas() == null)
						&& (o.getCentroCustoDebito() == null || o.getCentroCustoDebito().getIdCentroCustoContabil() == null)   
						&& (o.getCentroCustoCredito() == null || o.getCentroCustoCredito().getIdCentroCustoContabil() == null)){
					addMensagemErro(mensagem);
					removeMensagemSucesso();
					retorno = "sucesso";
					break;
				}
				
				ClassificacaoContabilEJB estoque = new ClassificacaoContabilEJB();
				estoque.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				estoque.setUsuario(usuarioEJB);
				estoque.setIdHotel(hotelEJB.getIdHotel());
				
				
				if(o.getCentroCustoDebito() != null){
					estoque.setCentroCustoDebito(o.getCentroCustoDebito());
				}
				
				if(o.getCentroCustoCredito() != null){
					estoque.setCentroCustoCredito(o.getCentroCustoCredito());
				}
				
				if(o.getPlanoContasDebito() != null){
					estoque.setPlanoContasDebito(o.getPlanoContasDebito());
				}
				if(o.getPlanoContasCredito() != null){
					estoque.setPlanoContasCredito(o.getPlanoContasCredito());
				}
				
				estoque.setPis((o.getPis()!=null)?o.getPis():"N");
				estoque.setDescricao(o.getDescricao());
				estoque.setIdClassificacaoContabil(ContabilidadeDelegate.instance().obterNextVal());
				
				ContabilidadeDelegate.instance().salvarClassificacaoContabilFaturamento(estoque);
				
				
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
			info("Alterando Estoque");
			
			List<ClassificacaoContabilEJB> listaEstoque = new ArrayList<ClassificacaoContabilEJB>();
			listaEstoque.add(estEstEjb);
			listaEstoque.add(estForEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB = (UsuarioEJB) getUserSession().getUsuarioEJB();
						
			for (ClassificacaoContabilEJB o : listaEstoque){
				ClassificacaoContabilEJB estoque = new ClassificacaoContabilEJB();
				estoque.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				estoque.setIdHotel(hotelEJB.getIdHotel());
				
				estoque.setUsuario(usuarioEJB);
				
				if(o.getCentroCustoDebito() != null){
					estoque.setCentroCustoDebito(o.getCentroCustoDebito());
				}
				
				if(o.getCentroCustoCredito() != null){
					estoque.setCentroCustoCredito(o.getCentroCustoCredito());
				}
				
				if(o.getPlanoContasDebito() != null){
					estoque.setPlanoContasDebito(o.getPlanoContasDebito());
				}
				if(o.getPlanoContasCredito() != null){
					estoque.setPlanoContasCredito(o.getPlanoContasCredito());
				}
				estoque.setPis(o.getPis());
				estoque.setDescricao(o.getDescricao());
				estoque.setIdClassificacaoContabil(o.getIdClassificacaoContabil());
				
				ContabilidadeDelegate.instance().alterarClassificacaoContabilFaturamento(estoque);
				
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

		warn("Pesquisando Classificacao Contabil Estoque");
		try {
			
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

	public ClassificacaoContabilEJB getEstForEjb() {
		return estForEjb;
	}

	public void setEstForEjb(ClassificacaoContabilEJB estForEjb) {
		this.estForEjb = estForEjb;
	}

	public ClassificacaoContabilEJB getEstEstEjb() {
		return estEstEjb;
	}

	public void setEstEstEjb(ClassificacaoContabilEJB estEstEjb) {
		this.estEstEjb = estEstEjb;
	}


	
}

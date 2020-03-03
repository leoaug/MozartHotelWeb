package com.mozart.web.actions.contabilidade;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ClassificacaoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ClassificacaoContabilCentroCustoVO;
import com.mozart.model.vo.ClassificacaoContabilFaturamentoGrupoVO;
import com.mozart.model.vo.filtro.FiltroWeb;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartWebUtil;

public class ClassificacaoContabilFaturamentoAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -461061668728225504L;

	
	
	private ClassificacaoContabilEJB comissaoEjb;
	private ClassificacaoContabilEJB irrfEjb;
	private ClassificacaoContabilEJB ajustesEjb;
	private ClassificacaoContabilEJB encargosEjb;

	private ClassificacaoContabilFaturamentoGrupoVO comissao;
	private ClassificacaoContabilFaturamentoGrupoVO irrf;
	private ClassificacaoContabilFaturamentoGrupoVO ajustes;
	private ClassificacaoContabilFaturamentoGrupoVO encargos;
	private List<ClassificacaoContabilCentroCustoVO> listaCentroCusto;
	private ClassificacaoContabilFaturamentoGrupoVO filtro;
	
	
	private HashMap<String, String> hmDescricao;
	
	
	public HashMap<String, String> getHmDescricao() {
		return hmDescricao;
	}

	public void setHmDescricao(HashMap<String, String> hmDescricao) {
		this.hmDescricao = hmDescricao;
	}

	public ClassificacaoContabilFaturamentoAction() {
		comissao = new ClassificacaoContabilFaturamentoGrupoVO();
		irrf = new ClassificacaoContabilFaturamentoGrupoVO();
		ajustes = new ClassificacaoContabilFaturamentoGrupoVO();
		encargos = new ClassificacaoContabilFaturamentoGrupoVO();
		this.filtro = new ClassificacaoContabilFaturamentoGrupoVO();
		hmDescricao = new HashMap<String, String>();
		
		hmDescricao.put("FAT_COM", "COMISSÃO");
		hmDescricao.put("FAT_IRR", "IRRF");
		hmDescricao.put("FAT_AJU", "AJUSTES");
		hmDescricao.put("FAT_ENC", "ENCARGOS");
	}
	
	public String prepararInclusao(){
		HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
				"HOTEL_SESSION");
		try{
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
			faturamento.setDescricao("FAT_%");
			
			listaCentroCusto = ContabilidadeDelegate.instance().obterComboCentroCusto(hotelEJB.getRedeHotelEJB());
			
			List<ClassificacaoContabilEJB> classificacao  =  ContabilidadeDelegate.instance().obterClassificacaoContabilFaturamento(faturamento);
			
			for(ClassificacaoContabilEJB c :classificacao){
				
				if(c.getDescricao().equalsIgnoreCase("FAT_COM")){
					comissaoEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("FAT_IRR")){
					irrfEjb = c;
				}else if(c.getDescricao().equalsIgnoreCase("FAT_AJU")){
					ajustesEjb = c;
				}else if (c.getDescricao().equalsIgnoreCase("FAT_ENC")){
					encargosEjb = c;
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
	
	public String prepararManter() {
		
		comissao = new ClassificacaoContabilFaturamentoGrupoVO();
		irrf = new ClassificacaoContabilFaturamentoGrupoVO();
		ajustes = new ClassificacaoContabilFaturamentoGrupoVO();
		encargos = new ClassificacaoContabilFaturamentoGrupoVO();
		this.filtro = new ClassificacaoContabilFaturamentoGrupoVO();
		
		comissaoEjb = new ClassificacaoContabilEJB();
		irrfEjb = new ClassificacaoContabilEJB();
		ajustesEjb = new ClassificacaoContabilEJB();
		encargosEjb = new ClassificacaoContabilEJB();

		this.request.getSession().removeAttribute("listaPesquisa");
		
		return "pesquisa";
	}
	
	public String salvarClassificacaoContabil() throws MozartSessionException{
		try {
			info("Salvando faturamento");
			Date agora = new Date();
			
			List<ClassificacaoContabilFaturamentoGrupoVO> listaFaturamento = new ArrayList<ClassificacaoContabilFaturamentoGrupoVO>();
			listaFaturamento.add(comissao);
			listaFaturamento.add(irrf);
			listaFaturamento.add(ajustes);
			listaFaturamento.add(encargos);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			
			for (ClassificacaoContabilFaturamentoGrupoVO o : listaFaturamento){
				CentroCustoContabilEJB ccCred = new CentroCustoContabilEJB();
				CentroCustoContabilEJB ccDeb = new CentroCustoContabilEJB();
				PlanoContaEJB pcCred = new PlanoContaEJB();
				PlanoContaEJB pcDeb = new PlanoContaEJB();
				ClassificacaoContabilEJB faturamento = new ClassificacaoContabilEJB();

				
				faturamento.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				faturamento.setUsuario(this.getUserSession().getUsuarioEJB());
				faturamento.setIdHotel(hotelEJB.getIdHotel());
				
				ccDeb.setIdCentroCustoContabil(o.getCentroCustoDebito().getIdCentroCustoContabil());
				pcDeb.setIdPlanoContas(o.getDebito().getIdPlanoContas());
				ccCred.setIdCentroCustoContabil(o.getCentroCustoCredito().getIdCentroCustoContabil());
				pcCred.setIdPlanoContas(o.getCredito().getIdPlanoContas());
				
				
				faturamento.setCentroCustoDebito(ccDeb);
				faturamento.setCentroCustoCredito(ccCred);
				faturamento.setPlanoContasDebito(pcDeb);
				faturamento.setPlanoContasCredito(pcCred);
				faturamento.setPis(o.getPisDebito() && o.getPisCredito() ? "S" : "N");
				faturamento.setDescricao(o.getDescricao());
				faturamento.setIdClassificacaoContabil(ContabilidadeDelegate.instance().obterNextVal());
				
				ContabilidadeDelegate.instance().salvarClassificacaoContabilFaturamento(faturamento);
				
				
			}
			
			addMensagemSucesso("Operação realizada com sucesso.");
			return "sucesso";
		}catch(Exception ex){
			addMensagemSucesso(ex.getMessage());
			error(ex.getMessage());
			return "sucesso";
		}
	}
	public String alterarClassificacaoContabil() throws MozartSessionException{
		try {
			info("Alterando faturamento");
			Date agora = new Date();
			
			List<ClassificacaoContabilEJB> listaFaturamento = new ArrayList<ClassificacaoContabilEJB>();
			listaFaturamento.add(comissaoEjb);
			listaFaturamento.add(irrfEjb);
			listaFaturamento.add(ajustesEjb);
			listaFaturamento.add(encargosEjb);
			
			HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuarioEJB = (UsuarioEJB) getUserSession().getUsuarioEJB();
						
			for (ClassificacaoContabilEJB o : listaFaturamento){
				ClassificacaoContabilEJB faturamento = new ClassificacaoContabilEJB();
						
				
				faturamento.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				faturamento.setUsuario(this.getUserSession().getUsuarioEJB());
				faturamento.setIdHotel(hotelEJB.getIdHotel());
				
				faturamento.setUsuario(usuarioEJB);
				faturamento.setIdRedeHotel(hotelEJB.getRedeHotelEJB().getIdRedeHotel());
				faturamento.setIdHotel(hotelEJB.getIdHotel());
				faturamento.setCentroCustoDebito(o.getCentroCustoDebito());
				faturamento.setCentroCustoCredito(o.getCentroCustoCredito());
				faturamento.setPlanoContasDebito(o.getPlanoContasDebito());
				faturamento.setPlanoContasCredito(o.getPlanoContasCredito());
				faturamento.setPis(o.getPis());
				faturamento.setDescricao(o.getDescricao());
				faturamento.setIdClassificacaoContabil(o.getIdClassificacaoContabil());
				
				ContabilidadeDelegate.instance().alterarClassificacaoContabilFaturamento(faturamento);
				
			}
			
			addMensagemSucesso("Operação realizada com sucesso.");
			return this.pesquisar();
		}catch(Exception ex){
			addMensagemSucesso(ex.getMessage());
			error(ex.getMessage());
			return "alterar";
		}
	}
	
	public String pesquisar() {

		warn("Pesquisando ClassificacaoContabilFaturamento");
		try {
			
			
			
			ClassificacaoContabilFaturamentoGrupoVO classificacaoContabilFaturamentoGrupoVO =  (ClassificacaoContabilFaturamentoGrupoVO) this.filtro;
			
			FiltroWeb filtroFaturamento = classificacaoContabilFaturamentoGrupoVO.getFiltroFaturamento();
			
			
			this.filtro.setIdHoteis(new Long[]{getHotelCorrente().getIdHotel()});
			this.filtro.setDescricao("FAT_%");
			
			List<ClassificacaoContabilFaturamentoGrupoVO> listaPesquisa = ContabilidadeDelegate.instance().pesquisarClassificacaoContabilFaturamento(this.filtro);
			
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}else{
				for(int i=0; i<listaPesquisa.size(); i++){
					listaPesquisa.get(i).setDescricao(hmDescricao.get(listaPesquisa.get(i).getDescricao()));
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
	
	public ClassificacaoContabilFaturamentoGrupoVO getComissao() {
		return comissao;
	}

	public void setComissao(ClassificacaoContabilFaturamentoGrupoVO comissao) {
		this.comissao = comissao;
	}

	public ClassificacaoContabilFaturamentoGrupoVO getIrrf() {
		return irrf;
	}

	public void setIrrf(ClassificacaoContabilFaturamentoGrupoVO irrf) {
		this.irrf = irrf;
	}

	public ClassificacaoContabilFaturamentoGrupoVO getAjustes() {
		return ajustes;
	}

	public void setAjustes(ClassificacaoContabilFaturamentoGrupoVO ajustes) {
		this.ajustes = ajustes;
	}

	public ClassificacaoContabilFaturamentoGrupoVO getEncargos() {
		return encargos;
	}

	public void setEncargos(ClassificacaoContabilFaturamentoGrupoVO encargos) {
		this.encargos = encargos;
	}

	public List<ClassificacaoContabilCentroCustoVO> getListaCentroCusto() {
		return listaCentroCusto;
	}

	public void setListaCentroCusto(
			List<ClassificacaoContabilCentroCustoVO> listaCentroCusto) {
		this.listaCentroCusto = listaCentroCusto;
	}

	public ClassificacaoContabilEJB getComissaoEjb() {
		return comissaoEjb;
	}

	public void setComissaoEjb(ClassificacaoContabilEJB comissaoEjb) {
		this.comissaoEjb = comissaoEjb;
	}

	public ClassificacaoContabilEJB getIrrfEjb() {
		return irrfEjb;
	}

	public void setIrrfEjb(ClassificacaoContabilEJB irrfEjb) {
		this.irrfEjb = irrfEjb;
	}

	public ClassificacaoContabilEJB getAjustesEjb() {
		return ajustesEjb;
	}

	public void setAjustesEjb(ClassificacaoContabilEJB ajustesEjb) {
		this.ajustesEjb = ajustesEjb;
	}

	public ClassificacaoContabilEJB getEncargosEjb() {
		return encargosEjb;
	}

	public void setEncargosEjb(ClassificacaoContabilEJB encargosEjb) {
		this.encargosEjb = encargosEjb;
	}

}

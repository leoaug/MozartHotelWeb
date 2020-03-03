package com.mozart.web.actions.apiGeral;

import java.util.List;
import java.util.ArrayList;

import com.mozart.model.delegate.ApiGeralDelegate;
import com.mozart.model.ejb.entity.ApiContratoEJB;
import com.mozart.model.ejb.entity.ApiGeralEJB;
import com.mozart.model.ejb.entity.ApiVendedorEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApiGeralVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings({"serial", "finally"})
public class ApiGeralAction extends BaseAction{
	
	private ApiGeralVO filtro;
	private ApiGeralEJB entidade;
	private ApiContratoEJB apiContrato;
	private ApiVendedorEJB apiVendedor;
	private List<MozartComboWeb>  ativoList;
	private String empresaCnpj;
	private String empresaCpf;
	
	
	private Long indice;


	
	public ApiGeralAction(){
		filtro = new ApiGeralVO();
		entidade = new ApiGeralEJB();
		
		/*
		tipoEmpresaList = new ArrayList<MozartComboWeb>();
		tipoEmpresaList.add( new MozartComboWeb("A","Agência de Turismo"));
		tipoEmpresaList.add( new MozartComboWeb("O","Operadora"));
		tipoEmpresaList.add( new MozartComboWeb("E","Empresa"));
		tipoEmpresaList.add( new MozartComboWeb("P","Particular"));
		tipoEmpresaList.add( new MozartComboWeb("D","Diversos"));
		
		
		tipoReferenciaList = new ArrayList<MozartComboWeb>();
		tipoReferenciaList.add( new MozartComboWeb("B","Bancária"));
		tipoReferenciaList.add( new MozartComboWeb("C","Comercial"));
		
		
		pensaoList = new ArrayList<MozartComboWeb>();
		pensaoList.add( new MozartComboWeb("MAP","Meia Pensão"));
		pensaoList.add( new MozartComboWeb("FAP","Pensão Completa"));
		pensaoList.add( new MozartComboWeb("SIM","Com Café"));
		pensaoList.add( new MozartComboWeb("NAO","Sem Café"));
		pensaoList.add( new MozartComboWeb("ALL","All inclusive"));
		
		quemPagaList = new ArrayList<MozartComboWeb>();
		quemPagaList.add( new MozartComboWeb("E","Empresa"));
		quemPagaList.add( new MozartComboWeb("H","Hóspede"));
		
		
		*/
		
		this.ativoList = new ArrayList<MozartComboWeb>();
		this.ativoList.add(new MozartComboWeb("S", "Sim"));
		this.ativoList.add(new MozartComboWeb("N", "Não"));
	}
	 public String prepararRelatorio(){
	    	return SUCESSO_FORWARD;
	    }
	public String gravarApiGeral(){
		
		try{
			info("Iniciando a alteracao");
	
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			entidade = ApiGeralDelegate.instance().gravarApiGeral( entidade );
			addMensagemSucesso( MSG_SUCESSO );
			return PESQUISA_FORWARD;
			
		}catch(MozartValidateException ex){
			addMensagemSucesso( ex.getMessage() );
			return SUCESSO_FORWARD;
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
			return SUCESSO_FORWARD;
		}
		
	}
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		request.getSession().removeAttribute("entidadeSession");

		return SUCESSO_FORWARD;
		
	}
	
	
	public String validarApiGeral(){
		
		
		try{
			info("Iniciando validacao de Api Geral");
			
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}
		
		return SUCESSO_FORWARD;
	}
	
	
	@SuppressWarnings("unchecked")
	public String prepararAlteracao(){
		try{
			info("Iniciando a alteracao");
		
			
			
			initCombos();
			request.getSession().setAttribute("entidadeSession", entidade);
			
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}finally{	
			return SUCESSO_FORWARD;
		}
	}

	public String prepararInclusao(){
		try{
			
		
				
			// limpar os campos de referencia E socio
			info("Iniciando a inclusao");
			entidade = new ApiGeralEJB();
			
			
			initCombos();
			request.getSession().setAttribute("entidadeSession", entidade);
			
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}finally{	
			return SUCESSO_FORWARD;
		}
	}
	

	
	
	private void initCombos() throws MozartSessionException {

		/*
		GrupoEconomicoEJB filtroGE = new GrupoEconomicoEJB();
		filtroGE.setIdHotel( getIdHoteis()[0] );
		filtroGE.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		List<GrupoEconomicoEJB> grupoEconomicoList = EmpresaDelegate.instance().obterGrupoEconomico( filtroGE );
		request.getSession().setAttribute("grupoEconomicoList", grupoEconomicoList);
		
		TipoEmpresaEJB filtroTE = new TipoEmpresaEJB();
		filtroTE.setIdHotel(getIdHoteis()[0]);
		filtroTE.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		List<TipoEmpresaEJB> tipoEmpresaList = EmpresaDelegate.instance().obterTipoEmpresa( filtroTE );
		request.getSession().setAttribute("tipoEmpresaList", tipoEmpresaList);
		
		PromotorEJB filtroP = new PromotorEJB();
		filtroP.setIdHotel(getIdHoteis()[0]);
		filtroP.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		List<PromotorEJB> promotorList = EmpresaDelegate.instance().obterPromotor( filtroP );
		request.getSession().setAttribute("promotorList", promotorList);
		
		VendedorRedeEJB filtroV = new VendedorRedeEJB();
		filtroV.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		List<VendedorRedeEJB> vendedorList = EmpresaDelegate.instance().obterVendedor( filtroV );
		request.getSession().setAttribute("vendedorList", vendedorList);
		
		RepresentanteRedeEJB filtroR = new RepresentanteRedeEJB();
		filtroR.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		List<RepresentanteRedeEJB> representanteList = EmpresaDelegate.instance().obterRepresentante( filtroR );
		request.getSession().setAttribute("representanteList", representanteList);
		
		TarifaGrupoEJB filtroGT = new TarifaGrupoEJB();
		filtroGT.setIdHotel( getIdHoteis()[0] );
		List<TarifaGrupoEJB> grupoTarifaEJB = EmpresaDelegate.instance().obterTarifaGrupo( filtroGT );
		request.getSession().setAttribute("grupoTarifaList", grupoTarifaEJB);
		
		
		TarifaEJB filtroT = new TarifaEJB();
		filtroT.setIdHotel( getIdHoteis()[0] );
		filtroT.setAtivo("S");
		filtroT.setTipo("A");
		List<TarifaEJB> tarifaEJBList = EmpresaDelegate.instance().obterTarifa( filtroT );
		request.getSession().setAttribute("tarifaList", tarifaEJBList);
		
		
		*/
	}


	


	public String pesquisar(){
		try{
			info("Iniciando a pesquisa");

		
			List<ApiGeralVO> listaPesquisa = ApiGeralDelegate.instance().obterApisGeraisPorRazaoSocial(filtro);	
			
			if (MozartUtil.isNull( listaPesquisa )){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
				return prepararPesquisa();
			}
			
			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
			
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}finally{	
			return SUCESSO_FORWARD;
		}
	}


	
	public ApiGeralVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ApiGeralVO filtro) {
		this.filtro = filtro;
	}

	public ApiGeralEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ApiGeralEJB entidade) {
		this.entidade = entidade;
	}


	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}
	

	public String getEmpresaCnpj() {
		return empresaCnpj;
	}
	public void setEmpresaCnpj(String empresaCnpj) {
		this.empresaCnpj = empresaCnpj;
	}
	public String getEmpresaCpf() {
		return empresaCpf;
	}
	public void setEmpresaCpf(String empresaCpf) {
		this.empresaCpf = empresaCpf;
	}
	public List<MozartComboWeb> getAtivoList() {
		return ativoList;
	}
	public void setAtivoList(List<MozartComboWeb> ativoList) {
		this.ativoList = ativoList;
	}
	public ApiContratoEJB getApiContrato() {
		return apiContrato;
	}
	public void setApiContrato(ApiContratoEJB apiContrato) {
		this.apiContrato = apiContrato;
	}
	public ApiVendedorEJB getApiVendedor() {
		return apiVendedor;
	}
	public void setApiVendedor(ApiVendedorEJB apiVendedor) {
		this.apiVendedor = apiVendedor;
	}


	
}
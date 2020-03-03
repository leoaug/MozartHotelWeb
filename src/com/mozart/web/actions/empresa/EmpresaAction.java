package com.mozart.web.actions.empresa;

import java.util.Collections;
import java.util.List;
import java.util.ArrayList;







import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.ejb.entity.EmpresaGrupoLancamentoEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.EmpresaRedeEJB;
import com.mozart.model.ejb.entity.EmpresaRedeEJBPK;
import com.mozart.model.ejb.entity.EmpresaReferenciaEJB;
import com.mozart.model.ejb.entity.EmpresaSocioEJB;
import com.mozart.model.ejb.entity.GrupoEconomicoEJB;
import com.mozart.model.ejb.entity.IdentificaLancamentoEJB;
import com.mozart.model.ejb.entity.PromotorEJB;
import com.mozart.model.ejb.entity.RepresentanteRedeEJB;
import com.mozart.model.ejb.entity.TarifaEJB;
import com.mozart.model.ejb.entity.TarifaGrupoEJB;
import com.mozart.model.ejb.entity.TipoEmpresaEJB;
import com.mozart.model.ejb.entity.VendedorRedeEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EmpresaRedeVO;
import com.mozart.model.vo.EmpresaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings({"serial", "finally"})
public class EmpresaAction extends BaseAction{
	
	private EmpresaVO filtro;
	private EmpresaEJB entidade;
	private EmpresaHotelEJB empresaHotel;
	private EmpresaRedeEJB empresaRede;
	private List<MozartComboWeb> tipoEmpresaList, tipoReferenciaList, pensaoList, quemPagaList, opcoesList;
	private String empresaCnpj;
	private String empresaCpf;
	
	
	private Long indice;

	//dados dos sócios
	private String nomeSocio;
	private String cpfSocio;
	private Double participacaoSocio;
	
	// dados da referencia
	private String nomeBanco;
	private String contatoBanco;
	private String telefoneBanco;
	private String emailBanco;
	private String tipoReferencia;
	
	//dados da despesa
	private String[] quemPagaSelecionado;

	//dados da tarifa
	private Long idGrupoTarifa;
	
	//dados da empresa
	private Boolean bloquearEmpresa = false;
	
	private Boolean bloquearEmpresaRede = false;
	private Boolean bloquearParticular = false;
	
	public EmpresaAction(){
		filtro = new EmpresaVO();
		entidade = new EmpresaEJB();
		empresaHotel = new EmpresaHotelEJB();
		empresaRede = new EmpresaRedeEJB();
		empresaRede.setParticular("N");
		empresaRede.setCrs("N");
		empresaRede.setInternet("N");
		
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
		
		this.opcoesList = new ArrayList();
		this.opcoesList.add(new MozartComboWeb("1", "Pessoa Jurídica"));
		this.opcoesList.add(new MozartComboWeb("2", "Pessoa Física"));
		this.opcoesList.add(new MozartComboWeb("3", "Outros"));
		
	}
	 public String prepararRelatorio(){
	    	return SUCESSO_FORWARD;
	    }
	public String gravarEmpresa(){
		
		try{
			info("Iniciando a alteracao");
			entidade = getEmpresaPreenchida();
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			entidade = EmpresaDelegate.instance().gravarEmpresa( entidade );
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
	
	
	public String validarEmpresa(){
		
		
		try{
			info("Iniciando validacao da empresa");
			
			EmpresaEJB empresaValidada = EmpresaDelegate.instance().obterEmpresa(entidade);
			if (MozartUtil.isNull( empresaValidada )){
				return SUCESSO_FORWARD;
			}
			
			//List<EmpresaRedeEJB> listaRede = empresaValidada.getEmpresaRedeEJBList();
			EmpresaRedeEJB 	redeCorrente = null;
			
			try{
				EmpresaRedeEJBPK pkRede = new EmpresaRedeEJBPK();
				pkRede.idEmpresa  = empresaValidada.getIdEmpresa();
				pkRede.idRedeHotel = getHotelCorrente().getRedeHotelEJB().getIdRedeHotel();
				redeCorrente = (EmpresaRedeEJB)CheckinDelegate.instance().obter(EmpresaRedeEJB.class, pkRede);	
				if ( redeCorrente != null){
					List<EmpresaHotelEJB> listaEmpresas = redeCorrente.getEmpresaHotelEJBList();
					// procura o empresahotel corrente
					for (EmpresaHotelEJB eh: listaEmpresas){
						if ( getIdHoteis()[0].equals( eh.getIdHotel())){
							addMensagemSucesso("Empresa já cadastrada.");
							return prepararInclusao();
						}
					}
					/*EmpresaHotelEJBPK pkHotel = new EmpresaHotelEJBPK();
					pkHotel.idEmpresa  = empresaValidada.getIdEmpresa();
					pkHotel.idHotel = getHotelCorrente().getIdHotel();
					EmpresaHotelEJB hotelCorrente = (EmpresaHotelEJB)CheckinDelegate.instance().obter(EmpresaHotelEJB.class, pkHotel);	
					if (hotelCorrente != null){
						addMessagemSucesso("Empresa já cadastrada.");
						return prepararInclusao();
					}*/
				}
				
			}catch(Exception ex){
				
			}
			
			/*for (EmpresaRedeEJB rede: listaRede){
				//procura a rede corrente
				if ( rede.getIdRedeHotel().equals( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() )){
					redeCorrente = rede;
					List<EmpresaHotelEJB> listaEmpresas = rede.getEmpresaHotelEJBList();
					// procura o empresahotel corrente
					for (EmpresaHotelEJB eh: listaEmpresas){
						if ( getIdHoteis()[0].equals( eh.getIdHotel())){
							addMessagemSucesso("Empresa já cadastrada.");
							return prepararInclusao();
						}
					}
				}
			}*/
			EmpresaEJB empSession = (EmpresaEJB)request.getSession().getAttribute("entidadeSession");

			bloquearEmpresaRede = redeCorrente!=null;
			bloquearEmpresaRede = !isAdm();
			empresaRede = redeCorrente==null?empSession.getEmpresaRedeEJBList().get(0):redeCorrente;
			entidade = empresaValidada;
			entidade.setEmpresaRedeEJBList( new ArrayList<EmpresaRedeEJB>());
			//entidade.getEmpresaRedeEJBList().clear();
			empresaRede = entidade.addEmpresaRedeEJB( empresaRede );
			empresaHotel = empSession.getEmpresaRedeEJBList().get(0).getEmpresaHotelEJBList().get(0);
			
			entidade.getEmpresaRedeEJBList().get(0).setEmpresaHotelEJBList( new ArrayList<EmpresaHotelEJB>() );
//			entidade.getEmpresaRedeEJBList().get(0).getEmpresaHotelEJBList().clear();
			empresaHotel = entidade.getEmpresaRedeEJBList().get(0).addEmpresaHotelEJB( empresaHotel );			
			entidade = getEmpresaPreenchida();
			request.getSession().setAttribute("entidadeSession", entidade);
			bloquearEmpresa = true;
			
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
			
			EmpresaHotelEJBPK pk = new EmpresaHotelEJBPK();
			pk.idEmpresa = entidade.getIdEmpresa();
			pk.idHotel = getIdHoteis()[0];
			
			empresaHotel = EmpresaDelegate.instance().obterEmpresaHotelByPK(pk);
			empresaHotel.getEmpresaRedeEJB().setEmpresaHotelEJBList( new ArrayList<EmpresaHotelEJB>() );
			empresaHotel.getEmpresaRedeEJB().addEmpresaHotelEJB(empresaHotel);
			empresaHotel.getEmpresaRedeEJB().getEmpresaEJB().setEmpresaRedeEJBList(new ArrayList<EmpresaRedeEJB>() );
			empresaHotel.getEmpresaRedeEJB().getEmpresaEJB().addEmpresaRedeEJB( empresaHotel.getEmpresaRedeEJB() );
			
			entidade = empresaHotel.getEmpresaRedeEJB().getEmpresaEJB();
			empresaRede = empresaHotel.getEmpresaRedeEJB();
			
			Collections.sort(empresaHotel.getEmpresaGrupoLancamentoEJBList(), EmpresaGrupoLancamentoEJB.getComparator());   
			
			
			
			initCombos();
			request.getSession().setAttribute("entidadeSession", entidade);
			
			
			bloquearEmpresa = true;
			
			bloquearEmpresaRede = !isAdm();
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}finally{	
			return SUCESSO_FORWARD;
		}
	}

	public String prepararInclusao(){
		try{
			
			bloquearEmpresa = false;
			bloquearEmpresaRede = false;
				
			// limpar os campos de referencia E socio
			info("Iniciando a inclusao");
			entidade = new EmpresaEJB();
			entidade.setCartaoCredito("N");
			empresaHotel = new EmpresaHotelEJB();
			empresaRede = new EmpresaRedeEJB();
			empresaRede.setCredito("N");
			
			empresaHotel.setCalculaIss("S");
			empresaHotel.setCalculaSeguro("S");
			empresaHotel.setCalculaRoomtax("N");
			empresaHotel.setCalculaTaxa("N");
			empresaHotel.setIdHotel( getIdHoteis()[0]);
			empresaHotel.setTipoPensao(convertTipoPensao(getHotelCorrente().getPensao()));
			
			List<IdentificaLancamentoEJB> identificaList = new ArrayList<IdentificaLancamentoEJB>();
			
			IdentificaLancamentoEJB filtro = new IdentificaLancamentoEJB();
			filtro.setAtividade("HOTEL");
			filtro.setGrupoSub("G");
			filtro.setGrupoDespesa("S");
			identificaList = EmpresaDelegate.instance().obterIdentificaLancamento( filtro );
			
			for (IdentificaLancamentoEJB ident: identificaList){
				EmpresaGrupoLancamentoEJB egl = new EmpresaGrupoLancamentoEJB();
				egl.setEmpresaHotelEJB(empresaHotel);
				egl.setIdentificaLancamentoEJB(ident);
				egl.setQuemPaga( ident.getDescricaoLancamento().indexOf("DIARIA") >=0?"H":"E" );
				egl.setIdHotel( getIdHoteis()[0]);
				empresaHotel.getEmpresaGrupoLancamentoEJBList().add( egl );
			}
			
			empresaRede.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			empresaRede.addEmpresaHotelEJB(empresaHotel);
			empresaRede.setParticular("N");
			entidade.addEmpresaRedeEJB(empresaRede);
			entidade.setNacional("1");
			initCombos();
			request.getSession().setAttribute("entidadeSession", entidade);
			
			nomeSocio = "";
			cpfSocio = "";
			participacaoSocio = null;
			
			// dados da referencia
			nomeBanco = "";
			contatoBanco = "";
			
			emailBanco = "";
			tipoReferencia = "";
			idGrupoTarifa = null;
			
			
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}finally{	
			return SUCESSO_FORWARD;
		}
	}
	
	private void validarParticular() throws MozartSessionException {
		EmpresaRedeVO empresaRedeVO = new EmpresaRedeVO();
		empresaRedeVO.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		empresaRedeVO.setBcParticular("S");
		
		empresaRedeVO = ReservaDelegate.instance()
				.obterEmpresaRedePorIdERede(empresaRedeVO);
		
		if((MozartUtil.isNull(empresaRede) || MozartUtil.isNull(empresaRede.getIdEmpresa()) ) 
				|| ! empresaRede.getIdEmpresa().equals(empresaRedeVO.getBcIdEmpresa())){
		
			if(!MozartUtil.isNull(empresaRedeVO.getBcIdEmpresa())){
				bloquearParticular = true;
			}
		}
	}
	
	
	
	private void initCombos() throws MozartSessionException {

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
		
		validarParticular();
		
	}

	public String incluirReferencia(){
		
		EmpresaReferenciaEJB referencia = new EmpresaReferenciaEJB(); 	
		referencia.setContato(contatoBanco);
		referencia.setEmail(emailBanco);
		referencia.setRazaoSocial(nomeBanco);
		referencia.setTelefone(telefoneBanco);
		referencia.setTipo(tipoReferencia);
		EmpresaEJB empresa = getEmpresaPreenchida();
		empresa.addEmpresaReferenciaEJB(referencia);
		request.getSession().setAttribute("entidadeSession", empresa);
		
		return SUCESSO_FORWARD;
	}
	
	public String excluirReferencia(){
		
		EmpresaEJB empresa = getEmpresaPreenchida();
		empresa.getEmpresaReferenciaEJBList().remove( indice.intValue() );
		request.getSession().setAttribute("entidadeSession", empresa);
		return SUCESSO_FORWARD;
	}

	
	public String incluirSocio(){
				
		EmpresaSocioEJB socio = new EmpresaSocioEJB();
		socio.setNome(nomeSocio);
		socio.setCpf(cpfSocio);
		socio.setParticipacao(MozartUtil.format(participacaoSocio));
		
		EmpresaEJB empresa = getEmpresaPreenchida();
		empresa.addEmpresaSocioEJB(socio);
		request.getSession().setAttribute("entidadeSession", empresa);
		
		return SUCESSO_FORWARD;
		
	}
	
	
	public String excluirSocio(){
		
		EmpresaEJB empresa = getEmpresaPreenchida();
		empresa.getEmpresaSocioEJBList().remove( indice.intValue() );
		request.getSession().setAttribute("entidadeSession", empresa);
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		try{
			info("Iniciando a pesquisa");

			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			List<EmpresaVO> listaPesquisa = EmpresaDelegate.instance().pesquisarEmpresa(filtro);	
			
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

	private EmpresaEJB getEmpresaPreenchida(){
		
		EmpresaEJB session = (EmpresaEJB)request.getSession().getAttribute("entidadeSession");
		entidade.setEmpresaSocioEJBList( session.getEmpresaSocioEJBList() );
		
		for (int x=0;x<entidade.getEmpresaSocioEJBList().size();x++){
			entidade.getEmpresaSocioEJBList().get(x).setEmpresaEJB(entidade);
		}
		
		entidade.setEmpresaReferenciaEJBList( session.getEmpresaReferenciaEJBList() );
		for (int x=0;x<entidade.getEmpresaReferenciaEJBList().size();x++){
			entidade.getEmpresaReferenciaEJBList().get(x).setEmpresaEJB(entidade);
		}

		if(getHotelCorrente().getIdPrograma() == 1){
			empresaHotel.setEmpresaGrupoLancamentoEJBList( session.getEmpresaRedeEJBList().get(0).getEmpresaHotelEJBList().get(0).getEmpresaGrupoLancamentoEJBList() );
			if (!MozartUtil.isNull( quemPagaSelecionado )){
				for (int x=0;x<quemPagaSelecionado.length;x++){
					empresaHotel.getEmpresaGrupoLancamentoEJBList().get(x).setQuemPaga( quemPagaSelecionado[x] );
					empresaHotel.getEmpresaGrupoLancamentoEJBList().get(x).setEmpresaHotelEJB(empresaHotel);
				}
			}
			
			empresaHotel.setEmpresaTarifaEJBList( session.getEmpresaRedeEJBList().get(0).getEmpresaHotelEJBList().get(0).getEmpresaTarifaEJBList() );
			for (int x=0;x<empresaHotel.getEmpresaTarifaEJBList().size();x++){
				empresaHotel.getEmpresaTarifaEJBList().get(x).setEmpresaHotelEJB(empresaHotel);
			}
		}
		else{
			empresaRede.setDeadLine(2L);
			empresaRede.setNoShow("S");
			empresaHotel.setTipoPensao("NAO");
			empresaHotel.setCalculaIss("N");
			empresaHotel.setCalculaTaxa("N");
			empresaHotel.setCalculaRoomtax("N");
		}
		
		if(empresaRede.getIdVendedor() != null && empresaRede.getIdVendedor() == 0L)
			empresaRede.setIdVendedor(null);
		
		if(empresaRede.getIdRepresentante() != null && empresaRede.getIdRepresentante() == 0L)
			empresaRede.setIdRepresentante(null);
		
		empresaHotel.setEmpresaRedeEJB(empresaRede);
		if (empresaRede.getGrupoEconomico() != null && empresaRede.getGrupoEconomico().getIdGrupoEconomico() == null){
			empresaRede.setGrupoEconomico( null );
		}
		empresaRede.addEmpresaHotelEJB( empresaHotel );
		
		empresaRede.setEmpresaEJB( entidade );
		entidade.getEmpresaRedeEJBList().add( empresaRede );
		
		if (entidade.getEmpresaRedeEJBList().get(0).getEmpresaCorporateEJB() == null ||
				entidade.getEmpresaRedeEJBList().get(0).getEmpresaCorporateEJB().getIdEmpresa() == null){
				entidade.getEmpresaRedeEJBList().get(0).setEmpresaCorporateEJB(null);
		}
				
		if (!MozartUtil.isNull(entidade.getEmpresaJuntaEJB())){
				entidade.getEmpresaJuntaEJB().setEmpresaEJB(entidade);
		}
			
		return entidade;
	}
	
	public EmpresaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(EmpresaVO filtro) {
		this.filtro = filtro;
	}

	public EmpresaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(EmpresaEJB entidade) {
		this.entidade = entidade;
	}

	public List<MozartComboWeb> getTipoEmpresaList() {
		return tipoEmpresaList;
	}

	public void setTipoEmpresaList(List<MozartComboWeb> tipoEmpresaList) {
		this.tipoEmpresaList = tipoEmpresaList;
	}

	public EmpresaHotelEJB getEmpresaHotel() {
		return empresaHotel;
	}

	public void setEmpresaHotel(EmpresaHotelEJB empresaHotel) {
		this.empresaHotel = empresaHotel;
	}

	public String getNomeSocio() {
		return nomeSocio;
	}

	public void setNomeSocio(String nomeSocio) {
		this.nomeSocio = nomeSocio;
	}

	public String getCpfSocio() {
		return cpfSocio;
	}

	public void setCpfSocio(String cpfSocio) {
		this.cpfSocio = cpfSocio;
	}

	public Double getParticipacaoSocio() {
		return participacaoSocio;
	}

	public void setParticipacaoSocio(Double participacaoSocio) {
		this.participacaoSocio = participacaoSocio;
	}

	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public String getNomeBanco() {
		return nomeBanco;
	}

	public void setNomeBanco(String nomeBanco) {
		this.nomeBanco = nomeBanco;
	}

	public String getContatoBanco() {
		return contatoBanco;
	}

	public void setContatoBanco(String contatoBanco) {
		this.contatoBanco = contatoBanco;
	}

	public String getTelefoneBanco() {
		return telefoneBanco;
	}

	public void setTelefoneBanco(String telefoneBanco) {
		this.telefoneBanco = telefoneBanco;
	}

	public String getEmailBanco() {
		return emailBanco;
	}

	public void setEmailBanco(String emailBanco) {
		this.emailBanco = emailBanco;
	}

	public List<MozartComboWeb> getTipoReferenciaList() {
		return tipoReferenciaList;
	}

	public void setTipoReferenciaList(List<MozartComboWeb> tipoReferenciaList) {
		this.tipoReferenciaList = tipoReferenciaList;
	}

	public String getTipoReferencia() {
		return tipoReferencia;
	}

	public void setTipoReferencia(String tipoReferencia) {
		this.tipoReferencia = tipoReferencia;
	}

	public EmpresaRedeEJB getEmpresaRede() {
		return empresaRede;
	}

	public void setEmpresaRede(EmpresaRedeEJB empresaRede) {
		this.empresaRede = empresaRede;
	}

	public List<MozartComboWeb> getPensaoList() {
		return pensaoList;
	}

	public void setPensaoList(List<MozartComboWeb> pensaoList) {
		this.pensaoList = pensaoList;
	}

	public List<MozartComboWeb> getQuemPagaList() {
		return quemPagaList;
	}

	public void setQuemPagaList(List<MozartComboWeb> quemPagaList) {
		this.quemPagaList = quemPagaList;
	}

	public String[] getQuemPagaSelecionado() {
		return quemPagaSelecionado;
	}

	public void setQuemPagaSelecionado(String[] quemPagaSelecionado) {
		this.quemPagaSelecionado = quemPagaSelecionado;
	}

	public Long getIdGrupoTarifa() {
		return idGrupoTarifa;
	}

	public void setIdGrupoTarifa(Long idGrupoTarifa) {
		this.idGrupoTarifa = idGrupoTarifa;
	}

	public Boolean getBloquearEmpresa() {
		return bloquearEmpresa;
	}

	public void setBloquearEmpresa(Boolean bloquearEmpresa) {
		this.bloquearEmpresa = bloquearEmpresa;
	}

	public Boolean getBloquearEmpresaRede() {
		return bloquearEmpresaRede;
	}

	public void setBloquearEmpresaRede(Boolean bloquearEmpresaRede) {
		this.bloquearEmpresaRede = bloquearEmpresaRede;
	}
	public Boolean getBloquearParticular() {
		return bloquearParticular;
	}
	public void setBloquearParticular(Boolean bloquearParticular) {
		this.bloquearParticular = bloquearParticular;
	}
	public List<MozartComboWeb> getOpcoesList() {
		return opcoesList;
	}

	public void setOpcoesList(List<MozartComboWeb> opcoesList) {
		this.opcoesList = opcoesList;
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
	
}
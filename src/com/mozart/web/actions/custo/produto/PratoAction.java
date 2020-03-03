package com.mozart.web.actions.custo.produto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.NfeDelegate;
import com.mozart.model.ejb.entity.AliquotaEJB;
import com.mozart.model.ejb.entity.FichaTecnicaPratoEJB;
import com.mozart.model.ejb.entity.FichaTecnicaPratoEJBPK;
import com.mozart.model.ejb.entity.FiscalCodigoEJB;
import com.mozart.model.ejb.entity.FiscalIncidenciaEJB;
import com.mozart.model.ejb.entity.GrupoPratoEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJBPK;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.NfeCofinsCadastroEJB;
import com.mozart.model.ejb.entity.NfeCofinsCadastroStEJB;
import com.mozart.model.ejb.entity.NfeCofinsCstEJB;
import com.mozart.model.ejb.entity.NfeIICadastroEJB;
import com.mozart.model.ejb.entity.NfeIcmsCadastroEJB;
import com.mozart.model.ejb.entity.NfeIcmsModBcIcmsEJB;
import com.mozart.model.ejb.entity.NfeIcmsModBcIcmsStEJB;
import com.mozart.model.ejb.entity.NfeIcmsMotivoDesoneracaoEJB;
import com.mozart.model.ejb.entity.NfeIcmsOrigemMercadoriaEJB;
import com.mozart.model.ejb.entity.NfeIpiCadastroEJB;
import com.mozart.model.ejb.entity.NfeIpiCstEJB;
import com.mozart.model.ejb.entity.NfePisCadastroEJB;
import com.mozart.model.ejb.entity.NfePisCadastroStEJB;
import com.mozart.model.ejb.entity.NfePisCstEJB;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.TipoItemEJB;
import com.mozart.model.ejb.enums.EnumCstA;
import com.mozart.model.ejb.enums.EnumCstB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EstadoNfeVO;
import com.mozart.model.vo.ItemEstoqueVO;
import com.mozart.model.vo.PratoVO;
import com.mozart.model.vo.SituacaoTributariaVO;
import com.mozart.model.vo.UnidadeNfeVO;
import com.mozart.web.actions.BaseAction;

public class PratoAction extends BaseAction {

	private static final long serialVersionUID = -4797381933648578239L;
	
	private PratoEJB entidade;
	private NfeIcmsCadastroEJB entidadeIcms;
	private NfeCofinsCadastroEJB entidadeCofins;
	private NfeCofinsCadastroStEJB entidadeCofinsSt;
	private NfePisCadastroEJB entidadePis;
	private NfePisCadastroStEJB entidadePisSt;
	private NfeIICadastroEJB entidadeII;
	private NfeIpiCadastroEJB entidadeIpi; 
	private PratoVO filtro;
	private List <GrupoPratoEJB> grupoPratoList;
	private List <TipoItemEJB> tipoItemList;
	private List <FiscalCodigoEJB> fiscalCodigoList;
	private List <FiscalIncidenciaEJB> fiscalIncidenciaList;
	private List <AliquotaEJB> aliquotaList;
	private List <ItemEstoqueVO> itemEstoqueList;
	private List <SituacaoTributariaVO> situacaoTributariaIcmsList;
	private List <UnidadeNfeVO> unidadeNfeList;
	private List <NfeIcmsOrigemMercadoriaEJB> origemMercadoriaIcmsList;
	private List <NfeIcmsModBcIcmsEJB> modalidadeBaseCalculoIcmsList;
	private List <NfeIcmsModBcIcmsStEJB> modalidadeBaseCalculoIcmsStList;
	private List<NfeIcmsMotivoDesoneracaoEJB> motivoDesoneracaoIcmsList; 
	private List <NfeCofinsCstEJB> situacaoTributariaCofinsList;
	private List <NfePisCstEJB> situacaoTributariaPisList;
	private List <NfeIpiCstEJB> situacaoTributariaIpiList;
	private List <EstadoNfeVO> estadosNfeList;
	private boolean ehAlteracao;
	private boolean exibeImpostos;
	
	//Ficha técnica
	
	private Long idItem;
	private Double quantidade;
	private Long indice;
	private Double vlUnitario;
	private Double vlTotal;
	
	private Double valorBaseCalculoIcms;
	private Double aliquotaIcms;
	private Double valorIcms;
	private Double valorCredIcms123;
	private Double valorIcmsDiferido;
	private Double valorBaseCalculoIcmsSt;
	private Double valorIcmsSt;
	private Double valorBaseCalculoCofins;
	private Double valorBaseCalculoCofinsSt;
	private Double valorCofins;
	private Double valorCofinsSt;
	private Double valorBaseCalculoPis;
	private Double valorBaseCalculoPisSt;
	private Double valorBaseCalculoII;
	private Double valorBaseCalculoIpi;
	
	private String regimeTributario;
	private String regimeTributarioSt;
	private String regimeTributarioCofins;
	private String regimeTributarioPis;
	private String regimeTributarioII;
	private String regimeTributarioIpi;
	
	public PratoAction (){
		entidade = new PratoEJB();
		entidadeIcms = new NfeIcmsCadastroEJB();
		entidadeCofins = new NfeCofinsCadastroEJB();
		entidadeCofinsSt = new NfeCofinsCadastroStEJB();
		entidadePis = new NfePisCadastroEJB();
		entidadePisSt = new NfePisCadastroStEJB();
		entidadeII = new NfeIICadastroEJB();
		entidadeIpi = new NfeIpiCadastroEJB();
		filtro = new PratoVO();
		grupoPratoList = Collections.emptyList();
		tipoItemList = Collections.emptyList();
		fiscalCodigoList = Collections.emptyList();
		fiscalIncidenciaList = Collections.emptyList();
		aliquotaList = Collections.emptyList();
		itemEstoqueList = Collections.emptyList();
		situacaoTributariaIcmsList = Collections.emptyList();
		origemMercadoriaIcmsList = Collections.emptyList();
		modalidadeBaseCalculoIcmsList = Collections.emptyList();
		motivoDesoneracaoIcmsList = Collections.emptyList();
		situacaoTributariaCofinsList = Collections.emptyList();
		situacaoTributariaPisList = Collections.emptyList();
		situacaoTributariaIpiList = Collections.emptyList();
		unidadeNfeList = Collections.emptyList();
		estadosNfeList = Collections.emptyList();
	}
	
	private void initCombo() throws MozartSessionException {
		HotelEJB hotel = getHotelCorrente();
		
		grupoPratoList = CustoDelegate.instance().obterGrupoPrato(hotel);
		tipoItemList  = CustoDelegate.instance().obterTipoItem(hotel);
		fiscalCodigoList  = CustoDelegate.instance().obterFiscalCodigo(hotel);
		fiscalIncidenciaList  = CustoDelegate.instance().obterFiscalIncidencias();
		aliquotaList = CustoDelegate.instance().obterAliquota();
		situacaoTributariaIcmsList = NfeDelegate.instance().obterSituacaoTributariaIcms(hotel);
		origemMercadoriaIcmsList = NfeDelegate.instance().obterOrigemMercadoriaIcms();
		modalidadeBaseCalculoIcmsList = NfeDelegate.instance().obterModalidadeBaseCalculoIcms();
		modalidadeBaseCalculoIcmsStList = NfeDelegate.instance().obterModalidadeBaseCalculoIcmsSt();
		motivoDesoneracaoIcmsList = NfeDelegate.instance().obterMotivoDesoneracaoIcms();
		situacaoTributariaCofinsList = NfeDelegate.instance().obterSituacaoTributariaCofins();
		situacaoTributariaPisList = NfeDelegate.instance().obterSituacaoTributariaPis();
		situacaoTributariaIpiList = NfeDelegate.instance().obterSituacaoTributariaIpi();
		unidadeNfeList = NfeDelegate.instance().obterListaUnidadesNfe();
		estadosNfeList = NfeDelegate.instance().obterListaEstadosNfe();
		
		if(hotel.getIdPrograma() == 1 || hotel.getIdPrograma() == 11 || hotel.getIdPrograma() == 21 || hotel.getIdPrograma() == 31){
			exibeImpostos = true;
		}
		else{
			exibeImpostos = false;
		}
	}
	
	private void initComboFichaTecnica() throws MozartSessionException {
		ItemEstoqueVO filtro = new ItemEstoqueVO();
		filtro.setIdHoteis(getIdHoteis());
		filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		itemEstoqueList = CustoDelegate.instance().pesquisarItemEstoqueFichaTecnica(filtro);
	}
	
	public String excluirFichaTecnica() {
		PratoEJB entidadeSession = (PratoEJB)request.getSession().getAttribute(ENTIDADE_SESSION);
		entidadeSession.getFichaTecnicaPratoEJBList().remove(indice.intValue());
		try {
			initComboFichaTecnica();
			idItem = null;
			quantidade = null;
			vlUnitario = null;
			vlTotal = null;
			
		} catch(MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}
	
	public String incluirFichaTecnica(){
		prepararFichaTecnica();
		PratoEJB entidadeSession = (PratoEJB)request.getSession().getAttribute(ENTIDADE_SESSION);
		FichaTecnicaPratoEJB novoItem = new FichaTecnicaPratoEJB();
		FichaTecnicaPratoEJBPK id = new FichaTecnicaPratoEJBPK();
		id.setIdHotel(getHotelCorrente().getIdHotel());
		id.setIdItem(idItem);
		novoItem.setId(id);
		novoItem.setQuantidade(quantidade);
		novoItem.setValorUnitario(vlUnitario);
		novoItem.setValorTotal(vlTotal);
		ItemEstoqueVO item = new ItemEstoqueVO();
		ItemRedeEJB itemRede = new ItemRedeEJB();
		item.setIdItem(idItem); 
		item = itemEstoqueList.get(itemEstoqueList.indexOf(item));
		ItemEstoqueEJB itemEJB = new ItemEstoqueEJB();
		ItemEstoqueEJBPK idItem = new ItemEstoqueEJBPK();
		id.setIdItem( item.getIdItem() );
		idItem.setIdHotel(getHotelCorrente().getIdHotel());
		itemEJB.setId( idItem );
		itemRede.setNomeItem(item.getNomeItem());
		itemRede.setId(new ItemRedeEJBPK());
		itemRede.getId().setIdItem(item.getIdItem());
		itemRede.getId().setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		itemEJB.setItemRedeEJB(itemRede);
		novoItem.setItemEstoqueEJB(itemEJB);
		if(MozartUtil.isNull(entidadeSession.getFichaTecnicaPratoEJBList()))
			entidadeSession.setFichaTecnicaPratoEJBList(new ArrayList<FichaTecnicaPratoEJB>());
		entidadeSession.getFichaTecnicaPratoEJBList().add(novoItem);
		
		idItem = null;
		quantidade = null;
		vlUnitario = null;
		vlTotal = null;
		
		return SUCESSO_FORWARD;
	}
	
	public String prepararFichaTecnica() {
		try {
			initComboFichaTecnica();
			
		} catch (MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}
	
	private void initValues() throws MozartSessionException{
		HotelEJB hotel = getHotelCorrente();
		
		regimeTributario = NfeDelegate.instance().obterRegimeTributario(hotel);
		regimeTributarioSt = regimeTributario;
		regimeTributarioCofins = regimeTributario;
		regimeTributarioPis = regimeTributario; 
		regimeTributarioII = regimeTributario;
		regimeTributarioIpi = regimeTributario;
	}	
	
	public String prepararInclusao(){
		try {
			ehAlteracao = false;
			entidade.setId(null);
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			initCombo();
			initValues();
			
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
			ehAlteracao = true;
			initCombo();
			initComboFichaTecnica();
			initValues();
			entidade.getId().setIdHotel(getIdHoteis()[0]);
			entidade=(PratoEJB) CheckinDelegate.instance().obter(PratoEJB.class, entidade.getId());
			entidadeIcms = NfeDelegate.instance().obterIcmsCadastro(getHotelCorrente(), entidade);
			entidadeCofins = NfeDelegate.instance().obterCofinsCadastro(getHotelCorrente(), entidade);
			entidadeCofinsSt = NfeDelegate.instance().obterCofinsCadastroSt(getHotelCorrente(), entidade);
			entidadeII = NfeDelegate.instance().obterIICadastro(getHotelCorrente(), entidade);
			entidadePis = NfeDelegate.instance().obterPisCadastro(getHotelCorrente(), entidade);
			entidadePisSt = NfeDelegate.instance().obterPisCadastroSt(getHotelCorrente(), entidade);
			entidadeIpi = NfeDelegate.instance().obterIpiCadastro(getHotelCorrente(), entidade);
			
			for(FichaTecnicaPratoEJB f: entidade.getFichaTecnicaPratoEJBList()){
				for(ItemEstoqueVO i: itemEstoqueList)
					if(f.getId().getIdItem() == i.getIdItem().longValue()){
						f.setValorUnitario(i.getVlUnitario());
						f.setValorTotal(f.getQuantidade().doubleValue() * f.getValorUnitario().doubleValue());
						break;
					}
			}
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD;
	}
	
	public String gravarPrato() {
		try { 
			entidade.getId().setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setUsuario(getUsuario());
			initCombo();
			initValues();
			PratoEJB pratoSession = (PratoEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			
			entidade.setFichaTecnicaPratoEJBList( pratoSession.getFichaTecnicaPratoEJBList() );
			
			PratoEJB prato = CustoDelegate.instance().gravarProduto(entidade);

			entidadeIcms.setPratoEJB(prato);
			entidadeIcms.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarIcms(entidadeIcms);
			
			entidadeCofins.setPratoEJB(prato);
			entidadeCofins.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarCofins(entidadeCofins);
			
			entidadeCofinsSt.setPratoEJB(prato);
			entidadeCofinsSt.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarCofinsSt(entidadeCofinsSt);
			
			entidadePis.setPratoEJB(prato);
			entidadePis.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarPis(entidadePis);
			
			entidadePisSt.setPratoEJB(prato);
			entidadePisSt.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarPisSt(entidadePisSt);
			
			entidadeII.setPratoEJB(prato);
			entidadeII.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarII(entidadeII);
			
			entidadeIpi.setPratoEJB(prato);
			entidadeIpi.setHotel(getHotelCorrente());
			
			if(!MozartUtil.isNull(entidadeIpi.getNfeIpiCst()) && !MozartUtil.isNull(entidadeIpi.getNfeIpiCst().getIdNfeIpiCst())){
				NfeDelegate.instance().gravarIpi(entidadeIpi);
			}
			
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new PratoEJB();
			entidadeIcms = new NfeIcmsCadastroEJB();
			entidadeCofins = new NfeCofinsCadastroEJB();
			entidadeCofinsSt = new NfeCofinsCadastroStEJB();
			entidadePis = new NfePisCadastroEJB();
			entidadePisSt = new NfePisCadastroStEJB();
			entidadeII = new NfeIICadastroEJB();
			entidadeIpi = new NfeIpiCadastroEJB();
			
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD; 
	}
	
	public String gravarImpostos() {
		try { 
			entidade.getId().setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setUsuario(getUsuario());
			initCombo();
			PratoEJB prato = (PratoEJB) request.getSession().getAttribute(ENTIDADE_SESSION);

			entidadeIcms.setPratoEJB(prato);
			entidadeIcms.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarIcms(entidadeIcms);
			
			entidadeCofins.setPratoEJB(prato);
			entidadeCofins.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarCofins(entidadeCofins);
			
			entidadeCofinsSt.setPratoEJB(prato);
			entidadeCofinsSt.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarCofinsSt(entidadeCofinsSt);
			
			entidadePis.setPratoEJB(prato);
			entidadePis.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarPis(entidadePis);
			
			entidadePisSt.setPratoEJB(prato);
			entidadePisSt.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarPisSt(entidadePisSt);
			
			entidadeII.setPratoEJB(prato);
			entidadeII.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarII(entidadeII);
			
			entidadeIpi.setPratoEJB(prato);
			entidadeIpi.setHotel(getHotelCorrente());
			
			NfeDelegate.instance().gravarIpi(entidadeIpi);
			
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new PratoEJB();
			entidadeIcms = new NfeIcmsCadastroEJB();
			entidadeCofins = new NfeCofinsCadastroEJB();
			entidadeCofinsSt = new NfeCofinsCadastroStEJB();
			entidadePis = new NfePisCadastroEJB();
			entidadePisSt = new NfePisCadastroStEJB();
			entidadeII = new NfeIICadastroEJB();
			entidadeIpi = new NfeIpiCadastroEJB();
			
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD; 
	}
	
	public String pesquisar(){
		try {
			filtro.setIdHoteis(getIdHoteis());
			List<PratoVO> lista = CustoDelegate.instance().pesquisarPrato(filtro);
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

	public PratoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(PratoVO filtro) {
		this.filtro = filtro;
	}

	public PratoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(PratoEJB entidade) {
		this.entidade = entidade;
	}

	public List<NfeIcmsOrigemMercadoriaEJB> getOrigemMercadoriaIcmsList() {
		return origemMercadoriaIcmsList;
	}

	public void setOrigemMercadoriaIcmsList(
			List<NfeIcmsOrigemMercadoriaEJB> origemMercadoriaIcmsList) {
		this.origemMercadoriaIcmsList = origemMercadoriaIcmsList;
	}

	public NfeIcmsCadastroEJB getEntidadeIcms() {
		return entidadeIcms;
	}

	public void setEntidadeIcms(NfeIcmsCadastroEJB entidadeIcms) {
		this.entidadeIcms = entidadeIcms;
	}

	public List<SituacaoTributariaVO> getSituacaoTributariaIcmsList() {
		return situacaoTributariaIcmsList;
	}

	public void setSituacaoTributariaIcmsList(
			List<SituacaoTributariaVO> situacaoTributariaIcmsList) {
		this.situacaoTributariaIcmsList = situacaoTributariaIcmsList;
	}

	public List<GrupoPratoEJB> getGrupoPratoList() {
		return grupoPratoList;
	}

	public void setGrupoPratoList(List<GrupoPratoEJB> grupoPratoList) {
		this.grupoPratoList = grupoPratoList;
	}

	public List<TipoItemEJB> getTipoItemList() {
		return tipoItemList;
	}

	public void setTipoItemList(List<TipoItemEJB> tipoItemList) {
		this.tipoItemList = tipoItemList;
	}

	public List<FiscalCodigoEJB> getFiscalCodigoList() {
		return fiscalCodigoList;
	}

	public void setFiscalCodigoList(List<FiscalCodigoEJB> fiscalCodigoList) {
		this.fiscalCodigoList = fiscalCodigoList;
	}

	public List<FiscalIncidenciaEJB> getFiscalIncidenciaList() {
		return fiscalIncidenciaList;
	}

	public void setFiscalIncidenciaList(
			List<FiscalIncidenciaEJB> fiscalIncidenciaList) {
		this.fiscalIncidenciaList = fiscalIncidenciaList;
	}

	public List<AliquotaEJB> getAliquotaList() {
		return aliquotaList;
	}

	public void setAliquotaList(List<AliquotaEJB> aliquotaList) {
		this.aliquotaList = aliquotaList;
	}

	public List<ItemEstoqueVO> getItemEstoqueList() {
		return itemEstoqueList;
	}

	public void setItemEstoqueList(List<ItemEstoqueVO> itemEstoqueList) {
		this.itemEstoqueList = itemEstoqueList;
	}

	public Long getIdItem() {
		return idItem;
	}

	public void setIdItem(Long idItem) {
		this.idItem = idItem;
	}

	public Double getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(Double quantidade) {
		this.quantidade = quantidade;
	}

	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public Double getVlUnitario() {
		return vlUnitario;
	}

	public void setVlUnitario(Double vlUnitario) {
		this.vlUnitario = vlUnitario;
	}

	public Double getVlTotal() {
		return vlTotal;
	}

	public void setVlTotal(Double vlTotal) {
		this.vlTotal = vlTotal;
	}
	
	public EnumCstB[] getTabelaB(){
		return EnumCstB.values();
	}
	public EnumCstA[] getTabelaA(){
		return EnumCstA.values();
	}

	public List<NfeIcmsModBcIcmsEJB> getModalidadeBaseCalculoIcmsList() {
		return modalidadeBaseCalculoIcmsList;
	}

	public void setModalidadeBaseCalculoIcmsList(
			List<NfeIcmsModBcIcmsEJB> modalidadeBaseCalculoIcmsList) {
		this.modalidadeBaseCalculoIcmsList = modalidadeBaseCalculoIcmsList;
	}

	public List<NfeIcmsMotivoDesoneracaoEJB> getMotivoDesoneracaoIcmsList() {
		return motivoDesoneracaoIcmsList;
	}

	public void setMotivoDesoneracaoIcmsList(
			List<NfeIcmsMotivoDesoneracaoEJB> motivoDesoneracaoIcmsList) {
		this.motivoDesoneracaoIcmsList = motivoDesoneracaoIcmsList;
	}

	public String getRegimeTributario() {
		return regimeTributario;
	}

	public void setRegimeTributario(String regimeTributario) {
		this.regimeTributario = regimeTributario;
	}

	public String getRegimeTributarioSt() {
		return regimeTributarioSt;
	}

	public void setRegimeTributarioSt(String regimeTributarioSt) {
		this.regimeTributarioSt = regimeTributarioSt;
	}

	public String getRegimeTributarioCofins() {
		return regimeTributarioCofins;
	}

	public void setRegimeTributarioCofins(String regimeTributarioCofins) {
		this.regimeTributarioCofins = regimeTributarioCofins;
	}

	public NfeCofinsCadastroEJB getEntidadeCofins() {
		return entidadeCofins;
	}

	public void setEntidadeCofins(NfeCofinsCadastroEJB entidadeCofins) {
		this.entidadeCofins = entidadeCofins;
	}

	public NfeCofinsCadastroStEJB getEntidadeCofinsSt() {
		return entidadeCofinsSt;
	}

	public void setEntidadeCofinsSt(NfeCofinsCadastroStEJB entidadeCofinsSt) {
		this.entidadeCofinsSt = entidadeCofinsSt;
	}

	public List<NfeCofinsCstEJB> getSituacaoTributariaCofinsList() {
		return situacaoTributariaCofinsList;
	}

	public void setSituacaoTributariaCofinsList(
			List<NfeCofinsCstEJB> situacaoTributariaCofinsList) {
		this.situacaoTributariaCofinsList = situacaoTributariaCofinsList;
	}

	public NfePisCadastroEJB getEntidadePis() {
		return entidadePis;
	}

	public void setEntidadePis(NfePisCadastroEJB entidadePis) {
		this.entidadePis = entidadePis;
	}

	public NfePisCadastroStEJB getEntidadePisSt() {
		return entidadePisSt;
	}

	public void setEntidadePisSt(NfePisCadastroStEJB entidadePisSt) {
		this.entidadePisSt = entidadePisSt;
	}

	public List<NfePisCstEJB> getSituacaoTributariaPisList() {
		return situacaoTributariaPisList;
	}

	public void setSituacaoTributariaPisList(
			List<NfePisCstEJB> situacaoTributariaPisList) {
		this.situacaoTributariaPisList = situacaoTributariaPisList;
	}

	public String getRegimeTributarioPis() {
		return regimeTributarioPis;
	}

	public void setRegimeTributarioPis(String regimeTributarioPis) {
		this.regimeTributarioPis = regimeTributarioPis;
	}

	public NfeIICadastroEJB getEntidadeII() {
		return entidadeII;
	}

	public void setEntidadeII(NfeIICadastroEJB entidadeII) {
		this.entidadeII = entidadeII;
	}

	public String getRegimeTributarioII() {
		return regimeTributarioII;
	}

	public void setRegimeTributarioII(String regimeTributarioII) {
		this.regimeTributarioII = regimeTributarioII;
	}

	public NfeIpiCadastroEJB getEntidadeIpi() {
		return entidadeIpi;
	}

	public void setEntidadeIpi(NfeIpiCadastroEJB entidadeIpi) {
		this.entidadeIpi = entidadeIpi;
	}

	public List<NfeIpiCstEJB> getSituacaoTributariaIpiList() {
		return situacaoTributariaIpiList;
	}

	public void setSituacaoTributariaIpiList(
			List<NfeIpiCstEJB> situacaoTributariaIpiList) {
		this.situacaoTributariaIpiList = situacaoTributariaIpiList;
	}

	public String getRegimeTributarioIpi() {
		return regimeTributarioIpi;
	}

	public void setRegimeTributarioIpi(String regimeTributarioIpi) {
		this.regimeTributarioIpi = regimeTributarioIpi;
	}

	public List<NfeIcmsModBcIcmsStEJB> getModalidadeBaseCalculoIcmsStList() {
		return modalidadeBaseCalculoIcmsStList;
	}

	public void setModalidadeBaseCalculoIcmsStList(
			List<NfeIcmsModBcIcmsStEJB> modalidadeBaseCalculoIcmsStList) {
		this.modalidadeBaseCalculoIcmsStList = modalidadeBaseCalculoIcmsStList;
	}

	public boolean isEhAlteracao() {
		return ehAlteracao;
	}

	public void setEhAlteracao(boolean ehAlteracao) {
		this.ehAlteracao = ehAlteracao;
	}

	public Double getValorBaseCalculoIcms() {
		return valorBaseCalculoIcms;
	}

	public void setValorBaseCalculoIcms(Double valorBaseCalculoIcms) {
		this.valorBaseCalculoIcms = valorBaseCalculoIcms;
	}

	public Double getAliquotaIcms() {
		return aliquotaIcms;
	}

	public void setAliquotaIcms(Double aliquotaIcms) {
		this.aliquotaIcms = aliquotaIcms;
	}

	public Double getValorIcms() {
		return valorIcms;
	}

	public void setValorIcms(Double valorIcms) {
		this.valorIcms = valorIcms;
	}

	public Double getValorCredIcms123() {
		return valorCredIcms123;
	}

	public void setValorCredIcms123(Double valorCredIcms123) {
		this.valorCredIcms123 = valorCredIcms123;
	}

	public Double getValorIcmsDiferido() {
		return valorIcmsDiferido;
	}

	public void setValorIcmsDiferido(Double valorIcmsDiferido) {
		this.valorIcmsDiferido = valorIcmsDiferido;
	}

	public Double getValorBaseCalculoIcmsSt() {
		return valorBaseCalculoIcmsSt;
	}

	public void setValorBaseCalculoIcmsSt(Double valorBaseCalculoIcmsSt) {
		this.valorBaseCalculoIcmsSt = valorBaseCalculoIcmsSt;
	}

	public Double getValorIcmsSt() {
		return valorIcmsSt;
	}

	public void setValorIcmsSt(Double valorIcmsSt) {
		this.valorIcmsSt = valorIcmsSt;
	}

	public Double getValorBaseCalculoCofins() {
		return valorBaseCalculoCofins;
	}

	public void setValorBaseCalculoCofins(Double valorBaseCalculoCofins) {
		this.valorBaseCalculoCofins = valorBaseCalculoCofins;
	}

	public Double getValorBaseCalculoCofinsSt() {
		return valorBaseCalculoCofinsSt;
	}

	public void setValorBaseCalculoCofinsSt(Double valorBaseCalculoCofinsSt) {
		this.valorBaseCalculoCofinsSt = valorBaseCalculoCofinsSt;
	}

	public Double getValorCofins() {
		return valorCofins;
	}

	public void setValorCofins(Double valorCofins) {
		this.valorCofins = valorCofins;
	}

	public Double getValorCofinsSt() {
		return valorCofinsSt;
	}

	public void setValorCofinsSt(Double valorCofinsSt) {
		this.valorCofinsSt = valorCofinsSt;
	}

	public Double getValorBaseCalculoPis() {
		return valorBaseCalculoPis;
	}

	public void setValorBaseCalculoPis(Double valorBaseCalculoPis) {
		this.valorBaseCalculoPis = valorBaseCalculoPis;
	}

	public Double getValorBaseCalculoPisSt() {
		return valorBaseCalculoPisSt;
	}

	public void setValorBaseCalculoPisSt(Double valorBaseCalculoPisSt) {
		this.valorBaseCalculoPisSt = valorBaseCalculoPisSt;
	}

	public Double getValorBaseCalculoII() {
		return valorBaseCalculoII;
	}

	public void setValorBaseCalculoII(Double valorBaseCalculoII) {
		this.valorBaseCalculoII = valorBaseCalculoII;
	}

	public Double getValorBaseCalculoIpi() {
		return valorBaseCalculoIpi;
	}

	public void setValorBaseCalculoIpi(Double valorBaseCalculoIpi) {
		this.valorBaseCalculoIpi = valorBaseCalculoIpi;
	}

	public boolean isExibeImpostos() {
		return exibeImpostos;
	}

	public void setExibeImpostos(boolean exibeImpostos) {
		this.exibeImpostos = exibeImpostos;
	}

	public List<UnidadeNfeVO> getUnidadeNfeList() {
		return unidadeNfeList;
	}

	public void setUnidadeNfeList(List<UnidadeNfeVO> unidadeNfeList) {
		this.unidadeNfeList = unidadeNfeList;
	}

	public List<EstadoNfeVO> getEstadosNfeList() {
		return estadosNfeList;
	}

	public void setEstadosNfeList(List<EstadoNfeVO> estadosNfeList) {
		this.estadosNfeList = estadosNfeList;
	}
	
}
	
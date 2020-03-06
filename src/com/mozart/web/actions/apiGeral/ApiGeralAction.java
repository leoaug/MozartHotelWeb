package com.mozart.web.actions.apiGeral;

import java.util.List;
import java.util.ArrayList;

import com.mozart.model.delegate.ApiContratoDelegate;
import com.mozart.model.delegate.ApiGeralDelegate;
import com.mozart.model.delegate.ApiVendedorDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.HotelDelegate;
import com.mozart.model.ejb.entity.ApiContratoEJB;
import com.mozart.model.ejb.entity.ApiGeralEJB;
import com.mozart.model.ejb.entity.ApiVendedorEJB;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApiGeralVO;
import com.mozart.model.vo.EmpresaVO;
import com.mozart.model.vo.HotelVO;
import com.mozart.model.vo.TipoLancamentoVO;
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
	
	
	private HotelVO hotelContrato;
	private HotelVO hotelVendedor;
	
	private List <HotelVO> listaHoteis;
	
	private List <TipoLancamentoVO> listaRecebimento;
	private TipoLancamentoVO tipoLancamentoRecebimento;
	
	private List <TipoLancamentoVO> listaReceita;
	private TipoLancamentoVO tipoLancamentoReceita;
	
	private List <EmpresaEJB> listaEmpresas;
	
	private Long indice;

	
	private String razaoSocial;
	private Long idEmpresa;

	
	public ApiGeralAction() throws MozartSessionException{
		filtro = new ApiGeralVO();
		entidade = new ApiGeralEJB();
		tipoLancamentoRecebimento = new TipoLancamentoVO();
		tipoLancamentoReceita = new TipoLancamentoVO();
		hotelContrato = new HotelVO();
		hotelVendedor = new HotelVO();
		
		
		this.listaHoteis = HotelDelegate.instance().consultarHoteisAtivos();
		
		
		this.listaRecebimento = new ArrayList<TipoLancamentoVO>();
		this.listaReceita = new ArrayList<TipoLancamentoVO>();
		
		
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
	
			 int index = entidade.getEmpresa().getRazaoSocialCGC().indexOf("-");
			
			String CGC = entidade.getEmpresa().getRazaoSocialCGC().substring(0, index);
			String razaoSocial = entidade.getEmpresa().getRazaoSocialCGC().substring(index + 1, entidade.getEmpresa().getRazaoSocialCGC().length());
			
			EmpresaVO vo = new EmpresaVO();
			vo.setCnpj(CGC.trim());
			vo.setRazaoSocial(razaoSocial.trim());
			entidade.setNome("API_GERAL");
			entidade.setAtivo("S");
			entidade.setEmpresa(EmpresaDelegate.instance().obterEmpresaPorNomeCnpj(vo));			
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			//salvando o API- GERAL
			entidade = ApiGeralDelegate.instance().gravarApiGeral( entidade );
			
			//salvando o API CONTRATO
			if(entidade.getIdApiGeral() != null && 
			  apiContrato.getHotel().getIdHotel() != null && 
			  (apiContrato.getIdTipoLancamento() != null && !apiContrato.getIdTipoLancamento().equals(0)) &&
			  (apiContrato.getIdTipoLancamentoCk() != null && !apiContrato.getIdTipoLancamentoCk().equals(0))) {
				
				apiContrato.setApiGeral(entidade);
				apiContrato.setNome("CONTRATO");
				apiContrato.setAtivo("S");
				if(apiContrato.getIdTipoLancamentoCk().equals((long)0)) {
					apiContrato.setIdTipoLancamentoCk(apiContrato.getIdTipoLancamento());
				}
				apiContrato.setHotel(HotelDelegate.instance().consultarHotelPorId(apiContrato.getHotel().getIdHotel()));
				apiContrato.setUsuario( getUserSession().getUsuarioEJB() );
				ApiContratoDelegate.instance().gravarApiContrato(apiContrato);
			} 
			
			//Salvando o API VENDEDOR
			if(entidade.getIdApiGeral() != null && apiVendedor.getHotel() != null  && apiVendedor.getHotel().getIdHotel() != null) {
				
				apiVendedor.setApiGeral(entidade);
				apiVendedor.setNome("VENDEDOR");
				apiVendedor.setAtivo("S");
				apiVendedor.setHotel(HotelDelegate.instance().consultarHotelPorId(apiVendedor.getHotel().getIdHotel()));
				apiVendedor.setUsuario( getUserSession().getUsuarioEJB() );
				ApiVendedorDelegate.instance().gravarApiVendedor(apiVendedor);
			}
			
			
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
		
		request.getSession().setAttribute("listaRecebimento", this.listaRecebimento);
		request.getSession().setAttribute("listaReceita", this.listaReceita);
		
		this.listaEmpresas = new ArrayList <EmpresaEJB> ();

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
	
	
	public List<TipoLancamentoVO> getListaRecebimento() {
		return listaRecebimento;
	}
	public void setListaRecebimento(List<TipoLancamentoVO> listaRecebimento) {
		this.listaRecebimento = listaRecebimento;
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
	public List<HotelVO> getListaHoteis() {
		return listaHoteis;
	}
	public void setListaHoteis(List<HotelVO> listaHoteis) {
		this.listaHoteis = listaHoteis;
	}
	public TipoLancamentoVO getTipoLancamentoRecebimento() {
		return tipoLancamentoRecebimento;
	}
	public void setTipoLancamentoRecebimento(TipoLancamentoVO tipoLancamentoRecebimento) {
		this.tipoLancamentoRecebimento = tipoLancamentoRecebimento;
	}
	public List<TipoLancamentoVO> getListaReceita() {
		return listaReceita;
	}
	public void setListaReceita(List<TipoLancamentoVO> listaReceita) {
		this.listaReceita = listaReceita;
	}
	public TipoLancamentoVO getTipoLancamentoReceita() {
		return tipoLancamentoReceita;
	}
	public void setTipoLancamentoReceita(TipoLancamentoVO tipoLancamentoReceita) {
		this.tipoLancamentoReceita = tipoLancamentoReceita;
	}
	public HotelVO getHotelContrato() {
		return hotelContrato;
	}
	public void setHotelContrato(HotelVO hotelContrato) {
		this.hotelContrato = hotelContrato;
	}
	public HotelVO getHotelVendedor() {
		return hotelVendedor;
	}
	public void setHotelVendedor(HotelVO hotelVendedor) {
		this.hotelVendedor = hotelVendedor;
	}
	public List<EmpresaEJB> getListaEmpresas() {
		return listaEmpresas;
	}
	public void setListaEmpresas(List<EmpresaEJB> listaEmpresas) {
		this.listaEmpresas = listaEmpresas;
	}
	public String getRazaoSocial() {
		return razaoSocial;
	}
	public void setRazaoSocial(String razaoSocial) {
		this.razaoSocial = razaoSocial;
	}
	public Long getIdEmpresa() {
		return idEmpresa;
	}
	public void setIdEmpresa(Long idEmpresa) {
		this.idEmpresa = idEmpresa;
	}
	

	
	
	
}
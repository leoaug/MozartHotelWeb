package com.mozart.web.actions.comercial;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.IdiomaMozartEJB;
import com.mozart.model.ejb.entity.MoedaEJB;
import com.mozart.model.ejb.entity.TarifaApartamentoEJB;
import com.mozart.model.ejb.entity.TarifaEJB;
import com.mozart.model.ejb.entity.TarifaIdiomaEJB;
import com.mozart.model.ejb.entity.TipoApartamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.TarifaGrupoVO;
import com.mozart.model.vo.TarifaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class TarifaAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 104005275043849595L;
	
	private TarifaEJB entidade;
	private TarifaVO filtro;
	
	private Long[] idTipoApartamento;
	private Long[] idIdioma;
	private String[] descricaoTarifaIdioma;
	private Double[] tarifas;
	private String intervalos;
	
	private String descricaoIdioma0, descricaoIdioma1, descricaoIdioma2;
	
	private String domingo, segunda, terca, quarta, quinta, sexta, sabado, todos;
	
	private String scriptCalendario;
	
	public TarifaAction(){
		filtro = new TarifaVO();
		
	}
	
	
	public String prepararRelatorio(){
		return SUCESSO_FORWARD;
	}
	public String prepararPesquisa(){
		request.setAttribute("filtro.filtroAtivo.tipoIntervalo", "S");
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando Tarifa");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdHoteis(getIdHoteis());
			List<TarifaVO> listaPesquisa = ComercialDelegate.instance().pesquisarTarifa(filtro);
			if (MozartUtil.isNull(listaPesquisa)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
				return SUCESSO_FORWARD;
			}
			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
			return SUCESSO_FORWARD;
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			return SUCESSO_FORWARD;
		}
	}

	@SuppressWarnings("unchecked")
	private void init() throws MozartSessionException{
		
		List<MozartComboWeb> tipo = new ArrayList<MozartComboWeb>();
		tipo.add( new MozartComboWeb("A","Acordo"));
		tipo.add( new MozartComboWeb("P","Pacote"));
		tipo.add( new MozartComboWeb("E","Promocional"));
		tipo.add( new MozartComboWeb("I","Internet"));
		tipo.add( new MozartComboWeb("B","Balcão"));
		tipo.add( new MozartComboWeb("W","Web promocional"));
		request.getSession().setAttribute("LISTA_TIPO_TARIFA", tipo);
		
		
		List<MoedaEJB> listaMoeda = CheckinDelegate.instance().pesquisarMoeda();
		request.getSession().setAttribute("LISTA_MOEDA", listaMoeda);
		
		TarifaGrupoVO filtro = new TarifaGrupoVO();
		filtro.setIdHotel( getIdHoteis()[0]);
		filtro.setIdHoteis( getIdHoteis() );
		filtro.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		List<TarifaGrupoVO> listaGrupoTarifa = ComercialDelegate.instance().pesquisarTarifaGrupo(filtro);
		request.getSession().setAttribute("LISTA_GRUPO_TARIFA", listaGrupoTarifa);
		todos = "S";
		domingo = "0";
		segunda = "1";
		terca = "2";
		quarta="3";
		quinta = "4";
		sexta="5";
		sabado = "6";
		
		descricaoIdioma0 = null;
		descricaoIdioma1 = null;
		descricaoIdioma2 = null;
		
		TipoApartamentoEJB tipoApto = new TipoApartamentoEJB();
		tipoApto.setIdHotel( getIdHoteis()[0]);
		List<TipoApartamentoEJB> tipoApartamento = CheckinDelegate.instance().obterTipoApartamento( tipoApto );
		request.getSession().setAttribute("LISTA_TIPO_APTO", tipoApartamento);
		
		tarifas = new Double[ tipoApartamento.size() * 8];
		for (int x=0;x< tarifas.length; x++){
			tarifas[x] = new Double(0);	
		}
		
		List<IdiomaMozartEJB> listaTarifaIdioma = ComercialDelegate.instance().pesquisarIdioma( null );
		
		descricaoTarifaIdioma = new String[listaTarifaIdioma.size()];
		if (!MozartUtil.isNull( entidade.getTarifaIdiomaList() )){
			List<TarifaIdiomaEJB> lista = entidade.getTarifaIdiomaList();
			Collections.sort( lista, TarifaIdiomaEJB.getComparator());
			request.getSession().setAttribute("LISTA_TARIFA_IDIOMA", lista);
			descricaoTarifaIdioma = new String[lista.size()];
			int x=0;
			for(TarifaIdiomaEJB linha: lista){
				descricaoTarifaIdioma[x++] = linha.getDescricaoWeb();
				
			}
			
			descricaoIdioma0 = lista.get(0).getDescricaoWeb();
			descricaoIdioma1 = lista.get(1).getDescricaoWeb();
			descricaoIdioma2 = lista.get(2).getDescricaoWeb();
		}else{
			List<TarifaIdiomaEJB> listaTarifa = new ArrayList<TarifaIdiomaEJB>();
			for (IdiomaMozartEJB idoma : listaTarifaIdioma){
				TarifaIdiomaEJB tarifaIdioma = new TarifaIdiomaEJB();
				tarifaIdioma.setIdiomaMozart(idoma);
				listaTarifa.add(tarifaIdioma);
			}
			request.getSession().setAttribute("LISTA_TARIFA_IDIOMA", listaTarifa);
			
		}
		
		
		
	}
	
	public String prepararInclusao(){
		
		try{
			entidade = new TarifaEJB();
			entidade.setAtivo("S");
			entidade.setDataEntrada( getControlaData().getFrontOffice() );
			entidade.setDataSaida( MozartUtil.incrementarDia( entidade.getDataEntrada() ));
			init();
			return SUCESSO_FORWARD;
		}catch(Exception ex){
			addMensagemErro( MENSAGEM_ERRO );
			error( ex.getMessage() );
			return SUCESSO_FORWARD;
		}
	}
	

	@SuppressWarnings("unchecked")
	public String prepararAlteracao(){
		
		try{
			entidade = (TarifaEJB)CheckinDelegate.instance().obter(TarifaEJB.class, entidade.getIdTarifa() );
			init();
			
			
			List<TarifaApartamentoEJB> lista = entidade.getTarifaApartamentoList();
			Collections.sort( lista, TarifaApartamentoEJB.getComparator());
			entidade.setTarifaApartamentoList( lista );
			int x = 0;
			for (TarifaApartamentoEJB tar: lista){
				tarifas[x++] = tar.getPax1();
				tarifas[x++] = tar.getPax2();
				tarifas[x++] = tar.getPax3();
				tarifas[x++] = tar.getPax4();
				tarifas[x++] = tar.getPax5();
				tarifas[x++] = tar.getPax6();
				tarifas[x++] = tar.getPax7();
				tarifas[x++] = tar.getAdicional();
			}
			
			List<TarifaIdiomaEJB> listaTArIdioma = entidade.getTarifaIdiomaList();
			Collections.sort( listaTArIdioma, TarifaIdiomaEJB.getComparator());
			
			for (int y=0;y<listaTArIdioma.size();y++){
				descricaoTarifaIdioma[y] = listaTArIdioma.get( y ).getDescricaoWeb(); 
			}
			
			
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	private String montarScript(){
		
		String result = "";//"<script type='text/javascript'> \n";
		
		if ("0".equals( request.getParameter("domingo"))){
			result += " $('input:checkbox[name=\"domingo\"]').attr('checked',true); ";	
		}else{
			result += " $('input:checkbox[name=\"domingo\"]').attr('checked',false); ";
		}
		if ("1".equals( request.getParameter("segunda"))){
			result += " $('input:checkbox[name=\"segunda\"]').attr('checked',true); ";	
		}else{
			result += " $('input:checkbox[name=\"segunda\"]').attr('checked',false); ";
		}
		if ("2".equals( request.getParameter("terca"))){
			result += " $('input:checkbox[name=\"terca\"]').attr('checked',true); ";	
		}else{
			result += " $('input:checkbox[name=\"terca\"]').attr('checked',false); ";
		}
		if ("3".equals( request.getParameter("quarta"))){
			result += " $('input:checkbox[name=\"quarta\"]').attr('checked',true);";	
		}else{
			result += " $('input:checkbox[name=\"quarta\"]').attr('checked',false);";
		}
		if ("4".equals( request.getParameter("quinta"))){
			result += " $('input:checkbox[name=\"quinta\"]').attr('checked',true);";	
		}else{
			result += " $('input:checkbox[name=\"quinta\"]').attr('checked',false);";
		}
		if ("5".equals( request.getParameter("sexta"))){
			result += " $('input:checkbox[name=\"sexta\"]').attr('checked',true); ";	
		}else{
			result += " $('input:checkbox[name=\"sexta\"]').attr('checked',false); ";
		}
		if ("6".equals( request.getParameter("sabado"))){
			result += " $('input:checkbox[name=\"sabado\"]').attr('checked',true); ";	
		}else{
			result += " $('input:checkbox[name=\"sabado\"]').attr('checked',false); ";
		}
		if ("S".equals( request.getParameter("todos"))){
			result += " $('input:checkbox[name=\"todos\"]').attr('checked',true); ";	
		}else{
			result += " $('input:checkbox[name=\"todos\"]').attr('checked',false); ";
		}
		
		result += " habilitarLegenda('"+ entidade.getTipo() +"') ";
		
		//result += " pesquisar(); \n";
		//result += " </script> \n";
		return result;
		
	}
	
	@SuppressWarnings("unchecked")
	public String gravar(){
		
		try{
			request.setAttribute("scriptCalendario", montarScript());
			List<TarifaEJB> listaTarifa = new ArrayList<TarifaEJB>();
			String[] inter = intervalos.split(";");
			int x = 0;
			List<TarifaIdiomaEJB> listaIdioma = (List<TarifaIdiomaEJB>)request.getSession().getAttribute("LISTA_TARIFA_IDIOMA");
			for (String linha: inter){

				String dataInicial = linha.split("-")[0];
				String dataFinal = linha.split("-")[1];

				
				/*caso seja uma alteracao, alterar apenas a primeira e criar as novas*/
				TarifaEJB tarifa = new TarifaEJB();
				if (entidade.getIdTarifa() != null && x == 0){
					tarifa.setIdTarifa(entidade.getIdTarifa());
				}
				tarifa.setIdHotel( getIdHoteis()[0]);
				tarifa.setAtivo( entidade.getAtivo() );
				tarifa.setDataEntrada(MozartUtil.toTimestamp(dataInicial));
				tarifa.setDataSaida(MozartUtil.toTimestamp(dataFinal));
				
				tarifa.setDescricao( entidade.getDescricao() );
				if (x > 0){
					tarifa.setDescricao( entidade.getDescricao() + ": "+dataInicial+"-"+dataFinal );
				}
				tarifa.setIdMoeda( entidade.getIdMoeda() );
				tarifa.setObservacao( entidade.getObservacao() );
				tarifa.setTarifaGrupo( entidade.getTarifaGrupo() );
				if (tarifa.getTarifaGrupo()!=null && tarifa.getTarifaGrupo().getIdTarifaGrupo() == null){
					tarifa.setTarifaGrupo( null );
				}
				tarifa.setTipo( entidade.getTipo() );
				int inicio = 0;
				for (Long idTipoApto: idTipoApartamento){
					
					TarifaApartamentoEJB tarApto = new TarifaApartamentoEJB();
					TipoApartamentoEJB tipoApto = new TipoApartamentoEJB();
					tipoApto.setIdHotel(getIdHoteis()[0]);
					tipoApto.setIdTipoApartamento( idTipoApto );
					tarApto.getId().setIdHotel( getIdHoteis()[0] );
					tarApto.setTipoApartamento(tipoApto);
					
					tarApto.setPax1( tarifas[ inicio++] );
					tarApto.setPax2( tarifas[ inicio++] );	
					tarApto.setPax3( tarifas[ inicio++] );
					tarApto.setPax4( tarifas[ inicio++] );
					tarApto.setPax5( tarifas[ inicio++] );
					tarApto.setPax6( tarifas[ inicio++] );
					tarApto.setPax7( tarifas[ inicio++] );
					
					tarifa.addTarifaApartamento( tarApto );
				}
				x++;
				
				if ("P".equals(entidade.getTipo()) || "W".equals(entidade.getTipo())){
					int xx = 0;
					for(TarifaIdiomaEJB tarIdioma: listaIdioma){
						TarifaIdiomaEJB tarifaIdioma = new TarifaIdiomaEJB();
						tarifaIdioma.setIdiomaMozart( tarIdioma.getIdiomaMozart() );
						if (xx==0)
							tarifaIdioma.setDescricaoWeb( descricaoIdioma0 );
						else if (xx==1)
							tarifaIdioma.setDescricaoWeb( descricaoIdioma1 );
						else if (xx==2)
							tarifaIdioma.setDescricaoWeb( descricaoIdioma2 );
						xx++;
						tarifa.addTarifaIdioma(tarifaIdioma);
					
					}
				}
				
				listaTarifa.add( tarifa );
			}
			
			

			
			
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			
			ComercialDelegate.instance().gravarTarifa(entidade, listaTarifa);
			request.setAttribute("scriptCalendario", "");
			addMensagemSucesso( MSG_SUCESSO );
			
			return prepararInclusao();
			
		}catch(MozartValidateException ex){
			
			error(ex.getMessage());
			addMensagemErro( ex.getMessage() );
			return SUCESSO_FORWARD;
			
		}catch(Exception ex){
			
			error(ex.getMessage());
			addMensagemErro( MSG_ERRO );
			return SUCESSO_FORWARD;
			
		}
		
	}

	public TarifaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TarifaEJB entidade) {
		this.entidade = entidade;
	}

	public TarifaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(TarifaVO filtro) {
		this.filtro = filtro;
	}
	public Long[] getIdTipoApartamento() {
		return idTipoApartamento;
	}
	public void setIdTipoApartamento(Long[] idTipoApartamento) {
		this.idTipoApartamento = idTipoApartamento;
	}
	public Double[] getTarifas() {
		return tarifas;
	}
	public void setTarifas(Double[] tarifas) {
		this.tarifas = tarifas;
	}
	public String getIntervalos() {
		return intervalos;
	}
	public void setIntervalos(String intervalos) {
		this.intervalos = intervalos;
	}
	public String getDomingo() {
		return domingo;
	}
	public void setDomingo(String domingo) {
		this.domingo = domingo;
	}
	public String getSegunda() {
		return segunda;
	}
	public void setSegunda(String segunda) {
		this.segunda = segunda;
	}
	public String getTerca() {
		return terca;
	}
	public void setTerca(String terca) {
		this.terca = terca;
	}
	public String getQuarta() {
		return quarta;
	}
	public void setQuarta(String quarta) {
		this.quarta = quarta;
	}
	public String getQuinta() {
		return quinta;
	}
	public void setQuinta(String quinta) {
		this.quinta = quinta;
	}
	public String getSexta() {
		return sexta;
	}
	public void setSexta(String sexta) {
		this.sexta = sexta;
	}
	public String getSabado() {
		return sabado;
	}
	public void setSabado(String sabado) {
		this.sabado = sabado;
	}
	public String getTodos() {
		return todos;
	}
	public void setTodos(String todos) {
		this.todos = todos;
	}
	public String getScriptCalendario() {
		return scriptCalendario;
	}
	public void setScriptCalendario(String scriptCalendario) {
		this.scriptCalendario = scriptCalendario;
	}
	public Long[] getIdIdioma() {
		return idIdioma;
	}
	public void setIdIdioma(Long[] idIdioma) {
		this.idIdioma = idIdioma;
	}
	public String[] getDescricaoTarifaIdioma() {
		return descricaoTarifaIdioma;
	}
	public void setDescricaoTarifaIdioma(String[] descricaoTarifaIdioma) {
		this.descricaoTarifaIdioma = descricaoTarifaIdioma;
	}
	public String getDescricaoIdioma0() {
		return descricaoIdioma0;
	}
	public void setDescricaoIdioma0(String descricaoIdioma0) {
		this.descricaoIdioma0 = descricaoIdioma0;
	}
	public String getDescricaoIdioma1() {
		return descricaoIdioma1;
	}
	public void setDescricaoIdioma1(String descricaoIdioma1) {
		this.descricaoIdioma1 = descricaoIdioma1;
	}
	public String getDescricaoIdioma2() {
		return descricaoIdioma2;
	}
	public void setDescricaoIdioma2(String descricaoIdioma2) {
		this.descricaoIdioma2 = descricaoIdioma2;
	}


}

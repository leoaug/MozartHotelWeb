package com.mozart.web.actions.comercial;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.IdiomaMozartEJB;
import com.mozart.model.ejb.entity.NoticiaEJB;
import com.mozart.model.ejb.entity.NoticiaPK;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;

public class NoticiaAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -423415307774572275L;

	private NoticiaEJB entidade;
	
	private List<NoticiaEJB> entidades;
	
	private String[] titulo, resumo, noticia;
	private Long[] idioma;
	
	List<IdiomaMozartEJB> idiomaList;
	
	
	public NoticiaAction(){
		entidade = new NoticiaEJB(); 
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute( LISTA_PESQUISA );
		return SUCESSO_FORWARD;
	}

	public String pesquisar(){

		try{
			
			entidade.setIdHotel( getHotelCorrente().getIdHotel() );
			entidades = ComercialDelegate.instance().pesquisarNoticias( entidade );
			request.getSession().setAttribute(LISTA_PESQUISA, entidades);
			
			if (MozartUtil.isNull( entidades )){
				addMensagemSucesso( MSG_PESQUISA_VAZIA );
			} 
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	@SuppressWarnings("unchecked")
	public String prepararInclusao(){
		try{
			entidade = new NoticiaEJB();
			idiomaList = ComercialDelegate.instance().pesquisarIdioma( null );
			entidades = new ArrayList<NoticiaEJB>();
			entidade.setData( getControlaData().getFrontOffice());
			
			for (IdiomaMozartEJB idioma: idiomaList){
				NoticiaEJB noticia = new NoticiaEJB();
				noticia.setIdioma( idioma );
				entidades.add( noticia );	
			}
			
			Collections.sort( entidades, NoticiaEJB.getComparator());
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	@SuppressWarnings("unchecked")
	public String prepararAlteracao(){

		try{
			
			idiomaList = ComercialDelegate.instance().pesquisarIdioma( null );
			entidades = ComercialDelegate.instance().pesquisarNoticias( entidade );
			Collections.sort( entidades, NoticiaEJB.getComparator());
			entidade = entidades.get(0);
			
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	public String gravar(){
		
		try{
			entidade.setUsuario(getUsuario());
			entidades = new ArrayList<NoticiaEJB>();
			
			for (int x = 0;x<idioma.length;x++){

				IdiomaMozartEJB idioma = new IdiomaMozartEJB();
				idioma.setIdIdioma( this.idioma[x] );

				NoticiaEJB noticia = new NoticiaEJB();
				noticia.setIdioma( idioma );
				
				noticia.setAtivo( entidade.getAtivo() );
				noticia.setIdHotel( getHotelCorrente().getIdHotel() );	
				noticia.setData( entidade.getData() );
				
				noticia.setNoticia(this.noticia[x]);
				noticia.setResumo(resumo[x]);
				noticia.setTitulo(titulo[x]);
				noticia.setIdPrograma( new Long(1));
				NoticiaPK id = new NoticiaPK();
				id.setIdIdioma( this.idioma[x] );
				
				if (entidade.getId()!=null && entidade.getId().getIdNoticia() !=null){
					id.setIdNoticia( entidade.getId().getIdNoticia());
				}
				noticia.setId( id );
				entidades.add( noticia );
			}
			
			ComercialDelegate.instance().gravarNoticia(entidade, entidades);

			prepararInclusao();
			addMensagemSucesso( MSG_SUCESSO );
			
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	public NoticiaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(NoticiaEJB entidade) {
		this.entidade = entidade;
	}

	public List<NoticiaEJB> getEntidades() {
		return entidades;
	}

	public void setEntidades(List<NoticiaEJB> entidades) {
		this.entidades = entidades;
	}



	public String[] getTitulo() {
		return titulo;
	}

	public void setTitulo(String[] titulo) {
		this.titulo = titulo;
	}

	public String[] getResumo() {
		return resumo;
	}

	public void setResumo(String[] resumo) {
		this.resumo = resumo;
	}

	public String[] getNoticia() {
		return noticia;
	}

	public void setNoticia(String[] noticia) {
		this.noticia = noticia;
	}

	public Long[] getIdioma() {
		return idioma;
	}

	public void setIdioma(Long[] idioma) {
		this.idioma = idioma;
	}

	public List<IdiomaMozartEJB> getIdiomaList() {
		return idiomaList;
	}

	public void setIdiomaList(List<IdiomaMozartEJB> idiomaList) {
		this.idiomaList = idiomaList;
	}
	
	
}

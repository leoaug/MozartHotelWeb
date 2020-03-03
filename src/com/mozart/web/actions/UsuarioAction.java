package com.mozart.web.actions;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;

import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.ConfigWebEJB;
import com.mozart.model.ejb.entity.MenuMozartWebEJB;
import com.mozart.model.ejb.entity.MenuMozartWebUsuarioEJB;
import com.mozart.model.ejb.entity.PartnerDominioEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.util.Criptografia;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.aws.AwsFileUtilities;
import com.mozart.web.helper.ArvorePermissaoHelper;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class UsuarioAction extends BaseAction {
	private static final long serialVersionUID = -1023454269508081198L;
	private String[] ids;
	private List<MenuMozartWebEJB> menus;
	private List<UsuarioEJB> usuarios;
	private List<MozartComboWeb> turnoList;
	private UsuarioEJB usuario;
	private String confimacaoSenha;
	private String usuarioRede;
	private Long idUsuarioDesativado;
	private String usuarioAtivado;
	private String senhaAtual;
	private File documento;
    private String documentoFileName;
    private InputStream documentoStream;
    
	public UsuarioAction() {
		this.usuario = new UsuarioEJB();
	}

	public String salvar() {
		try {
			info("Salvando usuario..." + this.ids);

			List<UsuarioEJB> lista = (List) this.request.getSession()
					.getAttribute("usuarios");
			List<UsuarioEJB> listaDesativada = (List) this.request.getSession()
					.getAttribute("usuariosDesativados");

			UsuarioEJB usuarioSelecionado = new UsuarioEJB();
			if (("S".equals(this.usuarioAtivado))
					&& (!MozartUtil.isNull(this.usuario.getIdUsuario()))) {
				usuarioSelecionado.setIdUsuario(this.usuario.getIdUsuario());
				usuarioSelecionado = (UsuarioEJB) lista.get(lista
						.indexOf(usuarioSelecionado));
			} else if (("N".equals(this.usuarioAtivado))
					&& (!MozartUtil.isNull(getIdUsuarioDesativado()))) {
				usuarioSelecionado.setIdUsuario(getIdUsuarioDesativado());
				usuarioSelecionado = (UsuarioEJB) listaDesativada
						.get(listaDesativada.indexOf(usuarioSelecionado));
			}
			
			if(this.usuario.getNomeFotografia().equals("")){
				if(this.documento == null){ 
					this.usuario.setFotografia(null);
					this.usuario.setNomeFotografia(null);
				}else{
					if (this.documento.length() > 5242880) {
						addMensagemErro("Somente são aceitos documentos até 5mb.");
						return SUCESSO_FORWARD;
					}
					
					if (this.documentoFileName.length() > 60) {
						addMensagemErro("O nome do documento deve possuir no máximo 60 caracteres");
						return SUCESSO_FORWARD;
					}
					
					if (!this.documentoFileName.toLowerCase().endsWith(".jpg") && !this.documentoFileName.toLowerCase().endsWith(".png")) {
						addMensagemErro("Somente são aceitos documentos do tipo PNG ou JPG.");
						return SUCESSO_FORWARD;
					}
					
					String url = request.getServerName();
					
					if(url.contains("localhost")){
						url = "dev1.mozart.com.br";
					}
					
					ConfigWebEJB config = UsuarioDelegate.instance()
							.obterConfiguracaoWeb();
					
					if(config != null){
						this.usuario.setNomeFotografia(usuarioSelecionado.getIdUsuario() + ".jpeg");
						usuarioSelecionado.setNomeFotografia(usuarioSelecionado.getIdUsuario() + ".jpeg");
						new AwsFileUtilities().fileUpload(config.getBucket(), "fotosUsuarios/" + usuarioSelecionado.getIdUsuario() + ".jpeg" , "image/jpeg", FileUtils.openInputStream(documento));
					}					
				}
			}
			
			usuarioSelecionado.setNome(this.usuario.getNome());
			usuarioSelecionado.setNivel(this.usuario.getNivel());
			usuarioSelecionado.setDataValidade(this.usuario.getDataValidade());
			usuarioSelecionado.setAtivo(this.usuario.getAtivo());
			usuarioSelecionado.setTurno(this.usuario.getTurno());
			if (super.getUsuario().getCrsEJB() != null) {
				usuarioSelecionado.setHotelEJB(null);
				usuarioSelecionado.setRedeHotelEJB(null);
				usuarioSelecionado.setCrsEJB(super.getUsuario().getCrsEJB());
			} else if ("N".equalsIgnoreCase(this.usuarioRede)) {
				usuarioSelecionado.setHotelEJB(getHotelCorrente());
				usuarioSelecionado.setRedeHotelEJB(null);
			} else {
				usuarioSelecionado.setHotelEJB(null);
				usuarioSelecionado.setRedeHotelEJB(getHotelCorrente()
						.getRedeHotelEJB());
			}
			usuarioSelecionado.setNick("MOZART_" + this.usuario.getNick());
			if (!MozartUtil.isNull(this.usuario.getSenha())) {
				usuarioSelecionado.setSenha(Criptografia.instance().crypto(
						this.usuario.getSenha()));
			}
			List<MenuMozartWebUsuarioEJB> permissoes = new ArrayList();
			if (this.ids != null) {
				for (int x = 0; x < this.ids.length; x++) {
					permissoes.add(new MenuMozartWebUsuarioEJB(
							usuarioSelecionado, new MenuMozartWebEJB(new Long(
									this.ids[x]))));
				}
			}
			
			List<Long> listaProgramas = (List) this.request.getSession()
					.getAttribute(ID_PROGRAMA_LIST);
			
			usuarioSelecionado.setMenuMozartWebUsuarioEJBList(permissoes);
			usuarioSelecionado.setUsuario(getUserSession().getUsuarioEJB());
			
			UsuarioDelegate.instance().salvarUsuario(usuarioSelecionado, listaProgramas);

			addMensagemSucesso("Operação realizada com sucesso.");

			return preparar();
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String preparar() {
		info("Preparando usuário");

		this.usuario = new UsuarioEJB();
		try {
			UsuarioDelegate delegate = UsuarioDelegate.instance();

			Long tipo = getHotelCorrente().getIdPrograma();
			
			if (! MozartUtil.isNull(getUserSession().getUsuarioEJB().getCrsEJB())) {
				tipo =  new Long(5L);
			}
			
			Long tipoRede = tipo;
			
			this.usuarioRede = "N";
			this.menus = delegate.listarMenus(tipo, tipoRede);
			this.request.getSession().setAttribute("menus",
					new ArvorePermissaoHelper(this.menus, tipo, tipoRede).build());

			UsuarioEJB pFiltro = getUserSession().getUsuarioEJB();
			if (pFiltro.getRedeHotelEJB() != null) {
				pFiltro.setHotelEJB(getHotelCorrente());
			}
			pFiltro.setAtivo("S");
			this.usuarios = delegate.listarUsuarios(pFiltro);
			this.request.getSession().setAttribute("usuarios", this.usuarios);
			pFiltro.setAtivo("N");
			this.request.getSession().setAttribute("usuariosDesativados",
					delegate.listarUsuarios(pFiltro));
		} catch (Exception e) {
			addMensagemErro("Erro ao realizar operação.");
			error(e.getMessage());
		}
		return "sucesso";
	}

	public String trocarSenha() {
		try {
			UsuarioDelegate delegate = UsuarioDelegate.instance();
			UsuarioEJB user = getUserSession().getUsuarioEJB();
			if (!Criptografia.instance().crypto(this.senhaAtual).equals(
					user.getSenha())) {
				addMensagemErro("A senha atual informada, não confere");
				return "sucesso";
			}
			user.setSenha(Criptografia.instance().crypto(
					this.usuario.getSenha()));
			user.setUsuario(user);
			delegate.trocarSenha(user);
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (Exception e) {
			addMensagemErro("Erro ao realizar operação.");
			error(e.getMessage());
		}
		return "sucesso";
	}

	public void setIds(String[] ids) {
		this.ids = ids;
	}

	public String[] getIds() {
		return this.ids;
	}

	public void setMenus(List<MenuMozartWebEJB> menus) {
		this.menus = menus;
	}

	public List<MenuMozartWebEJB> getMenus() {
		return this.menus;
	}

	public void setUsuarios(List<UsuarioEJB> usuarios) {
		this.usuarios = usuarios;
	}

	public List<UsuarioEJB> getUsuarios() {
		return this.usuarios;
	}

	public void setUsuario(UsuarioEJB usuario) {
		this.usuario = usuario;
	}

	public UsuarioEJB getUsuario() {
		return this.usuario;
	}

	public void setConfimacaoSenha(String confimacaoSenha) {
		this.confimacaoSenha = confimacaoSenha;
	}

	public String getConfimacaoSenha() {
		return this.confimacaoSenha;
	}

	public void setSenhaAtual(String senhaAtual) {
		this.senhaAtual = senhaAtual;
	}

	public String getSenhaAtual() {
		return this.senhaAtual;
	}

	public String getUsuarioRede() {
		return this.usuarioRede;
	}

	public void setUsuarioRede(String usuarioRede) {
		this.usuarioRede = usuarioRede;
	}

	public List<MozartComboWeb> getTurnoList() {
		return this.turnoList;
	}

	public void setTurnoList(List<MozartComboWeb> turnoList) {
		this.turnoList = turnoList;
	}

	public Long getIdUsuarioDesativado() {
		return this.idUsuarioDesativado;
	}

	public void setIdUsuarioDesativado(Long idUsuarioDesativado) {
		this.idUsuarioDesativado = idUsuarioDesativado;
	}

	public String getUsuarioAtivado() {
		return this.usuarioAtivado;
	}

	public void setUsuarioAtivado(String usuarioAtivado) {
		this.usuarioAtivado = usuarioAtivado;
	}

	public File getDocumento() {
		return documento;
	}

	public void setDocumento(File documento) {
		this.documento = documento;
	}

	public String getDocumentoFileName() {
		return documentoFileName;
	}

	public void setDocumentoFileName(String documentoFileName) {
		this.documentoFileName = documentoFileName;
	}

	public InputStream getDocumentoStream() {
		return documentoStream;
	}

	public void setDocumentoStream(InputStream documentoStream) {
		this.documentoStream = documentoStream;
	}
}
package com.mozart.web.actions.compras;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComprasDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.BancoEJB;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.ejb.entity.FornecedorGrupoEJB;
import com.mozart.model.ejb.entity.FornecedorHotelEJB;
import com.mozart.model.ejb.entity.FornecedorHotelEJBPK;
import com.mozart.model.ejb.entity.FornecedorRedeEJB;
import com.mozart.model.ejb.entity.FornecedorRedeEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.BancoVO;
import com.mozart.model.vo.FornecedorVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class FornecedorAction extends BaseAction {
	private static final long serialVersionUID = 1L;
	private FornecedorVO filtro;
	private FornecedorRedeEJB entidade;
	private List<FornecedorGrupoEJB> fornecedorGrupoList;
	private List<MozartComboWeb> tipoEmpresaList;
	private List<MozartComboWeb> opcoesList;
	private FornecedorHotelEJB hotel;
	private List<BancoVO> bancoList;
	private EmpresaEJB empresa;
	private BancoEJB banco;
	private Boolean alteracao;
	private boolean cadastrarEmpresa;
	private String empresaCnpj;
	private String empresaCpf;

	public FornecedorAction() {
		this.filtro = new FornecedorVO();
		this.entidade = new FornecedorRedeEJB();
		this.fornecedorGrupoList = Collections.emptyList();
		this.hotel = new FornecedorHotelEJB();
		this.bancoList = Collections.emptyList();
		this.empresa = new EmpresaEJB();
		this.banco = new BancoEJB();

		this.tipoEmpresaList = new ArrayList();
		this.tipoEmpresaList.add(new MozartComboWeb("A", "Agência de Turismo"));
		this.tipoEmpresaList.add(new MozartComboWeb("O", "Operadora"));
		this.tipoEmpresaList.add(new MozartComboWeb("E", "Empresa"));
		this.tipoEmpresaList.add(new MozartComboWeb("P", "Particular"));
		this.tipoEmpresaList.add(new MozartComboWeb("D", "Diversos"));
		
		this.opcoesList = new ArrayList();
		this.opcoesList.add(new MozartComboWeb("1", "Pessoa Jurídica"));
		this.opcoesList.add(new MozartComboWeb("2", "Pessoa Física"));
		this.opcoesList.add(new MozartComboWeb("3", "Outros"));
	}

	public String validarEmpresa() {
		try {
			info("Iniciando validacao da empresa");
			
			if (!MozartUtil.isNull(empresa.getNacional()) && empresa.getNacional().equals("3")) {
				this.cadastrarEmpresa = true;
			}
			else
			{
				EmpresaEJB empresaResultado = EmpresaDelegate.instance()
						.obterEmpresa(this.empresa);
				if (!MozartUtil.isNull(empresaResultado) && !MozartUtil.isNull(empresa.getNacional()) && !empresa.getNacional().equals("3")) {
					this.cadastrarEmpresa = false;
					this.empresa = empresaResultado;
					FornecedorRedeEJBPK id = new FornecedorRedeEJBPK();
					id.setIdFornecedor(this.empresa.getIdEmpresa());
					id.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
							.getIdRedeHotel());
					this.entidade = ((FornecedorRedeEJB) CheckinDelegate.instance()
							.obter(FornecedorRedeEJB.class, id));
					if (!MozartUtil.isNull(this.entidade)) {
						FornecedorHotelEJBPK idHotel = new FornecedorHotelEJBPK();
						idHotel.setIdFornecedor(this.entidade.getIdFornecedor());
						idHotel.setIdHotel(getHotelCorrente().getIdHotel());
						this.hotel = ((FornecedorHotelEJB) CheckinDelegate
								.instance()
								.obter(FornecedorHotelEJB.class, idHotel));
					}
				} else {
					this.cadastrarEmpresa = true;
				}
			}
			initCombo();
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
			return ERRO_FORWARD;
		}
		return SUCESSO_FORWARD;
	}

	private void initCombo() throws MozartSessionException {
		BancoVO filtro = new BancoVO();
		filtro.setIdHoteis(getIdHoteis());
		this.bancoList = SistemaDelegate.instance().pesquisarBanco(filtro);

		FornecedorGrupoEJB filtroFornecedorGrupo = new FornecedorGrupoEJB();
		filtroFornecedorGrupo.setIdRedeHotel(getHotelCorrente()
				.getRedeHotelEJB().getIdRedeHotel());
		this.fornecedorGrupoList = ComprasDelegate.instance()
				.pesquisarFornecedorGrupo(filtroFornecedorGrupo);
	}

	public String prepararInclusao() {
		try {
			initCombo();
			this.hotel.setContasPagar("S");
			this.entidade.setContasPagar("S");
		} catch (MozartSessionException e) {
			addMensagemErro("Erro ao realizar operação.");
			error(e.getMessage());
			return ERRO_FORWARD;
		}
		return SUCESSO_FORWARD;
	}

	public String prepararAlteracao() {
		try {
			initCombo();
			this.empresa = ((EmpresaEJB) CheckinDelegate.instance().obter(
					EmpresaEJB.class, this.entidade.getIdFornecedor()));

			FornecedorHotelEJBPK idHotel = new FornecedorHotelEJBPK();
			idHotel.setIdFornecedor(this.entidade.getIdFornecedor());
			idHotel.setIdHotel(getHotelCorrente().getIdHotel());
			this.hotel = ((FornecedorHotelEJB) CheckinDelegate.instance()
					.obter(FornecedorHotelEJB.class, idHotel));

			this.entidade = this.hotel.getFornecedorRedeEJB();

			this.alteracao = Boolean.TRUE;
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return ERRO_FORWARD;
		}
		return SUCESSO_FORWARD;
	}

	public String gravar() {
		try {
			initCombo();
			this.entidade.setIdFornecedor(this.empresa.getIdEmpresa());
			this.entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			this.entidade.setUsuario(getUsuario());
			this.hotel.setFornecedorRedeEJB(this.entidade);
			this.hotel.setIdHotel(getHotelCorrente().getIdHotel());
			this.entidade.addFornecedorHotelEJB(this.hotel);
			if (MozartUtil.isNull(this.entidade.getBancoEJB().getIdBanco())) {
				this.entidade.setBancoEJB(null);
			}
			if (MozartUtil.isNull(this.entidade.getFornecedorGrupo()
					.getIdFornecedorGrupo())) {
				this.entidade.setFornecedorGrupo(null);
			}
			if (MozartUtil.isNull(this.empresa.getIdEmpresa())) {
				this.empresa.setCartaoCredito("N");
				this.empresa = ((EmpresaEJB) CheckinDelegate.instance()
						.incluir(this.empresa));
				this.entidade.setIdFornecedor(this.empresa.getIdEmpresa());
			}
			ComprasDelegate.instance().gravarFornecedor(this.entidade);

			addMensagemSucesso("Operação realizada com sucesso.");
			this.entidade = new FornecedorRedeEJB();
			this.empresa = new EmpresaEJB();
			this.hotel = new FornecedorHotelEJB();
			this.alteracao = Boolean.FALSE;
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			return ERRO_FORWARD;
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return ERRO_FORWARD;
		}
		return SUCESSO_FORWARD;
	}

	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}

	public String pesquisar() {
		try {
			this.filtro.setIdHoteis(getIdHoteis());
			List<FornecedorVO> lista = ComprasDelegate.instance()
					.pesquisarFornecedor(this.filtro);
			if (MozartUtil.isNull(lista)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa", lista);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return ERRO_FORWARD;
		}
		return SUCESSO_FORWARD;
	}

	public FornecedorVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(FornecedorVO filtro) {
		this.filtro = filtro;
	}

	public FornecedorRedeEJB getEntidade() {
		return this.entidade;
	}

	public void setEntidade(FornecedorRedeEJB entidade) {
		this.entidade = entidade;
	}
	
	public List<FornecedorGrupoEJB> getFornecedorGrupoList() {
		return this.fornecedorGrupoList;
	}

	public void setFornecedorGrupoList(
			List<FornecedorGrupoEJB> fornecedorGrupoList) {
		this.fornecedorGrupoList = fornecedorGrupoList;
	}

	public FornecedorHotelEJB getHotel() {
		return this.hotel;
	}

	public void setHotel(FornecedorHotelEJB hotel) {
		this.hotel = hotel;
	}

	public List<BancoVO> getBancoList() {
		return this.bancoList;
	}

	public void setBancoList(List<BancoVO> bancoList) {
		this.bancoList = bancoList;
	}

	public EmpresaEJB getEmpresa() {
		return this.empresa;
	}

	public void setEmpresa(EmpresaEJB empresa) {
		this.empresa = empresa;
	}

	public BancoEJB getBanco() {
		return this.banco;
	}

	public void setBanco(BancoEJB banco) {
		this.banco = banco;
	}

	public Boolean getAlteracao() {
		return this.alteracao;
	}

	public void setAlteracao(Boolean alteracao) {
		this.alteracao = alteracao;
	}

	public boolean isCadastrarEmpresa() {
		return this.cadastrarEmpresa;
	}

	public void setCadastrarEmpresa(boolean cadastrarEmpresa) {
		this.cadastrarEmpresa = cadastrarEmpresa;
	}

	public List<MozartComboWeb> getTipoEmpresaList() {
		return this.tipoEmpresaList;
	}

	public void setTipoEmpresaList(List<MozartComboWeb> tipoEmpresaList) {
		this.tipoEmpresaList = tipoEmpresaList;
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
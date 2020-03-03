package com.mozart.web.actions.recepcao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.HospedeEJB;
import com.mozart.model.ejb.entity.ProfissaoEJB;
import com.mozart.model.ejb.entity.TipoHospedeEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.HospedeVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class HospedeAction extends BaseAction {
	private static final long serialVersionUID = 6674359568966094426L;
	protected Boolean origemHospede;
	protected HospedeEJB entidade;
	private HospedeVO filtro;
	private List<MozartComboWeb> sexoList;

	public HospedeAction() {
		this.sexoList = new ArrayList();
		this.sexoList.add(new MozartComboWeb("M", "Masculino"));
		this.sexoList.add(new MozartComboWeb("F", "Feminino"));

		this.origemHospede = Boolean.TRUE;
	}

	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return "sucesso";
	}

	public String pesquisar() {
		info("Pesquisando hóspede");
		try {
			this.request.getSession().removeAttribute("listaPesquisa");
			this.filtro.setIdHoteis(getIdHoteis());
			this.filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<HospedeVO> listaPesquisa = ComercialDelegate.instance()
					.pesquisarHospede(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
				return "sucesso";
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararInclusao() {
		try {
			this.entidade = new HospedeEJB();
			this.entidade.setIdBairro(new Long(0L));
			this.entidade.setCredito("S");
			entidade.setIdHotel(getHotelCorrente().getIdHotel());

			initCombo();
		} catch (MozartSessionException e) {
			addMensagemErro("Erro ao realizar operação.");
			error(e.getMessage());
		}
		return "sucesso";
	}

	private void initCombo() throws MozartSessionException {
		TipoHospedeEJB thFiltro = new TipoHospedeEJB();
		thFiltro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		List<TipoHospedeEJB> tipoHospedeList = Collections.EMPTY_LIST;
		tipoHospedeList = ComercialDelegate.instance().obterTipoHospede(
				thFiltro);
		this.request.getSession().setAttribute("tipoHospedeList",
				tipoHospedeList);

		List<ProfissaoEJB> profissaoList = Collections.EMPTY_LIST;
		profissaoList = ComercialDelegate.instance().obterProfissao();
		this.request.getSession().setAttribute("profissaoList", profissaoList);
	}

	public String prepararAlteracao() {
		try {
			this.entidade = ((HospedeEJB) CheckinDelegate.instance().obter(
					HospedeEJB.class, this.entidade.getIdHospede()));
			initCombo();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		}
		return "sucesso";
	}

	public String gravar() {
		try {
			if ((MozartUtil.isNull(this.entidade.getCidadeEJB()))
					|| (MozartUtil.isNull(this.entidade.getCidadeEJB()
							.getIdCidade()))) {
				this.entidade.setCidadeEJB(null);
			}
			this.entidade.setUsuario(getUserSession().getUsuarioEJB());
			this.entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			this.entidade.setIdHotel(getHotelCorrente().getIdHotel());
			if (MozartUtil.isNull(this.entidade.getIdHospede())) {
				this.entidade = ((HospedeEJB) CheckinDelegate.instance()
						.incluir(this.entidade));
			} else {
				this.entidade = ((HospedeEJB) CheckinDelegate.instance()
						.alterar(this.entidade));
			}
			addMensagemSucesso("Operação realizada com sucesso.");

			return prepararInclusao();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public HospedeEJB getEntidade() {
		return this.entidade;
	}

	public void setEntidade(HospedeEJB entidade) {
		this.entidade = entidade;
	}

	public HospedeVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(HospedeVO filtro) {
		this.filtro = filtro;
	}

	public List<MozartComboWeb> getSexoList() {
		return this.sexoList;
	}

	public void setSexoList(List<MozartComboWeb> sexoList) {
		this.sexoList = sexoList;
	}

	public Boolean getOrigemHospede() {
		return this.origemHospede;
	}

	public void setOrigemHospede(Boolean origemHospede) {
		this.origemHospede = origemHospede;
	}
}
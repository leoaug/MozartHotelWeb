package com.mozart.web.actions.comercial;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.CaracteristicaGeralEJB;
import com.mozart.model.ejb.entity.IdiomaMozartEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;

import java.util.Collections;
import java.util.List;

public class CaracteristicaGeralAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9200401097285854616L;

	private CaracteristicaGeralEJB entidade;
	private List<IdiomaMozartEJB> idiomaList;

	public CaracteristicaGeralAction() {
		entidade = new CaracteristicaGeralEJB();

	}

	public String prepararPesquisa() {
		request.getSession().removeAttribute("listaPesquisa");
		initCombo();
		return SUCESSO_FORWARD;
	}

	private void initCombo() {
		try {
			idiomaList = ComercialDelegate.instance().pesquisarIdioma(null);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}

	}

	public String pesquisar() {

		try {
			initCombo();
			List<CaracteristicaGeralEJB> lista = ComercialDelegate.instance()
					.pesquisarCaracteristicaGeral(getIdHoteis()[0]);
			request.getSession().setAttribute("listaPesquisa", lista);

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public String prepararInclusao() {
		try {
			entidade = new CaracteristicaGeralEJB();
			initCombo();
			for (IdiomaMozartEJB i : idiomaList) {
				if ("pt".equalsIgnoreCase(i.getSigla())) {
					entidade.setIdioma(i);
				}
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}

		return SUCESSO_FORWARD;
	}

	public String prepararAlteracao() {
		try {

			initCombo();
			entidade = (CaracteristicaGeralEJB) CheckinDelegate.instance()
					.obter(CaracteristicaGeralEJB.class,
							entidade.getIdCaracteristicasGerais());

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}

		return SUCESSO_FORWARD;
	}

	public String gravar() {
		try {
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel(getIdHoteis()[0]);

			List<CaracteristicaGeralEJB> caracteristicas = ComercialDelegate
					.instance().pesquisarCaracteristicaGeral(
							entidade.getIdHotel(),
							entidade.getIdioma().getIdIdioma());

			if (caracteristicas.isEmpty()) {
				if (MozartUtil.isNull(entidade.getIdCaracteristicasGerais())) {
					CheckinDelegate.instance().incluir(entidade);

				} else {
					CheckinDelegate.instance().alterar(entidade);
				}
				addMensagemSucesso(MSG_SUCESSO);
				return prepararInclusao();
			} else {
				addMensagemErro("Existe característica para o idioma informado!");
			}
			initCombo();
			return SUCESSO_FORWARD;

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			initCombo();
			return SUCESSO_FORWARD;
		}

	}

	public CaracteristicaGeralEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(CaracteristicaGeralEJB entidade) {
		this.entidade = entidade;
	}

	public List<IdiomaMozartEJB> getIdiomaList() {
		return idiomaList;
	}

	public void setIdiomaList(List<IdiomaMozartEJB> idiomaList) {
		this.idiomaList = idiomaList;
	}

}

package com.mozart.web.actions.financeiro;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.ejb.entity.ContasPagarEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.FornecedorHotelEJB;
import com.mozart.model.ejb.entity.FornecedorHotelEJBPK;
import com.mozart.model.ejb.entity.FornecedorRedeEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ContasPagarComissaoVO;
import com.mozart.web.actions.BaseAction;

@SuppressWarnings("unchecked")
public class ContasPagarComissaoAction extends BaseAction {
	private static final long serialVersionUID = -8978837298285732383L;

	private ContasPagarComissaoVO filtro;
	private Long[] idNota;

	public ContasPagarComissaoAction() {
		this.filtro = new ContasPagarComissaoVO();
	}
	
	public String unificarContasPagarComissao(){
		info("Iniciando a unificacao de comissoes a pagar");
		try {
			List<ContasPagarComissaoVO> listaPesquisa = (List<ContasPagarComissaoVO>) this.request.getSession().getAttribute("listaPesquisa");
			
			ControlaDataEJB controlaData = (ControlaDataEJB) CheckinDelegate.instance().obter(ControlaDataEJB.class, getIdHoteis()[0]);
			HotelEJB hotel = (HotelEJB) CheckinDelegate.instance().obter(HotelEJB.class, getIdHoteis()[0]);
			
			ContasPagarComissaoVO contaPagarComissaoSoma = null;
			
			List<ContasPagarComissaoVO> listaUnificar = new ArrayList<ContasPagarComissaoVO>();			
			
			//somar os valores das diarias 
			for (int x = 0; x < this.idNota.length; x++) {
				ContasPagarComissaoVO vo = new ContasPagarComissaoVO();
				vo.setIdNota(this.idNota[x]);
				if (listaPesquisa.contains(vo)) {					
					vo = (ContasPagarComissaoVO) listaPesquisa.get(listaPesquisa.indexOf(vo));
					listaUnificar.add(vo);
					
					if(contaPagarComissaoSoma == null){
						contaPagarComissaoSoma = vo.clone();
						contaPagarComissaoSoma.setValorDiaria(0d);
					}else if(!contaPagarComissaoSoma.getIdEmpresa().equals(vo.getIdEmpresa())){
						throw new MozartValidateException("Erro ao realizar operação, Fornecedores diferentes.");
					}
					
					contaPagarComissaoSoma.setValorDiaria(contaPagarComissaoSoma.getValorDiaria() + vo.getValorDiaria());
					contaPagarComissaoSoma.setNumNota(vo.getNumNota());
					contaPagarComissaoSoma.setDataSaida(vo.getDataSaida());
				}
			}
			
			ContasPagarEJB entidadeCP = gravarContaPagarComissao(controlaData, hotel, contaPagarComissaoSoma);
			
			//O titulo não poderá ser eliminado pois ele é colocado no insert do contas a pagar
			//e corresponde ao num documento, neste caso mantem sempre o maior MAX após a unificação
			
			//a data de saída é desnecessária, porém pode ser colocada a última na tela correspondente ao num_documento acima
			
			//gravar o id_contas_pagar no movimento apartamento onde estão as diárias da base de calculo
			
			
			//atualizar o movimentos apartamento
			for(ContasPagarComissaoVO vo : listaUnificar){
				List<MovimentoApartamentoEJB> movimentosNota = CheckinDelegate.instance().obterMovimentosPorIdNota(vo.getIdNota());
				
				for(MovimentoApartamentoEJB entidadeMA : movimentosNota){
					entidadeMA.setIdContasPagar(entidadeCP.getIdContasPagar());
					CheckinDelegate.instance().alterar(entidadeMA);						
				}			
			}
			
			listaPesquisa.removeAll(listaUnificar);			
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemSucesso(e.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		
		addMensagemSucesso("Operação realizada com sucesso.");
		return SUCESSO_FORWARD;
	}

	public String gerarContasPagarComissao() {
		info("Iniciando a geracao da comissao a pagar");
		try {
			List<ContasPagarComissaoVO> listaPesquisa = (List<ContasPagarComissaoVO>) this.request.getSession().getAttribute("listaPesquisa");
			
			ControlaDataEJB controlaData = (ControlaDataEJB) CheckinDelegate.instance().obter(ControlaDataEJB.class, getIdHoteis()[0]);
			HotelEJB hotel = (HotelEJB) CheckinDelegate.instance().obter(HotelEJB.class, getIdHoteis()[0]);
			
			for (int x = 0; x < this.idNota.length; x++) {
				ContasPagarComissaoVO vo = new ContasPagarComissaoVO();
				vo.setIdNota(this.idNota[x]);
				if (listaPesquisa.contains(vo)) {					
					vo = (ContasPagarComissaoVO) listaPesquisa.get(listaPesquisa.indexOf(vo));
					
					ContasPagarEJB entidadeCP = gravarContaPagarComissao(controlaData, hotel, vo);
					
					//atualizar o movimentos apartamento
					List<MovimentoApartamentoEJB> movimentosNota = CheckinDelegate.instance().obterMovimentosPorIdNota(vo.getIdNota());
					
					for(MovimentoApartamentoEJB entidadeMA : movimentosNota){
						entidadeMA.setIdContasPagar(entidadeCP.getIdContasPagar());
						CheckinDelegate.instance().alterar(entidadeMA);						
					}
					
					listaPesquisa.remove(vo);
				}
			}
			
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemSucesso(e.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		addMensagemSucesso("Operação realizada com sucesso.");
		return SUCESSO_FORWARD;
	}

	private ContasPagarEJB gravarContaPagarComissao(ControlaDataEJB controlaData,
			HotelEJB hotel, ContasPagarComissaoVO vo)
			throws MozartSessionException {
		//verificar se o fonecedor já existe na tabela fornecedor_hotel
		FornecedorHotelEJBPK idHotel = new FornecedorHotelEJBPK();
		idHotel.setIdFornecedor(vo.getIdEmpresa());
		idHotel.setIdHotel(getHotelCorrente().getIdHotel());
		FornecedorHotelEJB fornecedorHotel = ((FornecedorHotelEJB) CheckinDelegate
				.instance().obter(FornecedorHotelEJB.class, idHotel));
		
		if(fornecedorHotel == null){
			FornecedorRedeEJB entidadeFR = new FornecedorRedeEJB();
			entidadeFR.setIdFornecedor(vo.getIdEmpresa());
			entidadeFR.setNomeFantasia(vo.getNomeEmpresa());
			entidadeFR.setPis("S");
			entidadeFR.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			entidadeFR.setContasPagar("S");
			
			fornecedorHotel = new FornecedorHotelEJB();
			fornecedorHotel.setIdHotel(getHotelCorrente().getIdHotel());
			fornecedorHotel.setIdFornecedor(vo.getIdEmpresa());
			fornecedorHotel.setFornecedorRedeEJB(entidadeFR);
			fornecedorHotel.setPrazo(vo.getPrazoPagamento());
			fornecedorHotel.setContasPagar("S");
			fornecedorHotel.setPrazoEntrega(1L);
					
			entidadeFR.addFornecedorHotelEJB(fornecedorHotel);
			
			entidadeFR = (FornecedorRedeEJB)CheckinDelegate.instance().incluir(entidadeFR);	
		}
		
		ContasPagarEJB entidadeCP = new ContasPagarEJB();					
		entidadeCP.setIdHistoricoCredito(vo.getIdHistoricoCredito());
		entidadeCP.setFornecedorHotelEJB(fornecedorHotel);
		entidadeCP.setContaCorrente(vo.getIdContaCorrente());
		entidadeCP.setNumDocumento(vo.getNumNota());
		entidadeCP.setSerieDocumento("A");
		entidadeCP.setNumParcelas(1L);
		entidadeCP.setDataEmissao(controlaData.getContasPagar());
		entidadeCP.setDataLancamento(controlaData.getContasPagar());
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(controlaData.getContasPagar());
		cal.add(Calendar.DAY_OF_MONTH, vo.getPrazoPagamento().intValue());
	
		entidadeCP.setDataVencimento(new Timestamp(cal.getTimeInMillis()));
		entidadeCP.setPortador(vo.getNomeEmpresa());
		entidadeCP.setPago("N");
		entidadeCP.setTipoDocumento("RPS");
		entidadeCP.setIdPlanoContasCredito(vo.getIdPlanoContasCredito());
		entidadeCP.setSituacao("C");
		entidadeCP.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
		entidadeCP.setPis("S");
		entidadeCP.setValorBruto(vo.getValorComissao());
		entidadeCP.setProrrogacao(entidadeCP.getDataVencimento());
		entidadeCP.setIdPlanoContasFinanceiro(vo.getIdPlanoContasFinanceiro());
		entidadeCP.setInternet("N");
		
		//gravar a conta a pagar					
		entidadeCP = (ContasPagarEJB)CheckinDelegate.instance().incluir(entidadeCP);
		
		return entidadeCP;
	}

	public String prepararGeracao() {
		info("Iniciando a geracao do contas a pagar comissao");
		return SUCESSO_FORWARD;
	}

	public String prepararPesquisa() {
		this.request.setAttribute("filtro.filtroDataLancamento.tipoIntervalo",
				"1");
		this.request.setAttribute("filtro.filtroDataLancamento.valorInicial",
				MozartUtil.format(getControlaData().getContasPagar(),
						"dd/MM/yyyy"));
		this.request.setAttribute("filtro.filtroDataLancamento.valorFinal",
				MozartUtil.format(MozartUtil.incrementarDia(getControlaData()
						.getContasPagar()), "dd/MM/yyyy"));
		this.request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}

	public String pesquisar() {
		info("Pesquisar contas a pagar comissao");
		try {
			this.filtro.setIdHoteis(getIdHoteis());
			List<ContasPagarComissaoVO> listaPesquisa = FinanceiroDelegate.instance()
					.pesquisarContasPagarComissao(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			System.out.println("filtroTipoPesquisa: " + this.filtro.getFiltroTipoPesquisa());
			this.request.getSession().setAttribute("filtroTipoPesquisa",
					this.filtro.getFiltroTipoPesquisa());
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public ContasPagarComissaoVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(ContasPagarComissaoVO filtro) {
		this.filtro = filtro;
	}


	public Long[] getIdNota() {
		return this.idNota;
	}

	public void setIdNota(Long[] idNota) {
		this.idNota = idNota;
	}
	
	public String prepararRelatorio() {
		return "sucesso";
	}
}
package com.mozart.web.api.resources;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.Optional;
import java.util.function.Predicate;

import javax.inject.Named;
import javax.validation.Valid;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.ejb.builder.EmpresaBuilder;
import com.mozart.model.ejb.builder.EmpresaHotelBuilder;
import com.mozart.model.ejb.builder.EmpresaRedeBuilder;
import com.mozart.model.ejb.entity.CidadeEJB;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaRedeEJB;
import com.mozart.model.ejb.entity.PromotorEJB;
import com.mozart.model.ejb.entity.ServicosContratoEJB;
import com.mozart.model.ejb.entity.TipoEmpresaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.web.api.request.BasicoRequest;
import com.mozart.web.api.request.ContratoRequest;
import com.mozart.web.api.request.PessoaRequest;
import com.mozart.web.api.request.PromotorRequest;

@Named
@Path("partner")
public class ParceiroResources {

	@POST
	@Path("/sales-promoter")
	@Consumes(value = MediaType.APPLICATION_JSON)
	@Produces(value = MediaType.APPLICATION_JSON)
	public Response incluirPromotor(PromotorRequest promotor) {

		try {
			PromotorEJB promotorEJB = new PromotorEJB();
			promotorEJB.setIdHotel(promotor.getIdUnidade());
			promotorEJB.setIdRedeHotel(promotor.getIdRede());
			promotorEJB.setTipoPromotor("V");
			promotorEJB.setComissao(promotor.getComissao().doubleValue());
			promotorEJB.setPromotor(promotor.getPromotor().getNome());
			promotorEJB.setAtivo("N");

			EmpresaEJB empresaEJB = empresaFromPessoaRequest(promotor);

			empresaEJB.getEmpresaRedeEJBList().get(0).setPromotorEJB(promotorEJB);

			EmpresaDelegate.instance().gravarEmpresa(empresaEJB);

		} catch (MozartSessionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return Response.ok().build();
	}

	@POST
	@Path("/contract")
	@Consumes(value = MediaType.APPLICATION_JSON)
	@Produces(value = MediaType.APPLICATION_JSON)
	public Response incluirContrato(@Valid ContratoRequest contrato) {
		try {
			ServicosContratoEJB contratoEJB = new ServicosContratoEJB();

			contratoEJB.setTipoLancamentoEJB(CheckinDelegate.instance().obterTipoLancamentoByPK(
					new TipoLancamentoEJBPK(contrato.getIdUnidade(), contrato.getIdTipoLancamento())));
			contratoEJB.setDataInicio(Timestamp.valueOf(contrato.getDataInicio().atStartOfDay()));
			contratoEJB.setDataFim(Timestamp.valueOf(contrato.getDataFim().atStartOfDay()));
			contratoEJB.setDiaFaturamento(contrato.getDiaFaturamento().toString());
			contratoEJB.setDescricao(contrato.getDescricaoServico());
			contratoEJB.setQuantidade(contrato.getQuantidade().toString());
			contratoEJB.setIss("N");
			contratoEJB.setTaxaServico("N");
			contratoEJB.setFormaReajuste("IGPM-FGV");
			contratoEJB.setRealizado("N");
			contratoEJB.setSerie("1");
			contratoEJB.setCancelado("N");
			contratoEJB.setTipoLancamentoCkEJB(CheckinDelegate.instance().obterTipoLancamentoByPK(
					new TipoLancamentoEJBPK(contrato.getIdUnidade(), contrato.getIdTipoLancamentoCk())));
			contratoEJB.setValorUnitario(contrato.getValorServico().doubleValue());

			EmpresaEJB empresaEJB = empresaFromPessoaRequest(contrato);

			empresaEJB.addServicosContratoEJB(contratoEJB);

			EmpresaDelegate.instance().gravarEmpresa(empresaEJB);

		} catch (MozartSessionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return Response.ok().build();
	}

	private EmpresaEJB empresaFromPessoaRequest(BasicoRequest basicoRequest) {

		PessoaRequest pessoaRequest = basicoRequest.getPessoa();

		CidadeEJB cidade;
		try {
			cidade = Optional
					.ofNullable(CheckinDelegate.instance()
							.pesquisarCidadePorCodigoIBGE(pessoaRequest.getEndereco().getCidade()))
					.orElseThrow(() -> new MozartSessionException(
							"Cidade Não encontrada para o Código IBGE: " + pessoaRequest.getEndereco().getCidade()));

			EmpresaEJB retorno = new EmpresaBuilder().razaoSocial(pessoaRequest.getNome())
					.nomeFantasia(pessoaRequest.getNome()).cgc(pessoaRequest.getDocumento())
					.cpf(pessoaRequest.getDocumento()).endereco(pessoaRequest.getEndereco().getLogradouro())
					.numero(pessoaRequest.getEndereco().getNumero())
					.complemento(pessoaRequest.getEndereco().getComplemento())
					.bairro(pessoaRequest.getEndereco().getBairro()).cep(pessoaRequest.getEndereco().getCep())
					.cidade(cidade).build();

			empresaRedeFromPessoaRequest(basicoRequest, retorno);

			return retorno;

		} catch (MozartSessionException e) {
			return null;
		}

	}

	private EmpresaRedeEJB empresaRedeFromPessoaRequest(BasicoRequest basicoRequest, EmpresaEJB empresa) {

		LocalDate dataCadastro = basicoRequest.getDataCadastro();

		PessoaRequest pessoaRequest = basicoRequest.getPessoa();

		StringBuilder enderecoCobranca = new StringBuilder();
		enderecoCobranca.append(pessoaRequest.getEndereco().getLogradouro());

		enderecoCobranca.append(
				Optional.ofNullable(pessoaRequest.getEndereco().getNumero()).map(n -> ", " + n.toString()).orElse(""));
		enderecoCobranca.append(Optional.ofNullable(pessoaRequest.getEndereco().getComplemento())
				.map(c -> ", " + c.toString()).orElse(""));

		EmpresaRedeEJB retorno = new EmpresaRedeBuilder().empresaEJB(empresa).contato(pessoaRequest.getNome())
				.telefone(pessoaRequest.getTelefone()).email(pessoaRequest.getEmail())
				.dataNascimento(Timestamp.valueOf(pessoaRequest.getDataNascimento().atStartOfDay()))
				.dataCadastro(Timestamp.valueOf(dataCadastro.atStartOfDay())).nomeFantasia(pessoaRequest.getNome())
				.cep(pessoaRequest.getEndereco().getCep()).cidade(empresa.getCidade())
				.bairro(pessoaRequest.getEndereco().getBairro()).enderecoCobranca(enderecoCobranca.toString())
				.idHotel(basicoRequest.getIdUnidade()).idRedeHotel(basicoRequest.getIdRede()).build();

		empresa.addEmpresaRedeEJB(retorno);

		empresaHotelFromPessoaRequest(basicoRequest, retorno);

		return retorno;

	}

	private EmpresaHotelEJB empresaHotelFromPessoaRequest(BasicoRequest basicoRequest, EmpresaRedeEJB empresaRede) {
		try {
			TipoEmpresaEJB filtro = new TipoEmpresaEJB();

			filtro.setIdRedeHotel(basicoRequest.getIdRede());
			filtro.setIdHotel(basicoRequest.getIdUnidade());
			filtro.setPadrao(basicoRequest.getPessoa().getDocumento().length() > 11 ? "J" : "F");

			Predicate<TipoEmpresaEJB> equalsIdHotel = t -> filtro.getIdHotel().equals(t.getIdHotel());
			Predicate<TipoEmpresaEJB> equalsPadrao = t -> filtro.getPadrao().equals(t.getPadrao());

			Long idTipoEmpresa = EmpresaDelegate.instance().obterTipoEmpresa(filtro).stream()
					.filter(equalsIdHotel.and(equalsPadrao)).findFirst().orElseThrow(() -> new MozartSessionException())
					.getIdTipoEmpresa();

			EmpresaHotelEJB retorno = new EmpresaHotelBuilder().idHotel(basicoRequest.getIdUnidade())
					.empresaRedeEJB(empresaRede).idTipoEmpresa(idTipoEmpresa).build();

			empresaRede.addEmpresaHotelEJB(retorno);

			return retorno;
		} catch (MozartSessionException e) {
			e.printStackTrace();
			return null;
		}

	}
}

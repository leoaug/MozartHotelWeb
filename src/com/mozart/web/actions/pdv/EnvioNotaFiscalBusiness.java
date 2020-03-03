package com.mozart.web.actions.pdv;

import java.util.Calendar;
import java.util.List;

import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.NotaFiscalEnvioVO;
import com.mozart.model.vo.ProdutoEnvioVO;
import com.mozart.model.vo.RetornoNotaFiscalVO;
import com.mozart.web.wsdl.sosistemas.NFEServicesProxy;

public class EnvioNotaFiscalBusiness {

	public RetornoNotaFiscalVO envioNota(long idHotel, long idNota) {
		
		RetornoNotaFiscalVO retorno = new RetornoNotaFiscalVO();
		
		try {
			NotaFiscalEnvioVO filtro = new NotaFiscalEnvioVO();
			filtro.setIdHotel(idHotel); 
			filtro.setFiltroIdNotaFiscal(idNota);
			NotaFiscalEnvioVO notaEnvio = PdvDelegate.instance().consultarNotaFiscalEmissao(filtro);
			
			NFEServicesProxy nfeServices = new NFEServicesProxy();
			
			String retornoIdNota = nfeServices.wbCriarNota(notaEnvio.getToken(),
					notaEnvio.getCpfCnpjEmpresa(),
					notaEnvio.getCpfCnpjCliente(),
					notaEnvio.getNomeCliente(),
					MozartUtil.isNull(notaEnvio.getCep()) ? "28800000" : notaEnvio.getCep(),
					notaEnvio.getFoneCliente(),
					notaEnvio.getIndicadorIdDestinatario(),
					notaEnvio.getEmailCliente(),
					notaEnvio.getDataEmissaoNf(),
					notaEnvio.getModeloNf(),
					notaEnvio.getSerieNf(),
					notaEnvio.getNumeroNf(),
					notaEnvio.getTipoEmissaoNf(),
					notaEnvio.getCodigoNf(),
					notaEnvio.getNatOperacaoNf(),
					notaEnvio.getIndPagNf(),
					notaEnvio.getTipoNf(),
					notaEnvio.getIdDestNf(),
					notaEnvio.getTipoImpressao(),
					notaEnvio.getNumeroLote(),
					notaEnvio.getNumeroResidencia(),
					notaEnvio.getComplementoCliente(),
					notaEnvio.getTfinNfe(),
					notaEnvio.getIndfinal(),
					notaEnvio.getIndiedest(),
					notaEnvio.getTipoPagamento() == 0L ? 1 : notaEnvio.getTipoPagamento(),
					notaEnvio.getInfcpl(),
					notaEnvio.getInffonte(),
					notaEnvio.getInfoperador(),
					notaEnvio.getVlPago(),
					notaEnvio.getVlTroco(),
					notaEnvio.getTipoFrete(),
					notaEnvio.getCnpjTransportador(),
					notaEnvio.getRazaoSocialTransportadora(),
					notaEnvio.getInscEstadualTransportadora(),
					notaEnvio.getCepTransportadora(),
					notaEnvio.getLogradouroTransportadora(),
					notaEnvio.getNumeroTransportadora(),
					notaEnvio.getBairroTransportadora(),
					notaEnvio.getCodigoAntt(),
					notaEnvio.getMunicipioTransportadora(),
					notaEnvio.getUfTransportadora(),
					notaEnvio.getPlacaVeiculo(),
					notaEnvio.getQtdTransportado(),
					notaEnvio.getEspecie(),
					notaEnvio.getMarca(),
					notaEnvio.getNumeracao(),
					notaEnvio.getPesoBruto(),
					notaEnvio.getPesoLiquido(),
					notaEnvio.getLogradouroCliente(),
					notaEnvio.getBairroCliente(),
					notaEnvio.getDataSaida(),
					notaEnvio.getIeCliente(),
					notaEnvio.getNfRef(),
					notaEnvio.getVicmsdeson(),
					notaEnvio.getVfcpufdest(),
					notaEnvio.getVfcp(),
					notaEnvio.getVfcpst(),
					notaEnvio.getVfcpstret(),
					notaEnvio.getVii(),
					notaEnvio.getVipidevol(),
					notaEnvio.getNfat(),
					notaEnvio.getNdup(),
					notaEnvio.getVencimento(),
					notaEnvio.getPrecoFrete(),
					notaEnvio.getValorDesconto());
			
			retorno.setIdNotaFiscal(retornoIdNota);
			
			ProdutoEnvioVO filtroProd = new ProdutoEnvioVO();
			filtroProd.setIdHotel(idHotel);
			filtroProd.setFiltroIdNotaFiscal(idNota);
			List<ProdutoEnvioVO> produtos = PdvDelegate.instance().obterProdutosEmissaoNota(filtroProd);
			
			for (ProdutoEnvioVO produtoEnvioVO : produtos) {
				nfeServices.wbInserirProdutos(retornoIdNota,
						produtoEnvioVO.getCprod(),
						produtoEnvioVO.getCean(),
						produtoEnvioVO.getXprod(),
						produtoEnvioVO.getNcm(),
						produtoEnvioVO.getCest(),
						produtoEnvioVO.getCfop(),
						produtoEnvioVO.getUcom(),
						produtoEnvioVO.getQcom(),
						produtoEnvioVO.getVuncom(),
						produtoEnvioVO.getVprod(),
						produtoEnvioVO.getCeantrib(),
						produtoEnvioVO.getUtrib(),
						produtoEnvioVO.getQtrib(),
						produtoEnvioVO.getVuntrib(),
						produtoEnvioVO.getVdesc(),
						produtoEnvioVO.getVoutros(),
						produtoEnvioVO.getIndtotal(),
						produtoEnvioVO.getVtottrib(),
						produtoEnvioVO.getIcmsOrigem(),
						produtoEnvioVO.getIcmsCst(),
						produtoEnvioVO.getIcmsModbc(),
						produtoEnvioVO.getIcmsRedbc(),
						produtoEnvioVO.getIcmsVbc(),
						produtoEnvioVO.getIcmsPicms(),
						produtoEnvioVO.getIcmsVicms(),
						produtoEnvioVO.getIpiCenq(),
						produtoEnvioVO.getIpintCst(),
						produtoEnvioVO.getPisaliqCst(),
						produtoEnvioVO.getPisaliqVbc(),
						produtoEnvioVO.getPisaliqPpis(),
						produtoEnvioVO.getPisaliqVpis(),
						produtoEnvioVO.getCofinsaliqCst(),
						produtoEnvioVO.getCofinsaliqVbc(),
						produtoEnvioVO.getCofinsaliqPcofins(),
						produtoEnvioVO.getCofinsaliqVcofins(),
						produtoEnvioVO.getIcmsPredbc(),
						produtoEnvioVO.getTipoTributacao(),
						produtoEnvioVO.getCsosn(),
						produtoEnvioVO.getVbcstret(),
						produtoEnvioVO.getVicmsstret(),
						produtoEnvioVO.getPisntCst(),
						produtoEnvioVO.getCofinsntCst(),
						produtoEnvioVO.getInfadprod().substring(0, 50),
						produtoEnvioVO.getIpiCst(),
						produtoEnvioVO.getIpiVbc(),
						produtoEnvioVO.getIpiPipi(),
						produtoEnvioVO.getIpiVipi(),
						produtoEnvioVO.getVfcpufdest(),
						produtoEnvioVO.getVfcp(),
						produtoEnvioVO.getPvcp(),
						produtoEnvioVO.getPmvast(),
						produtoEnvioVO.getVbcst(),
						produtoEnvioVO.getPicmsst(),
						produtoEnvioVO.getVicmsst());
			}
			
			//String retornoXml = nfeServices.wbGerarXml(retornoIdNota, 0, 0, 1);
			String chaveNota = nfeServices.wbGerarXml40(retornoIdNota, 0, 0, Long.parseLong(notaEnvio.getNumeroLote()));
			
			retorno.setChaveNota(chaveNota.substring(3));
			
			String qrCodeXml = nfeServices.wbRequisitarXmlQrcode(retornoIdNota);
			
			//String retornoXml = nfeServices.wbRequisitarXml(retornoIdNota);
			
			retorno.setXmlNota(qrCodeXml);
			
//			String valor = notaEnvio.getToken()+ "," +
//			notaEnvio.getCpfCnpjEmpresa()+ "," +
//			notaEnvio.getCpfCnpjCliente()+ "," +
//			notaEnvio.getNomeCliente()+ "," +
//			notaEnvio.getCep() + "," +
//			notaEnvio.getFoneCliente()+ "," +
//			notaEnvio.getIndicadorIdDestinatario()+ "," +
//			notaEnvio.getEmailCliente()+ "," +
//			notaEnvio.getDataEmissaoNf().get(Calendar.DAY_OF_MONTH) + "/" + notaEnvio.getDataEmissaoNf().get(Calendar.MONTH) + "/" +  notaEnvio.getDataEmissaoNf().get(Calendar.YEAR) + "," +
//			notaEnvio.getModeloNf()+ "," +
//			notaEnvio.getSerieNf()+ "," +
//			notaEnvio.getNumeroNf()+ "," +
//			notaEnvio.getTipoEmissaoNf()+ "," +
//			notaEnvio.getCodigoNf()+ "," +
//			notaEnvio.getNatOperacaoNf()+ "," +
//			notaEnvio.getIndPagNf()+ "," +
//			notaEnvio.getTipoNf()+ "," +
//			notaEnvio.getIdDestNf()+ "," +
//			notaEnvio.getTipoImpressao()+ "," +
//			notaEnvio.getNumeroLote()+ "," +
//			notaEnvio.getNumeroResidencia()+ "," +
//			notaEnvio.getComplementoCliente()+ "," +
//			notaEnvio.getTfinNfe()+ "," +
//			notaEnvio.getIndfinal()+ "," +
//			notaEnvio.getIndiedest()+ "," +
//			notaEnvio.getTipoPagamento()+ "," +
//			notaEnvio.getInfcpl()+ "," +
//			notaEnvio.getInffonte()+ "," +
//			notaEnvio.getInfoperador()+ "," +
//			notaEnvio.getVlPago()+ "," +
//			notaEnvio.getVlTroco()+ "," +
//			notaEnvio.getTipoFrete()+ "," +
//			notaEnvio.getCnpjTransportador()+ "," +
//			notaEnvio.getRazaoSocialTransportadora()+ "," +
//			notaEnvio.getInscEstadualTransportadora()+ "," +
//			notaEnvio.getCepTransportadora()+ "," +
//			notaEnvio.getLogradouroTransportadora()+ "," +
//			notaEnvio.getNumeroTransportadora()+ "," +
//			notaEnvio.getBairroTransportadora()+ "," +
//			notaEnvio.getCodigoAntt()+ "," +
//			notaEnvio.getMunicipioTransportadora()+ "," +
//			notaEnvio.getUfTransportadora()+ "," +
//			notaEnvio.getPlacaVeiculo()+ "," +
//			notaEnvio.getQtdTransportado()+ "," +
//			notaEnvio.getEspecie()+ "," +
//			notaEnvio.getMarca()+ "," +
//			notaEnvio.getNumeracao()+ "," +
//			notaEnvio.getPesoBruto()+ "," +
//			notaEnvio.getPesoLiquido()+ "," +
//			notaEnvio.getLogradouroCliente()+ "," +
//			notaEnvio.getBairroCliente()+ "," +
//			notaEnvio.getDataSaida().get(Calendar.DAY_OF_MONTH) + "/" + notaEnvio.getDataSaida().get(Calendar.MONTH) + "/" +  notaEnvio.getDataSaida().get(Calendar.YEAR) + "," +
//			notaEnvio.getIeCliente()+ "," +
//			notaEnvio.getNfRef()+ "," +
//			notaEnvio.getVicmsdeson()+ "," +
//			notaEnvio.getVfcpufdest()+ "," +
//			notaEnvio.getVfcp()+ "," +
//			notaEnvio.getVfcpst()+ "," +
//			notaEnvio.getVfcpstret()+ "," +
//			notaEnvio.getVii()+ "," +
//			notaEnvio.getVipidevol()+ "," +
//			notaEnvio.getNfat()+ "," +
//			notaEnvio.getNdup()+ "," +
//			notaEnvio.getVencimento().get(Calendar.DAY_OF_MONTH) + "/" + notaEnvio.getVencimento().get(Calendar.MONTH) + "/" +  notaEnvio.getVencimento().get(Calendar.YEAR) + "," +
//			notaEnvio.getPrecoFrete()+ "," +
//			notaEnvio.getValorDesconto();
			
			
			return retorno;
			
		} catch (Exception e) {
			retorno.getErros().add(e.getMessage());
		}
		
		return retorno;

	}
}

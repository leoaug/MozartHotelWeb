package com.mozart.web.teste;

import java.util.List;

import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.NotaFiscalEnvioVO;
import com.mozart.model.vo.ProdutoEnvioVO;
import com.mozart.web.wsdl.sosistemas.NFEServicesProxy;

public class TesteRestWebService {

	private static int HTTP_COD_SUCESSO = 200;

	public static void main() {
		try {
 
			NotaFiscalEnvioVO filtro = new NotaFiscalEnvioVO();
			filtro.setIdHotel(33L); 
			filtro.setFiltroIdNotaFiscal(39885900L);
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
			
			ProdutoEnvioVO filtroProd = new ProdutoEnvioVO();
			filtroProd.setIdHotel(33L);
			filtroProd.setFiltroIdNotaFiscal(39885900L);
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
			String retornoXml = nfeServices.wbGerarXml40(retornoIdNota, 0, 0, 1);
			
			String qrCodeXml = nfeServices.wbRequisitarXmlQrcode(retornoIdNota);
			
			String a = nfeServices.wbRequisitarXml(retornoIdNota);
			
			String b = nfeServices.wbBuscaIdNota("33180920168461000185650010000000311000000014");
			
			String retorno = "Fim";
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}

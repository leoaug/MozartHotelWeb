package com.mozart.web.wsdl.sosistemas;

public class NFEServicesProxy implements com.mozart.web.wsdl.sosistemas.NFEServices {
  private String _endpoint = null;
  private com.mozart.web.wsdl.sosistemas.NFEServices nFEServices = null;
  
  public NFEServicesProxy() {
    _initNFEServicesProxy();
  }
  
  public NFEServicesProxy(String endpoint) {
    _endpoint = endpoint;
    _initNFEServicesProxy();
  }
  
  private void _initNFEServicesProxy() {
    try {
      nFEServices = (new com.mozart.web.wsdl.sosistemas.NFEServicesServiceLocator()).getNFEServices();
      if (nFEServices != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)nFEServices)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)nFEServices)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (nFEServices != null)
      ((javax.xml.rpc.Stub)nFEServices)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.mozart.web.wsdl.sosistemas.NFEServices getNFEServices() {
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices;
  }
  
  public java.lang.String wbNReciboSefaz(java.lang.String idNota) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbNReciboSefaz(idNota);
  }
  
  public java.lang.String wbRetornoNota(java.lang.String idNota) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbRetornoNota(idNota);
  }
  
  public java.lang.String wbGerarXml40(java.lang.String idNota, double frete, double seguro, long idLote) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbGerarXml40(idNota, frete, seguro, idLote);
  }
  
  public java.lang.String wbRequisitarXml(java.lang.String idNota) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbRequisitarXml(idNota);
  }
  
  public java.lang.String wbCriarNota(java.lang.String token, java.lang.String cpfCnpjEmpresa, java.lang.String cpfCnpjCliente, java.lang.String nomeCliente, java.lang.String cep, java.lang.String foneCliente, long indicadorIdDestinatario, java.lang.String emailCliente, java.util.Calendar dataEmissaoNf, java.lang.String modeloNf, java.lang.String serieNf, java.lang.String numeroNf, long tipoEmissaoNf, java.lang.String codigoNf, java.lang.String natOperacaoNf, java.lang.String indPagNf, java.lang.String tipoNf, java.lang.String idDestNf, java.lang.String tipoImpressao, java.lang.String numeroLote, java.lang.String numeroResidencia, java.lang.String complementoCliente, java.lang.String tfinNfe, java.lang.String indfinal, long indiedest, long tipoPagamento, java.lang.String infcpl, java.lang.String inffonte, java.lang.String infoperador, double vlPago, double vlTroco, java.lang.String tipoFrete, java.lang.String cnpjTransportador, java.lang.String razaoSocialTransportadora, java.lang.String inscEstadualTransportadora, java.lang.String cepTransportadora, java.lang.String logradouroTransportadora, java.lang.String numeroTransportadora, java.lang.String bairroTransportadora, java.lang.String codigoAntt, java.lang.String municipioTransportadora, java.lang.String ufTransportadora, java.lang.String placaVeiculo, java.lang.String qtdTransportado, java.lang.String especie, java.lang.String marca, java.lang.String numeracao, java.lang.String pesoBruto, java.lang.String pesoLiquido, java.lang.String logradouroCliente, java.lang.String bairroCliente, java.util.Calendar dataSaida, java.lang.String ieCliente, java.lang.String nfRef, double vicmsdeson, double vfcpufdest, double vfcp, double vfcpst, double vfcpstret, double vii, double vipidevol, java.lang.String nfat, java.lang.String ndup, java.util.Calendar vencimento, double precoFrete, double valorDesconto) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbCriarNota(token, cpfCnpjEmpresa, cpfCnpjCliente, nomeCliente, cep, foneCliente, indicadorIdDestinatario, emailCliente, dataEmissaoNf, modeloNf, serieNf, numeroNf, tipoEmissaoNf, codigoNf, natOperacaoNf, indPagNf, tipoNf, idDestNf, tipoImpressao, numeroLote, numeroResidencia, complementoCliente, tfinNfe, indfinal, indiedest, tipoPagamento, infcpl, inffonte, infoperador, vlPago, vlTroco, tipoFrete, cnpjTransportador, razaoSocialTransportadora, inscEstadualTransportadora, cepTransportadora, logradouroTransportadora, numeroTransportadora, bairroTransportadora, codigoAntt, municipioTransportadora, ufTransportadora, placaVeiculo, qtdTransportado, especie, marca, numeracao, pesoBruto, pesoLiquido, logradouroCliente, bairroCliente, dataSaida, ieCliente, nfRef, vicmsdeson, vfcpufdest, vfcp, vfcpst, vfcpstret, vii, vipidevol, nfat, ndup, vencimento, precoFrete, valorDesconto);
  }
  
  public java.lang.String wbExportarXml(java.lang.String token, java.lang.String cnpj, java.util.Calendar dataInicial, java.util.Calendar dataFinal) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbExportarXml(token, cnpj, dataInicial, dataFinal);
  }
  
  public java.lang.String wbCancelarNf(java.lang.String token, java.lang.String cnpj, java.lang.String chaveNf, java.lang.String NNf, java.lang.String justificativa) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbCancelarNf(token, cnpj, chaveNf, NNf, justificativa);
  }
  
  public java.lang.String wbBuscaIdNota(java.lang.String chaveAcesso) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbBuscaIdNota(chaveAcesso);
  }
  
  public java.lang.String wbCartaCorrecao(java.lang.String token, java.lang.String cnpj, java.lang.String chaveNf, java.lang.String NNf, java.lang.String justificativa, java.lang.String orgao, java.lang.String NProtocolo) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbCartaCorrecao(token, cnpj, chaveNf, NNf, justificativa, orgao, NProtocolo);
  }
  
  public java.lang.String wbGerarXml(java.lang.String idNota, double frete, double seguro, long idLote) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbGerarXml(idNota, frete, seguro, idLote);
  }
  
  public java.lang.String wbInutilizarNf(java.lang.String token, java.lang.String cnpj, java.lang.String chaveNf, java.lang.String NNf, java.lang.String justificativa, java.lang.String ano, java.lang.String modelo, java.lang.String serie, long numeroInicial, long numeroFinal) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbInutilizarNf(token, cnpj, chaveNf, NNf, justificativa, ano, modelo, serie, numeroInicial, numeroFinal);
  }
  
  public java.lang.String wbStatusSefaz(java.lang.String token, java.lang.String cpfCnpjEmpresa) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbStatusSefaz(token, cpfCnpjEmpresa);
  }
  
  public java.lang.String wbConsultarAutorizacao(java.lang.String NRecibo, java.lang.String cnpj) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbConsultarAutorizacao(NRecibo, cnpj);
  }
  
  public void wbInserirProdutos(java.lang.String idNota, java.lang.String cprod, java.lang.String cean, java.lang.String xprod, java.lang.String ncm, java.lang.String cest, java.lang.String cfop, java.lang.String ucom, java.lang.String qcom, double vuncom, double vprod, java.lang.String ceantrib, java.lang.String utrib, double qtrib, double vuntrib, double vdesc, double voutros, long indtotal, double vtottrib, java.lang.String icmsOrigem, java.lang.String icmsCst, java.lang.String icmsModbc, double icmsRedbc, double icmsVbc, double icmsPicms, double icmsVicms, java.lang.String ipiCenq, java.lang.String ipintCst, java.lang.String pisaliqCst, double pisaliqVbc, double pisaliqPpis, double pisaliqVpis, java.lang.String cofinsaliqCst, double cofinsaliqVbc, double cofinsaliqPcofins, double cofinsaliqVcofins, double icmsPredbc, java.lang.String tipoTributacao, java.lang.String csosn, double vbcstret, double vicmsstret, java.lang.String pisntCst, java.lang.String cofinsntCst, java.lang.String infadprod, java.lang.String ipiCst, double ipiVbc, double ipiPipi, double ipiVipi, double vfcpufdest, double vfcp, double pvcp, double pmvast, double vbcst, double picmsst, double vicmsst) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    nFEServices.wbInserirProdutos(idNota, cprod, cean, xprod, ncm, cest, cfop, ucom, qcom, vuncom, vprod, ceantrib, utrib, qtrib, vuntrib, vdesc, voutros, indtotal, vtottrib, icmsOrigem, icmsCst, icmsModbc, icmsRedbc, icmsVbc, icmsPicms, icmsVicms, ipiCenq, ipintCst, pisaliqCst, pisaliqVbc, pisaliqPpis, pisaliqVpis, cofinsaliqCst, cofinsaliqVbc, cofinsaliqPcofins, cofinsaliqVcofins, icmsPredbc, tipoTributacao, csosn, vbcstret, vicmsstret, pisntCst, cofinsntCst, infadprod, ipiCst, ipiVbc, ipiPipi, ipiVipi, vfcpufdest, vfcp, pvcp, pmvast, vbcst, picmsst, vicmsst);
  }
  
  public java.lang.String wbDanfe(java.lang.String idNota) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbDanfe(idNota);
  }
  
  public java.lang.String wbRequisitarXmlQrcode(java.lang.String idNota) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbRequisitarXmlQrcode(idNota);
  }
  
  public java.lang.String wbEventoCancelamento(java.lang.String token, java.lang.String cnpj, java.lang.String chaveNf, java.lang.String NNf, java.lang.String justificativa, java.lang.String NProtocolo) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbEventoCancelamento(token, cnpj, chaveNf, NNf, justificativa, NProtocolo);
  }
  
  public java.lang.String wbNProtocoloSefaz(java.lang.String idNota) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    return nFEServices.wbNProtocoloSefaz(idNota);
  }
  
  public void wbInserirCombustivel(java.lang.String idNota, java.lang.String cprod, java.lang.String cean, java.lang.String xprod, java.lang.String ncm, java.lang.String cest, java.lang.String cfop, java.lang.String ucom, java.lang.String qcom, double vuncom, double vprod, java.lang.String ceantrib, java.lang.String utrib, double qtrib, double vuntrib, double vdesc, double voutros, long indtotal, double vtottrib, java.lang.String icmsOrigem, java.lang.String icmsCst, java.lang.String icmsModbc, double icmsRedbc, double icmsVbc, double icmsPicms, double icmsVicms, java.lang.String ipiCenq, java.lang.String ipintCst, java.lang.String pisaliqCst, double pisaliqVbc, double pisaliqPpis, double pisaliqVpis, java.lang.String cofinsaliqCst, double cofinsaliqVbc, double cofinsaliqPcofins, double cofinsaliqVcofins, double icmsPredbc, java.lang.String tipoTributacao, java.lang.String csosn, double vbcstret, double vicmsstret, java.lang.String pisntCst, java.lang.String cofinsntCst, java.lang.String infadprod, java.lang.String cprodAnp, double qtemp, java.lang.String ufCons, double qbcprod, double valiqprod, double vcide, java.lang.String codif, java.lang.String ipiCst, double ipiVbc, double ipiPipi, double ipiVipi) throws java.rmi.RemoteException{
    if (nFEServices == null)
      _initNFEServicesProxy();
    nFEServices.wbInserirCombustivel(idNota, cprod, cean, xprod, ncm, cest, cfop, ucom, qcom, vuncom, vprod, ceantrib, utrib, qtrib, vuntrib, vdesc, voutros, indtotal, vtottrib, icmsOrigem, icmsCst, icmsModbc, icmsRedbc, icmsVbc, icmsPicms, icmsVicms, ipiCenq, ipintCst, pisaliqCst, pisaliqVbc, pisaliqPpis, pisaliqVpis, cofinsaliqCst, cofinsaliqVbc, cofinsaliqPcofins, cofinsaliqVcofins, icmsPredbc, tipoTributacao, csosn, vbcstret, vicmsstret, pisntCst, cofinsntCst, infadprod, cprodAnp, qtemp, ufCons, qbcprod, valiqprod, vcide, codif, ipiCst, ipiVbc, ipiPipi, ipiVipi);
  }
  
  
}
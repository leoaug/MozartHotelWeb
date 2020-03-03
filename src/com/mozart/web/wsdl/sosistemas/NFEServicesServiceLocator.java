/**
 * NFEServicesServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.mozart.web.wsdl.sosistemas;

public class NFEServicesServiceLocator extends org.apache.axis.client.Service implements com.mozart.web.wsdl.sosistemas.NFEServicesService {

    public NFEServicesServiceLocator() {
    }


    public NFEServicesServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public NFEServicesServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for NFEServices
    private java.lang.String NFEServices_address = "http://api.sosistemas.com.br/NFE_v400/webservices/NFEServices.jws";

    public java.lang.String getNFEServicesAddress() {
        return NFEServices_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String NFEServicesWSDDServiceName = "NFEServices";

    public java.lang.String getNFEServicesWSDDServiceName() {
        return NFEServicesWSDDServiceName;
    }

    public void setNFEServicesWSDDServiceName(java.lang.String name) {
        NFEServicesWSDDServiceName = name;
    }

    public com.mozart.web.wsdl.sosistemas.NFEServices getNFEServices() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(NFEServices_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getNFEServices(endpoint);
    }

    public com.mozart.web.wsdl.sosistemas.NFEServices getNFEServices(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.mozart.web.wsdl.sosistemas.NFEServicesSoapBindingStub _stub = new com.mozart.web.wsdl.sosistemas.NFEServicesSoapBindingStub(portAddress, this);
            _stub.setPortName(getNFEServicesWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setNFEServicesEndpointAddress(java.lang.String address) {
        NFEServices_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.mozart.web.wsdl.sosistemas.NFEServices.class.isAssignableFrom(serviceEndpointInterface)) {
                com.mozart.web.wsdl.sosistemas.NFEServicesSoapBindingStub _stub = new com.mozart.web.wsdl.sosistemas.NFEServicesSoapBindingStub(new java.net.URL(NFEServices_address), this);
                _stub.setPortName(getNFEServicesWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("NFEServices".equals(inputPortName)) {
            return getNFEServices();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://api.sosistemas.com.br/NFE_v400/webservices/NFEServices.jws", "NFEServicesService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://api.sosistemas.com.br/NFE_v400/webservices/NFEServices.jws", "NFEServices"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("NFEServices".equals(portName)) {
            setNFEServicesEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
